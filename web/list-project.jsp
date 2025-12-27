<%-- 
    Document   : list-project
    Created on : 25 Dec 2025, 22.50.34
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.LabMember"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>

<%
    // 1. Cek Session & Role
    LabMember currentUser = (LabMember) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Logic RBAC: Ketua Eksternal TIDAK BOLEH kelola proyek (hanya lihat)
    boolean canManageProject = !currentUser.getAccessRole().equalsIgnoreCase("HEAD_OF_EXTERNAL");
    
    // Ambil Data dari Controller
    List<Project> projectList = (List<Project>) request.getAttribute("projectList");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manajemen Proyek - LabLink</title>
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>

        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" /> 

            <main class="main-content">
                
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Manajemen Proyek</h1>
                        <p class="text-muted small">Daftar dan status proyek riset lab</p>
                    </div>
                    
                    <div class="date-display">
                        <i class="far fa-calendar-alt me-2"></i>
                        <% 
                            LocalDate today = LocalDate.now();
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("id", "ID"));
                        %>
                        <%= today.format(formatter) %>
                    </div>
                </header>

                <% if (errorMessage != null) { %>
                    <div style="background: #ffebee; color: #c62828; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #ef9a9a; display: flex; align-items: center;">
                        <i class="fas fa-exclamation-circle" style="margin-right: 10px; font-size: 1.2rem;"></i> 
                        <span><%= errorMessage %></span>
                    </div>
                <% } %>

                <% if (canManageProject) { %>
                    <div style="margin-bottom: 20px; text-align: right;">
                        <a href="project?action=add" class="btn-small" style="background: var(--primary-color); color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none; display: inline-block;">
                            <i class="fas fa-plus"></i> Tambah Proyek Baru
                        </a>
                    </div>
                <% } %>

                <div class="tasks-section" style="width: 100%;">
                    <% if (projectList != null && !projectList.isEmpty()) { %>
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="background: #e0f2f1; text-align: left; color: var(--secondary-color);">
                                    <th style="padding: 15px; border-radius: 8px 0 0 8px;">Nama Proyek</th>
                                    <th style="padding: 15px;">Kategori</th>
                                    <th style="padding: 15px;">Status</th>
                                    <th style="padding: 15px;">Deadline</th>
                                    
                                    <% if (canManageProject) { %>
                                        <th style="padding: 15px; border-radius: 0 8px 8px 0;">Aksi</th>
                                    <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Project p : projectList) { %>
                                <tr style="border-bottom: 1px solid #eee;">
                                    <td style="padding: 15px; font-weight: 600; color: var(--secondary-color);"><%= p.getProjectName() %></td>
                                    
                                    <td style="padding: 15px;"><%= p.getActivityType() %></td>
                                    
                                    <td style="padding: 15px;">
                                        <span class="badge <%= "Completed".equals(p.getStatus()) ? "badge-success" : "badge-danger" %>">
                                            <%= p.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="padding: 15px;"><%= p.getEndDate() %></td>
                                    
                                    <% if (canManageProject) { %>
                                        <td style="padding: 15px;">
                                            <a href="project?action=edit&id=<%= p.getProjectID() %>" style="color: var(--accent-color); margin-right: 15px;" title="Edit"><i class="fas fa-edit"></i></a>
                                            <a href="project?action=delete&id=<%= p.getProjectID() %>" style="color: #ef5350;" onclick="return confirm('Yakin hapus proyek ini?')" title="Hapus"><i class="fas fa-trash"></i></a>
                                        </td>
                                    <% } %>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } else { %>
                        <div class="empty-state">
                            <i class="fas fa-folder-open" style="font-size: 3rem; margin-bottom: 10px; opacity: 0.5;"></i>
                            <p>Belum ada data proyek.</p>
                        </div>
                    <% } %>
                </div>

            </main>
        </div>

        <nav class="bottom-nav">
            <a href="dashboard" class="bottom-nav-item">
                <i class="fas fa-home"></i> <span>Home</span>
            </a>
            <a href="project" class="bottom-nav-item active">
                <i class="fas fa-project-diagram"></i> <span>Proyek</span>
            </a>
            <a href="event" class="bottom-nav-item">
                <i class="fas fa-calendar-alt"></i> <span>Event</span>
            </a>
            <a href="administration.jsp" class="bottom-nav-item">
                <i class="fas fa-file-alt"></i> <span>Admin</span>
            </a>
            <a href="profile.jsp" class="bottom-nav-item">
                <i class="fas fa-user"></i> <span>Akun</span>
            </a>
        </nav>

    </body>
</html>