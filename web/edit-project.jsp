<%-- 
    Document   : edit-project
    Created on : 26 Dec 2025, 00.01.04
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="java.util.List"%>

<%
    Project p = (Project) request.getAttribute("project");
    List<ResearchAssistant> listMember = (List<ResearchAssistant>) request.getAttribute("listMember");
    boolean isEdit = (p != null);
%>

<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit Proyek" : "Tambah Proyek" %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Style Tambahan untuk Checkbox Grid */
        .checkbox-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 10px;
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            background: #f9f9f9;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
        }
        .checkbox-item input { margin-right: 8px; }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-bar">
                <h1><%= isEdit ? "Edit Proyek" : "Proyek Baru" %></h1>
            </header>

            <div class="tasks-section" style="max-width: 800px; margin: 0 auto;">
                <form action="project" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "save" %>">
                    <input type="hidden" name="projectID" value="<%= isEdit ? p.getProjectID() : "" %>">

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Nama Proyek</label>
                        <input type="text" name="projectName" required class="form-control" 
                               value="<%= isEdit ? p.getProjectName() : "" %>" 
                               style="width: 100%; padding: 10px;">
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Deskripsi Proyek</label>
                        <textarea name="description" class="form-control" rows="3" 
                                  style="width: 100%; padding: 10px;" 
                                  placeholder="Jelaskan tujuan dan detail proyek..."><%= (isEdit && p.getDescription() != null) ? p.getDescription() : "" %></textarea>
                    </div>

                    <div class="row" style="display: flex; gap: 20px;">
                        <div class="form-group" style="flex: 1; margin-bottom: 15px;">
                            <label>Kategori</label>
                            <select name="category" class="form-control" style="width: 100%; padding: 10px;">
                                <option value="Riset" <%= isEdit && "Riset".equals(p.getActivityType()) ? "selected" : "" %>>Riset</option>
                                <option value="HKI" <%= isEdit && "HKI".equals(p.getActivityType()) ? "selected" : "" %>>HKI</option>
                                <option value="Pengabdian" <%= isEdit && "Pengabdian".equals(p.getActivityType()) ? "selected" : "" %>>Pengabdian Masyarakat</option>
                            </select>
                        </div>
                        <div class="form-group" style="flex: 1; margin-bottom: 15px;">
                            <label>Status</label>
                            <select name="status" class="form-control" style="width: 100%; padding: 10px;">
                                <option value="Ongoing" <%= isEdit && "Ongoing".equals(p.getStatus()) ? "selected" : "" %>>Ongoing</option>
                                <option value="Completed" <%= isEdit && "Completed".equals(p.getStatus()) ? "selected" : "" %>>Completed</option>
                            </select>
                        </div>
                    </div>

                    <div class="row" style="display: flex; gap: 20px;">
                         <div class="form-group" style="flex: 1; margin-bottom: 15px;">
                            <label>Divisi</label>
                            <select name="division" class="form-control" style="width: 100%; padding: 10px;" required>
                                <option value="">-- Pilih Divisi --</option>
                                <% 
                                String[] divs = {"Big Data", "Cyber Security", "GIS", "Game Tech"};
                                for(String d : divs) {
                                    String sel = (isEdit && d.equals(p.getDivision())) ? "selected" : "";
                                %>
                                    <option value="<%= d %>" <%= sel %>><%= d %></option>
                                <% } %>
                            </select>
                        </div>
                         <div class="form-group" style="flex: 1; margin-bottom: 15px;">
                            <label>Ketua Proyek</label>
                            <select name="leaderID" class="form-control" style="width: 100%; padding: 10px;" required>
                                <option value="">-- Pilih Ketua --</option>
                                <% 
                                if (listMember != null) {
                                    for (ResearchAssistant ra : listMember) {
                                        String selected = (isEdit && ra.getMemberID().equals(p.getLeaderID())) ? "selected" : "";
                                %>
                                    <option value="<%= ra.getMemberID() %>" <%= selected %>>
                                        <%= ra.getName() %>
                                    </option>
                                <% 
                                    }
                                } 
                                %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label>Anggota Tim (Pilih Banyak)</label>
                        <div class="checkbox-grid">
                            <% 
                            if (listMember != null) {
                                for (ResearchAssistant ra : listMember) {
                                    // Cek apakah member ini sudah ada di tim (untuk mode edit)
                                    boolean isChecked = false;
                                    if (isEdit && p.getTeamMemberIDs() != null) {
                                        for(String id : p.getTeamMemberIDs()) {
                                            if(id.equals(ra.getMemberID())) {
                                                isChecked = true;
                                                break;
                                            }
                                        }
                                    }
                            %>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="teamMembers" value="<%= ra.getMemberID() %>" 
                                           id="m_<%= ra.getMemberID() %>" <%= isChecked ? "checked" : "" %>>
                                    <label for="m_<%= ra.getMemberID() %>">
                                        <%= ra.getName() %> <small class="text-muted">(<%= ra.getExpertDivision() %>)</small>
                                    </label>
                                </div>
                            <% 
                                }
                            } 
                            %>
                        </div>
                        <small class="text-muted">*Ketua Proyek tidak perlu dicentang lagi.</small>
                    </div>

                    <div class="form-group" style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <div style="flex: 1;">
                            <label>Mulai</label>
                            <input type="date" name="startDate" required class="form-control"
                                   value="<%= isEdit ? p.getStartDate() : "" %>" style="width: 100%; padding: 10px;">
                        </div>
                        <div style="flex: 1;">
                            <label>Deadline</label>
                            <input type="date" name="endDate" required class="form-control"
                                   value="<%= isEdit ? p.getEndDate() : "" %>" style="width: 100%; padding: 10px;">
                        </div>
                    </div>

                    <button type="submit" class="btn-small" style="background: var(--primary-color); color: white; border: none; padding: 12px 20px; cursor: pointer;">
                        <i class="fas fa-save"></i> Simpan Data
                    </button>
                    <a href="project" style="margin-left: 10px; text-decoration: none; color: #666;">Batal</a>
                </form>
            </div>
        </main>
    </div>
</body>
</html>