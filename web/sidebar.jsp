<%-- 
    Document   : sidebar
    Created on : 27 Dec 2025, 18.17.05
    Author     : Rudi Firdaus
--%>

<%@page import="com.lablink.model.LabMember"%>
<%
    String path = request.getRequestURI();
    LabMember sidebarUser = (LabMember) session.getAttribute("user");
%>

<aside class="sidebar">
    <div class="sidebar-header">
        <h2>LabLink</h2>
        <p>Welcome, <%= (sidebarUser != null) ? sidebarUser.getName() : "User" %></p>
    </div>
    
    <nav class="sidebar-menu">
        <ul>
            <li class="<%= path.contains("dashboard") ? "active" : "" %>">
                <a href="dashboard">
                    <i class="fas fa-home"></i> 
                    <span class="link-text">Dashboard</span>
                </a>
            </li>
            
            <li class="<%= path.contains("project") ? "active" : "" %>">
                <a href="project">
                    <i class="fas fa-project-diagram"></i> 
                    <span class="link-text">Proyek</span>
                </a>
            </li>
            
            <li class="<%= path.contains("event") ? "active" : "" %>">
                <a href="event">
                    <i class="fas fa-calendar-alt"></i> 
                    <span class="link-text">Event & Kegiatan</span>
                </a>
            </li>
            
            <li class="<%= path.contains("member") ? "active" : "" %>">
                <a href="member">
                    <i class="fas fa-users"></i> 
                    <span class="link-text">Anggota Lab</span>
                </a>
            </li>
            
            <li class="<%= path.contains("archive") ? "active" : "" %>">
                <a href="archive">
                    <i class="fas fa-archive"></i> 
                    <span class="link-text">Arsip Output</span>
                </a>
            </li>
            
            <li class="<%= path.contains("report") ? "active" : "" %>">
                <a href="report">
                    <i class="fas fa-chart-bar"></i> 
                    <span class="link-text">Laporan</span>
                </a>
            </li>
            
            <li class="<%= path.contains("administration") ? "active" : "" %>">
                <a href="#" class="new-feature" onclick="alert('Fitur Administrasi akan segera hadir!')">
                    <i class="fas fa-file-alt"></i> 
                    <span class="link-text">Administrasi</span>
                </a>
            </li>
            
            <li class="<%= path.contains("profile") ? "active" : "" %>">
                <a href="profile.jsp">
                    <i class="fas fa-user"></i> 
                    <span class="link-text">Akun</span>
                </a>
            </li>
        </ul>
    </nav>

    <div class="sidebar-footer">
        <a href="login?action=logout" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> 
            <span class="link-text">Logout</span>
        </a>
    </div>
</aside>

<nav class="bottom-nav">
    <a href="dashboard" class="bottom-nav-item"><i class="fas fa-home"></i> <span>Home</span></a>
    <a href="project" class="bottom-nav-item"><i class="fas fa-project-diagram"></i> <span>Proyek</span></a>
    <a href="event" class="bottom-nav-item"><i class="fas fa-calendar-alt"></i> <span>Event</span></a>
    <a href="profile.jsp" class="bottom-nav-item"><i class="fas fa-user"></i> <span>Akun</span></a>
</nav>