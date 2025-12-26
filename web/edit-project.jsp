<%-- 
    Document   : edit-project
    Created on : 26 Dec 2025, 00.01.04
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.LabMember"%>
<%@page import="com.lablink.model.ProjectTeamMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Ambil data project yang dikirim Controller
    Project p = (Project) request.getAttribute("project");
    
    // [BARU] Ambil list tim dari atribut request
    List<ProjectTeamMember> listTeam = (List<ProjectTeamMember>) request.getAttribute("listTeam");

    if (p == null) { response.sendRedirect("project"); return; }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Proyek - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard">LabLink System</a>
            </div>
        </nav>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">Edit Data Proyek</div>
                        <div class="card-body card-body-custom">
                            
                            <form action="project" method="post">
                                <input type="hidden" name="action" value="updateProject">
                                
                                <div class="mb-3">
                                    <label class="form-label">Kode Proyek</label>
                                    <input type="text" name="id" class="form-control" value="<%= p.getProjectID() %>" readonly>
                                    <small class="text-muted">Kode proyek tidak dapat diubah.</small>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Nama Proyek</label>
                                    <input type="text" name="name" class="form-control" value="<%= p.getProjectName() %>" required>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Divisi</label>
                                        <select name="division" class="form-select">
                                            <option value="Big Data" <%= "Big Data".equals(p.getDivision()) ? "selected" : "" %>>Big Data</option>
                                            <option value="Cyber Security" <%= "Cyber Security".equals(p.getDivision()) ? "selected" : "" %>>Cyber Security</option>
                                            <option value="GIS" <%= "GIS".equals(p.getDivision()) ? "selected" : "" %>>GIS</option>
                                            <option value="Game Tech" <%= "Game Tech".equals(p.getDivision()) ? "selected" : "" %>>Game Tech</option>
                                            <option value="Lintas Divisi" <%= "Lintas Divisi".equals(p.getDivision()) ? "selected" : "" %>>Lintas Divisi</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Tipe</label>
                                        <select name="type" class="form-select">
                                            <option value="Riset" <%= "Riset".equals(p.getActivityType()) ? "selected" : "" %>>Riset</option>
                                            <option value="HKI" <%= "HKI".equals(p.getActivityType()) ? "selected" : "" %>>HKI</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Status</label>
                                        <select name="status" class="form-select">
                                            <option value="Ongoing" <%= "Ongoing".equals(p.getStatus()) ? "selected" : "" %>>Ongoing</option>
                                            <option value="Completed" <%= "Completed".equals(p.getStatus()) ? "selected" : "" %>>Completed</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <a href="project" class="btn btn-outline-secondary">Batal</a>
                                    <button type="submit" class="btn btn-primary-custom" style="width: auto;">Simpan Perubahan</button>
                                </div>
                            </form>

                        </div>
                    </div>

                    <div class="card card-custom mt-4 mb-5">
                        <div class="card-header card-header-custom bg-light d-flex justify-content-between align-items-center">
                            <span>Manajemen Anggota Tim</span>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0 align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">Nama Anggota</th>
                                        <th class="text-end pe-4">Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (listTeam != null && !listTeam.isEmpty()) { 
                                        for (ProjectTeamMember tm : listTeam) { 
                                    %>
                                    <tr>
                                        <td class="ps-4 fw-bold"><%= tm.getMemberName() %></td>
                                        <td class="text-end pe-4">
                                            <form action="project" method="post" onsubmit="return confirm('Keluarkan <%= tm.getMemberName() %> dari proyek ini?');">
                                                <input type="hidden" name="action" value="removeMember">
                                                <input type="hidden" name="projectID" value="<%= p.getProjectID() %>">
                                                <input type="hidden" name="memberID" value="<%= tm.getMemberID() %>">
                                                
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Keluarkan dari Tim">
                                                    <i class="bi bi-trash"></i> Hapus
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% }} else { %>
                                    <tr>
                                        <td colspan="2" class="text-center py-4 text-muted">
                                            Belum ada anggota tim. Silakan tambahkan melalui halaman utama Proyek.
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </body>
</html>