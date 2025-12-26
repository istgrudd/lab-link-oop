<%-- 
    Document   : profile
    Created on : 25 Dec 2025, 21.46.39
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    // Ambil data user dari session
    LabMember userSession = (LabMember) session.getAttribute("user");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Casting agar bisa ambil data spesifik RA (division, dept)
    ResearchAssistant user = null;
    if (userSession instanceof ResearchAssistant) {
        user = (ResearchAssistant) userSession;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Profil Saya - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
        
                <a class="navbar-brand" href="dashboard">
                    <i class="bi bi-diagram-3-fill"></i> LabLink System
                </a>

                <div class="d-flex align-items-center">
            
                <a href="dashboard" class="text-white me-3 text-decoration-none">Dashboard</a>
            
                <span class="text-white me-3">
                    Halo, 
                    <a href="profile" class="text-white text-decoration-none fw-bold" title="Edit Profil">
                        <%= user.getName() %>
                    </a>
                    <span class="badge bg-light text-primary ms-1"><%= user.getAccessRole() %></span>
                </span>
                <a href="logout" class="btn btn-sm btn-logout">Logout</a>
            
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="row">
                
                <div class="col-md-8">
                    <div class="card card-custom">
                        <div class="card-header card-header-custom">
                            Edit Profil Saya
                        </div>
                        <div class="card-body card-body-custom">
                            
                            <% if (request.getAttribute("msgInfo") != null) { %>
                                <div class="alert alert-<%= request.getAttribute("msgType") %>">
                                    <%= request.getAttribute("msgInfo") %>
                                </div>
                            <% } %>

                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="updateInfo">
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Member ID (NIM)</label>
                                        <input type="text" class="form-control" value="<%= user.getMemberID() %>" disabled readonly>
                                        <small class="text-muted">ID tidak dapat diubah.</small>
                                    </div>
                                    <% 
                                        boolean isAdmin = "HEAD_OF_LAB".equals(user.getAccessRole());
                                        
                                        // Jika Admin, string kosong (""). Jika bukan, "disabled readonly"
                                        String lockStatus = isAdmin ? "" : "disabled readonly"; 
                                        
                                        // Pesan bantuan di bawah input
                                        String helpText = isAdmin ? "Anda memiliki akses penuh mengubah ini." : "Jabatan diatur oleh Admin.";
                                        
                                        // Handle tampilan null agar tidak jelek
                                        String showJabatan = (user.getRoleTitle() == null) ? "" : user.getRoleTitle();
                                    %>

                                    <div class="col-md-6">
                                        <label class="form-label">Jabatan</label>
                                        
                                        <input type="text" name="role" class="form-control" 
                                               value="<%= showJabatan %>" <%= lockStatus %>>
                                               
                                        <small class="text-muted"><%= helpText %></small>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Nama Lengkap</label>
                                    <input type="text" name="name" class="form-control" value="<%= user.getName() %>" required>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Divisi Keahlian</label>
                                        <select name="division" class="form-select">
                                            <option value="Big Data" <%= "Big Data".equals(user.getExpertDivision()) ? "selected" : "" %>>Big Data</option>
                                            <option value="Cyber Security" <%= "Cyber Security".equals(user.getExpertDivision()) ? "selected" : "" %>>Cyber Security</option>
                                            <option value="GIS" <%= "GIS".equals(user.getExpertDivision()) ? "selected" : "" %>>GIS</option>
                                            <option value="Game Tech" <%= "Game Tech".equals(user.getExpertDivision()) ? "selected" : "" %>>Game Tech</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Departemen</label>
                                        <select name="department" class="form-select">
                                            <option value="Internal" <%= "Internal".equals(user.getDepartment()) ? "selected" : "" %>>Internal</option>
                                            <option value="Eksternal" <%= "Eksternal".equals(user.getDepartment()) ? "selected" : "" %>>Eksternal</option>
                                        </select>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary-custom">Simpan Perubahan</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card card-custom">
                        <div class="card-header card-header-custom text-danger">
                            Ganti Password
                        </div>
                        <div class="card-body card-body-custom">
                            
                            <% if (request.getAttribute("msgPass") != null) { %>
                                <div class="alert alert-<%= request.getAttribute("msgTypePass") %>">
                                    <%= request.getAttribute("msgPass") %>
                                </div>
                            <% } %>

                            <form action="profile" method="post">
                                <input type="hidden" name="action" value="changePassword">
                                
                                <div class="mb-3">
                                    <label class="form-label">Password Baru</label>
                                    <input type="password" name="newPassword" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Konfirmasi Password</label>
                                    <input type="password" name="confirmPassword" class="form-control" required>
                                </div>
                                <button type="submit" class="btn btn-danger w-100">Update Password</button>
                            </form>
                        </div>
                    </div>
                    
                    <div class="text-center mt-3">
                        <a href="dashboard" class="text-decoration-none">&larr; Kembali ke Dashboard</a>
                    </div>
                </div>

            </div>
        </div>
    </body>
</html>