<%-- 
    Document   : sidebar
    Created on : 27 Dec 2025, 18.17.05
    Author     : Rudi Firdaus
--%>

<%@page import="com.lablink.model.LabMember"%>
<%
    // Logika Sederhana untuk Menentukan Menu Aktif
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
            <li class="<%= path.endsWith("dashboard") || path.endsWith("dashboard.jsp") ? "active" : "" %>">
                <a href="dashboard"><i class="fas fa-home"></i> Dashboard</a>
            </li>
            
            <li class="<%= path.contains("project") ? "active" : "" %>">
                <a href="project"><i class="fas fa-project-diagram"></i> Proyek</a>
            </li>
            
            <li class="<%= path.contains("event") ? "active" : "" %>">
                <a href="event"><i class="fas fa-calendar-alt"></i> Event & Kegiatan</a>
            </li>
            
            <li class="<%= path.contains("member") ? "active" : "" %>">
                <a href="member"><i class="fas fa-users"></i> Anggota Lab</a>
            </li>
            
            <li class="<%= path.contains("archive") ? "active" : "" %>">
                <a href="archive"><i class="fas fa-archive"></i> Arsip Output</a>
            </li>
            
            <li class="<%= path.contains("report") ? "active" : "" %>">
                <a href="report"><i class="fas fa-chart-bar"></i> Laporan</a>
            </li>
            
            <li class="<%= path.contains("administration.jsp") ? "active" : "" %>">
                <a href="administration.jsp" class="new-feature"><i class="fas fa-file-alt"></i> Administrasi</a>
            </li>
        </ul>
    </nav>

    <div class="sidebar-footer">
        <a href="login?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>
</aside>