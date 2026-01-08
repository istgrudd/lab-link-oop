<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.lablink.model.Project"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="java.util.List"%>
<%
    Project p = (Project) request.getAttribute("project");
    List<ResearchAssistant> listMember = (List<ResearchAssistant>) request.getAttribute("listMember");
    boolean isEdit = (p != null);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Proyek" : "Tambah Proyek" %> - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        .checkbox-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 10px; max-height: 220px; overflow-y: auto; border: 2px solid var(--border-color); padding: 16px; border-radius: 12px; background: #f8fafc; }
        .checkbox-item { display: flex; align-items: center; font-size: 0.9rem; padding: 8px 12px; background: white; border-radius: 8px; border: 1px solid var(--border-color); transition: all 0.2s; }
        .checkbox-item:hover { border-color: var(--primary); }
        .checkbox-item input { width: 18px; height: 18px; margin-right: 10px; accent-color: var(--primary); }
        .checkbox-item label { cursor: pointer; flex: 1; }
    </style>
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section"><h1 class="page-title"><i class="fas fa-<%= isEdit ? "edit" : "plus-circle" %>"></i> <%= isEdit ? "Edit Proyek" : "Proyek Baru" %></h1><p class="page-subtitle"><%= isEdit ? "Perbarui informasi proyek" : "Tambahkan proyek riset baru" %></p></div>
                <div class="top-bar-right"><a href="project" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Kembali</a></div>
            </header>
            <div class="content-card" style="max-width: 900px;">
                <div class="card-body">
                    <form action="project" method="post">
                        <input type="hidden" name="action" value="<%= isEdit ? "update" : "save" %>">
                        <input type="hidden" name="projectID" value="<%= isEdit ? p.getProjectID() : "" %>">
                        <div class="form-group"><label class="form-label">Nama Proyek <span style="color: var(--danger);">*</span></label><input type="text" name="projectName" required class="form-control" value="<%= isEdit ? p.getProjectName() : "" %>" placeholder="Masukkan nama proyek"></div>
                        <div class="form-group"><label class="form-label">Deskripsi Proyek</label><textarea name="description" class="form-control" rows="4" placeholder="Jelaskan tujuan dan detail proyek..."><%= (isEdit && p.getDescription() != null) ? p.getDescription() : "" %></textarea></div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group"><label class="form-label">Kategori</label><select name="category" class="form-control"><option value="Riset" <%= isEdit && "Riset".equals(p.getActivityType()) ? "selected" : "" %>>Riset</option><option value="HKI" <%= isEdit && "HKI".equals(p.getActivityType()) ? "selected" : "" %>>HKI</option><option value="Pengabdian" <%= isEdit && "Pengabdian".equals(p.getActivityType()) ? "selected" : "" %>>Pengabdian Masyarakat</option></select></div>
                            <div class="form-group"><label class="form-label">Status</label><select name="status" class="form-control"><option value="Ongoing" <%= isEdit && "Ongoing".equals(p.getStatus()) ? "selected" : "" %>>Ongoing</option><option value="Completed" <%= isEdit && "Completed".equals(p.getStatus()) ? "selected" : "" %>>Completed</option></select></div>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group"><label class="form-label">Divisi <span style="color: var(--danger);">*</span></label><select name="division" class="form-control" required><option value="">-- Pilih Divisi --</option><option value="Big Data" <%= isEdit && "Big Data".equals(p.getDivision()) ? "selected" : "" %>>Big Data</option><option value="Cyber Security" <%= isEdit && "Cyber Security".equals(p.getDivision()) ? "selected" : "" %>>Cyber Security</option><option value="GIS" <%= isEdit && "GIS".equals(p.getDivision()) ? "selected" : "" %>>GIS</option><option value="Game Tech" <%= isEdit && "Game Tech".equals(p.getDivision()) ? "selected" : "" %>>Game Tech</option></select></div>
                            <div class="form-group"><label class="form-label">Ketua Proyek <span style="color: var(--danger);">*</span></label><select name="leaderID" class="form-control" required><option value="">-- Pilih Ketua --</option><% if (listMember != null) { for (ResearchAssistant ra : listMember) { String selected = (isEdit && ra.getMemberID().equals(p.getLeaderID())) ? "selected" : ""; %><option value="<%= ra.getMemberID() %>" <%= selected %>><%= ra.getName() %></option><% }} %></select></div>
                        </div>
                        <div class="form-group"><label class="form-label">Anggota Tim</label>
                            <div class="checkbox-grid"><% if (listMember != null) { for (ResearchAssistant ra : listMember) { boolean isChecked = false; if (isEdit && p.getTeamMemberIDs() != null) { for(String id : p.getTeamMemberIDs()) { if(id.equals(ra.getMemberID())) { isChecked = true; break; } } } %><div class="checkbox-item"><input type="checkbox" name="teamMembers" value="<%= ra.getMemberID() %>" id="m_<%= ra.getMemberID() %>" <%= isChecked ? "checked" : "" %>><label for="m_<%= ra.getMemberID() %>"><%= ra.getName() %><span style="color: var(--text-muted); font-size: 0.75rem; display: block;"><%= ra.getExpertDivision() %></span></label></div><% }} %></div>
                            <small style="color: var(--text-muted); margin-top: 8px; display: block;"><i class="fas fa-info-circle"></i> Ketua Proyek tidak perlu dicentang lagi.</small>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group"><label class="form-label">Tanggal Mulai <span style="color: var(--danger);">*</span></label><input type="date" name="startDate" required class="form-control" value="<%= isEdit ? p.getStartDate() : "" %>"></div>
                            <div class="form-group"><label class="form-label">Deadline <span style="color: var(--danger);">*</span></label><input type="date" name="endDate" required class="form-control" value="<%= isEdit ? p.getEndDate() : "" %>"></div>
                        </div>
                        <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--border-color);"><a href="project" class="btn btn-outline">Batal</a><button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button></div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
