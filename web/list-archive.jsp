<%-- 
    Document   : list-archive
    Created on : 26 Dec 2025, 22.01.39
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Archive"%>
<%@page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    List<Archive> listA = (List<Archive>) request.getAttribute("listArchive");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Arsip & Publikasi - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Arsip Publikasi & HKI</h1>
                        <p class="text-muted small">Kumpulan output hasil riset laboratorium</p>
                    </div>
                </header>

                <div class="tasks-section" style="width:100%;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: #e0f2f1; text-align: left; color: var(--secondary-color);">
                                <th style="padding: 15px; border-radius: 8px 0 0 8px;">Tipe</th>
                                <th style="padding: 15px;">Judul</th>
                                <th style="padding: 15px;">Lokasi / Jurnal</th>
                                <th style="padding: 15px;">No. Referensi</th>
                                <th style="padding: 15px;">Penulis Utama</th>
                                <th style="padding: 15px;">Tanggal</th>
                                <th style="padding: 15px; border-radius: 0 8px 8px 0;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listA != null && !listA.isEmpty()) { 
                                for (Archive a : listA) { %>
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 15px;">
                                    <% if("Publikasi".equals(a.getType())) { %>
                                        <span class="badge" style="background:#e3f2fd; color:#1976d2;">Publikasi</span>
                                    <% } else { %>
                                        <span class="badge badge-success">HKI</span>
                                    <% } %>
                                </td>
                                <td style="padding: 15px; font-weight:600;"><%= a.getTitle() %></td>
                                <td style="padding: 15px;"><%= a.getPublishLocation() %></td>
                                <td style="padding: 15px; color:#666;"><%= a.getReferenceNumber() %></td>
                                <td style="padding: 15px;"><%= a.getAuthorName() %></td>
                                <td style="padding: 15px;"><%= a.getPublishDate() %></td>
                                <td style="padding: 15px;">
                                     <form action="archive" method="post" onsubmit="return confirm('Hapus arsip ini?');" style="margin:0;">
                                        <input type="hidden" name="action" value="deleteArchive">
                                        <input type="hidden" name="id" value="<%= a.getArchiveID() %>">
                                        <button type="submit" style="background:none; border:none; color:#ef5350; cursor:pointer;" title="Hapus"><i class="fas fa-trash"></i></button>
                                     </form>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="7" class="empty-state">Belum ada arsip tersimpan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
        
        <nav class="bottom-nav">
             <a href="dashboard" class="bottom-nav-item"><i class="fas fa-home"></i> <span>Home</span></a>
             <a href="archive" class="bottom-nav-item active"><i class="fas fa-archive"></i> <span>Arsip</span></a>
             <a href="profile.jsp" class="bottom-nav-item"><i class="fas fa-user"></i> <span>Akun</span></a>
        </nav>
    </body>
</html>