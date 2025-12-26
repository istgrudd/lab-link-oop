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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard"><i class="bi bi-diagram-3-fill"></i> LabLink System</a>
                <div class="d-flex align-items-center">
                    <a href="dashboard" class="text-white me-3 text-decoration-none">Dashboard</a>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="card card-custom">
                <div class="card-header card-header-custom border-0">
                    <i class="bi bi-journal-bookmark-fill"></i> Arsip Publikasi & HKI
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom table-hover mb-0 text-nowrap">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tipe</th>
                                    <th>Judul</th>
                                    <th>Jurnal / Badan</th>
                                    <th>No. Ref (DOI)</th>
                                    <th>Penulis Utama</th>
                                    <th>Tanggal</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (listA != null && !listA.isEmpty()) { 
                                    for (Archive a : listA) { %>
                                <tr>
                                    <td><%= a.getArchiveID() %></td>
                                    <td>
                                        <% if("Publikasi".equals(a.getType())) { %>
                                            <span class="badge bg-primary">Publikasi</span>
                                        <% } else { %>
                                            <span class="badge bg-success">HKI</span>
                                        <% } %>
                                    </td>
                                    <td class="fw-bold text-wrap" style="max-width: 300px;"><%= a.getTitle() %></td>
                                    <td><%= a.getPublishLocation() %></td>
                                    <td><small class="text-muted"><%= a.getReferenceNumber() %></small></td>
                                    <td><%= a.getAuthorName() %></td>
                                    <td><%= a.getPublishDate() %></td>
                                    <td>
                                        <form action="archive" method="post" onsubmit="return confirm('Hapus arsip ini?');">
                                            <input type="hidden" name="action" value="deleteArchive">
                                            <input type="hidden" name="id" value="<%= a.getArchiveID() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                                <% }} else { %>
                                <tr><td colspan="8" class="text-center py-4">Belum ada arsip.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
