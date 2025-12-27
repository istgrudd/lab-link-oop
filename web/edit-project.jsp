<%-- 
    Document   : edit-project
    Created on : 26 Dec 2025, 00.01.04
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.Project"%>
<%
    // Cek apakah ini mode Edit (ada data project) atau Tambah (null)
    Project p = (Project) request.getAttribute("project");
    boolean isEdit = (p != null);
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Edit Proyek" : "Tambah Proyek" %></title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        
        <main class="main-content">
            <header class="top-bar">
                <h1><%= isEdit ? "Edit Proyek" : "Proyek Baru" %></h1>
            </header>

            <div class="tasks-section" style="max-width: 600px; margin: 0 auto;">
                <form action="project" method="post">
                    <input type="hidden" name="action" value="<%= isEdit ? "update" : "save" %>">
                    <input type="hidden" name="projectID" value="<%= isEdit ? p.getProjectID() : "" %>">

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Nama Proyek</label>
                        <input type="text" name="projectName" required class="form-control" 
                               value="<%= isEdit ? p.getProjectName() : "" %>" 
                               style="width: 100%; padding: 10px; margin-top: 5px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Kategori</label>
                        <select name="category" class="form-control" style="width: 100%; padding: 10px;">
                            <option value="Riset" <%= isEdit && "Riset".equals(p.getActivityType()) ? "selected" : "" %>>Riset</option>
                            <option value="HKI" <%= isEdit && "HKI".equals(p.getActivityType()) ? "selected" : "" %>>HKI</option>
                            <option value="Pengabdian" <%= isEdit && "Pengabdian".equals(p.getActivityType()) ? "selected" : "" %>>Pengabdian Masyarakat</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Status</label>
                        <select name="status" class="form-control" style="width: 100%; padding: 10px;">
                            <option value="Ongoing" <%= isEdit && "Ongoing".equals(p.getStatus()) ? "selected" : "" %>>Ongoing</option>
                            <option value="Completed" <%= isEdit && "Completed".equals(p.getStatus()) ? "selected" : "" %>>Completed</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Nama Ketua (Leader)</label>
                        <input type="text" name="leaderName" required class="form-control"
                               value="<%= isEdit ? p.getLeaderName() : "" %>"
                               style="width: 100%; padding: 10px;">
                    </div>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label>Divisi</label>
                        <input type="text" name="division" required class="form-control"
                               value="<%= isEdit ? p.getDivision() : "" %>"
                               style="width: 100%; padding: 10px;">
                    </div>

                    <div class="form-group" style="display: flex; gap: 10px; margin-bottom: 20px;">
                        <div style="flex: 1;">
                            <label>Tanggal Mulai</label>
                            <input type="date" name="startDate" required class="form-control"
                                   value="<%= isEdit ? p.getStartDate() : "" %>" style="width: 100%; padding: 10px;">
                        </div>
                        <div style="flex: 1;">
                            <label>Tanggal Selesai (Deadline)</label>
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