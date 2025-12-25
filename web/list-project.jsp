<%-- 
    Document   : list-project
    Created on : 25 Dec 2025, 22.50.34
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    boolean isAdmin = "HEAD_OF_LAB".equals(user.getAccessRole());
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Manajemen Proyek - LabLink</title>
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
            
            <% if (isAdmin) { %>
            <div class="card card-custom mb-4">
                <div class="card-header card-header-custom">+ Buat Proyek Baru</div>
                <div class="card-body card-body-custom">
                    <form action="project" method="post">
                        <input type="hidden" name="action" value="addProject">
                        <div class="row g-3">
                            <div class="col-md-2">
                                <label class="form-label">Kode Proyek</label>
                                <input type="text" name="id" class="form-control" placeholder="PRJ-01" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Nama Proyek</label>
                                <input type="text" name="name" class="form-control" placeholder="Judul..." required>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Tipe</label>
                                <select name="type" class="form-select">
                                    <option value="Riset">Riset</option>
                                    <option value="HKI">HKI</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-select">
                                    <option value="Ongoing">Ongoing</option>
                                    <option value="Completed">Completed</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary-custom">Buat Proyek</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

            <div class="card card-custom">
                <div class="card-header card-header-custom">Daftar Aktivitas Lab</div>
                <div class="card-body p-0">
                    <table class="table table-custom table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Kode</th>
                                <th>Nama Proyek</th>
                                <th>Tipe</th>
                                <th>Status</th>
                                <th>Tim (Member)</th>
                                <% if (isAdmin) { %> <th>Aksi</th> <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<Project> listP = (List<Project>) request.getAttribute("listProject");
                                List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
                                
                                if (listP != null && !listP.isEmpty()) {
                                    for (Project p : listP) {
                            %>
                            <tr>
                                <td><%= p.getProjectID() %></td>
                                <td class="fw-bold"><%= p.getProjectName() %></td>
                                <td><span class="badge bg-secondary"><%= p.getActivityType() %></span></td>
                                <td>
                                    <% if("Ongoing".equals(p.getStatus())) { %>
                                        <span class="badge bg-warning text-dark">Ongoing</span>
                                    <% } else { %>
                                        <span class="badge bg-success">Completed</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% for(String memberName : p.getTeamMembers()) { %>
                                        <span class="badge bg-info text-dark mb-1"><%= memberName %></span>
                                    <% } %>
                                    
                                    <% if (p.getTeamMembers().isEmpty()) { %>
                                        <small class="text-muted">Belum ada tim</small>
                                    <% } %>
                                </td>
                                
                                <% if (isAdmin) { %>
                                <td>
                                    <form action="project" method="post" class="d-flex gap-1">
                                        <input type="hidden" name="action" value="assignMember">
                                        <input type="hidden" name="projectID" value="<%= p.getProjectID() %>">
                                        
                                        <select name="memberID" class="form-select form-select-sm" style="width: 120px;">
                                            <option value="">+ Member</option>
                                            <% if(listM != null) { 
                                                for(ResearchAssistant ra : listM) { %>
                                                <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                            <% }} %>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-outline-primary">Add</button>
                                    </form>
                                </td>
                                <% } %>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr><td colspan="6" class="text-center py-3">Belum ada proyek.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </body>
</html>
