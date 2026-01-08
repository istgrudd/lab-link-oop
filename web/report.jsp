<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.Project"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    Map<String, Integer> s = (Map<String, Integer>) request.getAttribute("summary");
    List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
    List<Project> listP = (List<Project>) request.getAttribute("listProject");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Kinerja - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        @media print { .sidebar, .bottom-nav, .no-print { display: none !important; } .main-content { margin-left: 0 !important; width: 100% !important; padding: 20px !important; } body { background: white !important; } .print-title { display: block !important; } .print-signature { display: block !important; } }
        .print-title { display: none; text-align: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid var(--secondary); }
        .print-signature { display: none; margin-top: 60px; text-align: right; }
    </style>
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar no-print">
                <div class="welcome-section"><h1 class="page-title"><i class="fas fa-chart-bar"></i> Pusat Laporan</h1><p class="page-subtitle">Rekapitulasi Kinerja Laboratorium</p></div>
                <div class="top-bar-right"><button onclick="window.print()" class="btn btn-secondary"><i class="fas fa-print"></i> Cetak Laporan</button></div>
            </header>
            <div class="print-title"><h2 style="margin: 0; color: var(--secondary);">LAPORAN KINERJA LABORATORIUM</h2><h3 style="margin: 8px 0; color: var(--primary);">MBC LABORATORY - TELKOM UNIVERSITY</h3><p style="color: var(--text-muted);">Periode: 2025</p></div>
            <section class="stats-section" style="margin-bottom: 24px;">
                <div class="stat-card"><div class="stat-icon blue"><i class="fas fa-users"></i></div><div class="stat-info"><h3 class="stat-value"><%= s != null ? s.get("totalMember") : 0 %></h3><p class="stat-label">Total Anggota</p></div></div>
                <div class="stat-card"><div class="stat-icon green"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h3 class="stat-value"><%= s != null ? s.get("projectCompleted") : 0 %></h3><p class="stat-label">Proyek Selesai</p></div></div>
                <div class="stat-card"><div class="stat-icon orange"><i class="fas fa-spinner"></i></div><div class="stat-info"><h3 class="stat-value"><%= s != null ? s.get("projectOngoing") : 0 %></h3><p class="stat-label">Proyek Berjalan</p></div></div>
                <div class="stat-card"><div class="stat-icon purple"><i class="fas fa-trophy"></i></div><div class="stat-info"><h3 class="stat-value"><%= s != null ? (s.getOrDefault("totalPublikasi", 0) + s.getOrDefault("totalHKI", 0)) : 0 %></h3><p class="stat-label">Total Output</p></div></div>
            </section>
            <div class="content-card" style="margin-bottom: 24px;">
                <div class="card-header"><h2><i class="fas fa-users"></i> 1. Rekapitulasi Anggota Riset</h2></div>
                <div class="card-body" style="padding: 0;">
                    <table class="data-table">
                        <thead><tr><th style="width: 50px;">No</th><th>Nama</th><th>Divisi</th><th>Jabatan</th></tr></thead>
                        <tbody>
                            <% if (listM != null && !listM.isEmpty()) { int no = 1; for(ResearchAssistant ra : listM) { %>
                            <tr><td style="text-align: center;"><%= no++ %></td><td style="font-weight: 600;"><%= ra.getName() %></td><td><span class="badge badge-primary"><%= ra.getExpertDivision() %></span></td><td><%= ra.getRoleTitle() != null ? ra.getRoleTitle() : "-" %></td></tr>
                            <% }} else { %>
                            <tr><td colspan="4" class="empty-state"><p>Belum ada data anggota</p></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="content-card">
                <div class="card-header"><h2><i class="fas fa-project-diagram"></i> 2. Rekapitulasi Aktivitas Proyek</h2></div>
                <div class="card-body" style="padding: 0;">
                    <table class="data-table">
                        <thead><tr><th>Kode</th><th>Judul Proyek</th><th>Leader</th><th>Status</th></tr></thead>
                        <tbody>
                            <% if (listP != null && !listP.isEmpty()) { for(Project p : listP) { %>
                            <tr><td style="color: var(--text-muted);"><%= p.getProjectID() %></td><td style="font-weight: 600;"><%= p.getProjectName() %></td><td><%= p.getLeaderName() == null ? "-" : p.getLeaderName() %></td><td><span class="badge <%= "Completed".equals(p.getStatus()) ? "badge-success" : "badge-warning" %>"><%= p.getStatus() %></span></td></tr>
                            <% }} else { %>
                            <tr><td colspan="4" class="empty-state"><p>Belum ada data proyek</p></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="print-signature"><p>Bandung, ...............................</p><br><br><br><p style="font-weight: bold; text-decoration: underline;"><%= user.getName() %></p><p>Ketua Laboratorium</p></div>
        </main>
    </div>
    <script>window.onbeforeprint = function() { document.querySelector('.print-signature').style.display = 'block'; document.querySelector('.print-title').style.display = 'block'; }; window.onafterprint = function() { document.querySelector('.print-signature').style.display = 'none'; document.querySelector('.print-title').style.display = 'none'; };</script>
</body>
</html>
