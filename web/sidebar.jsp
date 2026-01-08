<%-- 
    Document   : sidebar
    Created on : 27 Dec 2025, 18.17.05
    Author     : Rudi Firdaus
--%>

<%@page import="com.lablink.model.LabMember"%>
<%
    String path = request.getRequestURI();
    LabMember sidebarUser = (LabMember) session.getAttribute("user");
    String userName = (sidebarUser != null) ? sidebarUser.getName() : "User";
    String userInitial = userName.length() > 0 ? userName.substring(0, 1).toUpperCase() : "U";
    String userRole = (sidebarUser != null) ? sidebarUser.getAccessRole() : "";
    String roleDisplay = "Member";
    if ("HEAD_OF_LAB".equals(userRole)) roleDisplay = "Kepala Lab";
    else if ("HEAD_OF_INTERNAL".equals(userRole)) roleDisplay = "Ketua Internal";
    else if ("HEAD_OF_EXTERNAL".equals(userRole)) roleDisplay = "Ketua Eksternal";
    else if ("RESEARCH_ASSISTANT".equals(userRole)) roleDisplay = "Asisten Riset";
%>
<aside class="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <div class="logo-icon"><i class="fas fa-flask"></i></div>
            <div class="logo-text"><span class="brand">LabLink</span><span class="brand-sub">.id</span></div>
        </div>
    </div>
    <div class="sidebar-user">
        <div class="user-avatar"><%= userInitial %></div>
        <div class="user-info">
            <span class="user-name"><%= userName %></span>
            <span class="user-role"><%= roleDisplay %></span>
        </div>
    </div>
    <nav class="sidebar-menu">
        <ul>
            <li class="<%= path.contains("dashboard") ? "active" : "" %>"><a href="dashboard"><i class="fas fa-home"></i> <span class="link-text">Dashboard</span></a></li>
            <li class="<%= path.contains("project") ? "active" : "" %>"><a href="project"><i class="fas fa-project-diagram"></i> <span class="link-text">Proyek</span></a></li>
            <li class="<%= path.contains("event") ? "active" : "" %>"><a href="event"><i class="fas fa-calendar-alt"></i> <span class="link-text">Event & Kegiatan</span></a></li>
            <li class="<%= path.contains("member") ? "active" : "" %>"><a href="member"><i class="fas fa-users"></i> <span class="link-text">Anggota Lab</span></a></li>
            <li class="<%= path.contains("archive") ? "active" : "" %>"><a href="archive"><i class="fas fa-archive"></i> <span class="link-text">Arsip Output</span></a></li>
            <li class="<%= path.contains("report") ? "active" : "" %>"><a href="report"><i class="fas fa-chart-bar"></i> <span class="link-text">Laporan</span></a></li>
            <li class="menu-divider"></li>
            <li class="<%= path.contains("profile") ? "active" : "" %>"><a href="profile.jsp"><i class="fas fa-user-cog"></i> <span class="link-text">Pengaturan</span></a></li>
        </ul>
    </nav>
    <div class="sidebar-footer">
        <a href="login?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> <span class="link-text">Logout</span></a>
    </div>
</aside>
<nav class="bottom-nav">
    <a href="dashboard" class="bottom-nav-item <%= path.contains("dashboard") ? "active" : "" %>"><i class="fas fa-home"></i><span>Home</span></a>
    <a href="project" class="bottom-nav-item <%= path.contains("project") ? "active" : "" %>"><i class="fas fa-project-diagram"></i><span>Proyek</span></a>
    <a href="event" class="bottom-nav-item <%= path.contains("event") ? "active" : "" %>"><i class="fas fa-calendar-alt"></i><span>Event</span></a>
    <a href="member" class="bottom-nav-item <%= path.contains("member") ? "active" : "" %>"><i class="fas fa-users"></i><span>Anggota</span></a>
    <a href="profile.jsp" class="bottom-nav-item <%= path.contains("profile") ? "active" : "" %>"><i class="fas fa-user"></i><span>Akun</span></a>
</nav>
