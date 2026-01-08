<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.lablink.model.Project"%>
<%
    Project p = (Project) request.getAttribute("sourceProject");
    if (p == null) { response.sendRedirect("project"); return; }
    
    // Map project category to archive type
    String activityType = p.getActivityType();
    String archiveType;
    if ("Riset".equals(activityType)) {
        archiveType = "Publikasi";
    } else if ("HKI".equals(activityType)) {
        archiveType = "HKI";
    } else {
        archiveType = "Pengabdian"; // Pengabdian Masyarakat
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buat Arsip - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section"><h1 class="page-title"><i class="fas fa-file-archive"></i> Arsipkan Proyek</h1><p class="page-subtitle">Simpan output hasil riset ke arsip</p></div>
                <div class="top-bar-right"><a href="project" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Kembali</a></div>
            </header>
            <div class="content-card" style="max-width: 700px;">
                <div class="card-body">
                    <div style="padding: 16px 20px; background: linear-gradient(135deg, var(--blue-light), #dbeafe); border-radius: 12px; margin-bottom: 24px; display: flex; align-items: center; gap: 16px;">
                        <div style="width: 48px; height: 48px; background: var(--blue); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white;"><i class="fas fa-project-diagram"></i></div>
                        <div><p style="color: var(--text-muted); font-size: 0.8rem; margin: 0;">Sumber Proyek</p><h3 style="margin: 4px 0 0 0; color: var(--secondary);"><%= p.getProjectName() %></h3><span class="badge badge-info" style="margin-top: 6px;"><%= p.getProjectID() %></span></div>
                    </div>
                    <form action="archive" method="post">
                        <input type="hidden" name="action" value="saveArchive">
                        <input type="hidden" name="projectID" value="<%= p.getProjectID() %>">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="form-group"><label class="form-label">Tipe Output</label><input type="text" name="type" class="form-control" value="<%= archiveType %>" readonly style="background: #f1f5f9;"></div>
                            <div class="form-group"><label class="form-label">Tanggal Terbit/Grant <span style="color: var(--danger);">*</span></label><input type="date" name="date" class="form-control" required></div>
                        </div>
                        <div class="form-group"><label class="form-label">Judul Publikasi / HKI <span style="color: var(--danger);">*</span></label><input type="text" name="title" class="form-control" value="<%= p.getProjectName() %>" required></div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div class="form-group"><label class="form-label">Nama Jurnal / Badan HKI <span style="color: var(--danger);">*</span></label><input type="text" name="location" class="form-control" placeholder="Contoh: IEEE Access / DJKI" required></div>
                            <div class="form-group"><label class="form-label">No. Referensi (DOI / No. Reg) <span style="color: var(--danger);">*</span></label><input type="text" name="refNum" class="form-control" placeholder="Contoh: 10.1109/... atau IDM000..." required></div>
                        </div>
                        <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px; padding-top: 24px; border-top: 1px solid var(--border-color);"><a href="project" class="btn btn-outline">Batal</a><button type="submit" class="btn btn-primary"><i class="fas fa-archive"></i> Simpan ke Arsip</button></div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
