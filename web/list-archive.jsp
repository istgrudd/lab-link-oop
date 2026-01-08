<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lablink.model.Archive"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    List<Archive> listA = (List<Archive>) request.getAttribute("listArchive");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arsip & Publikasi - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section"><h1 class="page-title"><i class="fas fa-archive"></i> Arsip Publikasi & HKI</h1><p class="page-subtitle">Kumpulan output hasil riset laboratorium</p></div>
            </header>
            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <table class="data-table">
                        <thead><tr><th>Tipe</th><th>Judul</th><th>Lokasi / Jurnal</th><th>No. Referensi</th><th>Penulis Utama</th><th>Tanggal</th><th>Aksi</th></tr></thead>
                        <tbody>
                            <% if (listA != null && !listA.isEmpty()) { for (Archive a : listA) { %>
                            <tr>
                                <td><% if("Publikasi".equals(a.getType())) { %><span class="badge badge-info"><i class="fas fa-book"></i> Publikasi</span><% } else { %><span class="badge badge-success"><i class="fas fa-certificate"></i> HKI</span><% } %></td>
                                <td style="font-weight: 600; color: var(--secondary); max-width: 250px;"><%= a.getTitle() %></td>
                                <td><%= a.getPublishLocation() %></td>
                                <td style="color: var(--text-muted); font-size: 0.85rem;"><%= a.getReferenceNumber() %></td>
                                <td><%= a.getAuthorName() %></td>
                                <td><%= a.getPublishDate() %></td>
                                <td>
                                    <form action="archive" method="post" onsubmit="return confirm('Hapus arsip ini?');" style="margin: 0;">
                                        <input type="hidden" name="action" value="deleteArchive">
                                        <input type="hidden" name="id" value="<%= a.getArchiveID() %>">
                                        <button type="submit" class="btn btn-sm btn-icon" style="background: var(--danger-light); color: var(--danger);" title="Hapus"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="7" class="empty-state"><i class="fas fa-archive"></i><p>Belum ada arsip tersimpan</p><p style="font-size: 0.8rem; margin-top: 8px;">Arsipkan proyek yang sudah selesai dari halaman Proyek</p></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
