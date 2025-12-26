<%-- 
    Document   : list-member
    Created on : 25 Nov 2025, 03.04.08
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
            
            <% if (user.getAccessRole().equals("HEAD_OF_LAB")) { %>
            <div class="card card-custom mb-4">
                <div class="card-header card-header-custom">
                    + Tambah Anggota Baru
                </div>
                <div class="card-body card-body-custom">
                    <form action="member" method="post">
                        <div class="row g-3">
                            <div class="col-md-2">
                                <label class="form-label">Member ID</label>
                                <input type="text" name="id" class="form-control" placeholder="1030..." required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Nama Lengkap</label>
                                <input type="text" name="name" class="form-control" placeholder="Nama..." required>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Divisi</label>
                                <select name="division" class="form-select">
                                    <option value="Big Data">Big Data</option>
                                    <option value="Cyber Security">Cyber Security</option>
                                    <option value="GIS">GIS</option>
                                    <option value="Game Tech">Game Tech</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Departemen</label>
                                <select name="department" class="form-select">
                                    <option value="Internal">Internal</option>
                                    <option value="Eksternal">Eksternal</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Jabatan</label>
                                <input type="text" name="role" class="form-control" placeholder="Ex: Staff">
                            </div>
                            <div class="col-md-1 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary-custom">Simpan</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

            <div class="card card-custom">
                <div class="card-header card-header-custom border-0">
                    Daftar Research Assistant
                </div>
                <div class="card-body p-0"> 
                    <div class="table-responsive">
                        <table class="table table-custom table-hover mb-0 text-nowrap">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Nama</th>
                                    <th>Divisi</th>
                                    <th>Departemen</th>
                                    <th>Jabatan</th>
                                    <th>Workload</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<ResearchAssistant> list = (List<ResearchAssistant>) request.getAttribute("listRA");
                                    if (list != null && !list.isEmpty()) {
                                        for (ResearchAssistant ra : list) {
                                %>
                                <tr>
                                    <td class="fw-bold text-secondary"><%= ra.getMemberID() %></td>
                                    <td class="fw-bold"><%= ra.getName() %></td>
                                    <td><%= ra.getExpertDivision() %></td>
                                    <td><span class="badge bg-secondary"><%= ra.getDepartment() %></span></td>
                                    <td><span class="badge bg-info text-dark badge-role"><%= ra.getRoleTitle() %></span></td>
                                    <td><%= ra.calculateWorkload() %> Jam</td>
                                </tr>
                                <% 
                                        }
                                    } else { 
                                %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">Belum ada data anggota.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div> </div>
            </div>
            
            <div class="text-center text-muted mt-4 mb-5">
                <small>&copy; 2025 LabLink System - Telkom University</small>
            </div>

        </div>
    </body>
</html>