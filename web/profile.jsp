<%-- 
    Document   : profile
    Created on : 25 Dec 2025, 21.46.39
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember userSession = (LabMember) session.getAttribute("user");
    if (userSession == null) { response.sendRedirect("login.jsp"); return; }
    
    ResearchAssistant user = null;
    if (userSession instanceof ResearchAssistant) {
        user = (ResearchAssistant) userSession;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Profil Saya - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <h1>Pengaturan Akun</h1>
                </header>

                <div class="content-split">
                    <div class="agenda-section">
                        <h2>Informasi Profil</h2>
                        <% if (request.getAttribute("msgInfo") != null) { %>
                             <div style="padding:10px; background:#e8f5e9; color:#2e7d32; border-radius:5px; margin-bottom:10px;">
                                <%= request.getAttribute("msgInfo") %>
                            </div>
                        <% } %>
                        
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="updateInfo">
                            
                            <div style="margin-bottom:15px;">
                                <label>Member ID</label>
                                <input type="text" value="<%= user.getMemberID() %>" disabled style="width:100%; padding:10px; background:#eee; border:1px solid #ddd;">
                            </div>
                            
                            <div style="margin-bottom:15px;">
                                <label>Nama Lengkap</label>
                                <input type="text" name="name" value="<%= user.getName() %>" style="width:100%; padding:10px;" required>
                            </div>
                            
                            <div style="display:flex; gap:15px; margin-bottom:15px;">
                                <div style="flex:1;">
                                    <label>Divisi</label>
                                    <select name="division" style="width:100%; padding:10px;">
                                        <option value="Big Data" <%= "Big Data".equals(user.getExpertDivision()) ? "selected" : "" %>>Big Data</option>
                                        <option value="Cyber Security" <%= "Cyber Security".equals(user.getExpertDivision()) ? "selected" : "" %>>Cyber Security</option>
                                        <option value="GIS" <%= "GIS".equals(user.getExpertDivision()) ? "selected" : "" %>>GIS</option>
                                        <option value="Game Tech" <%= "Game Tech".equals(user.getExpertDivision()) ? "selected" : "" %>>Game Tech</option>
                                    </select>
                                </div>
                                <div style="flex:1;">
                                    <label>Departemen</label>
                                    <select name="department" style="width:100%; padding:10px;">
                                        <option value="Internal" <%= "Internal".equals(user.getDepartment()) ? "selected" : "" %>>Internal</option>
                                        <option value="Eksternal" <%= "Eksternal".equals(user.getDepartment()) ? "selected" : "" %>>Eksternal</option>
                                    </select>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn-small" style="background:var(--primary-color); color:white; border:none; padding:10px 20px;">Simpan Profil</button>
                        </form>
                    </div>

                    <div class="tasks-section">
                        <h2>Keamanan</h2>
                        <% if (request.getAttribute("msgPass") != null) { %>
                             <div style="padding:10px; background:#ffebee; color:#c62828; border-radius:5px; margin-bottom:10px;">
                                <%= request.getAttribute("msgPass") %>
                            </div>
                        <% } %>
                        
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div style="margin-bottom:15px;">
                                <label>Password Baru</label>
                                <input type="password" name="newPassword" style="width:100%; padding:10px;" required>
                            </div>
                            <div style="margin-bottom:15px;">
                                <label>Konfirmasi Password</label>
                                <input type="password" name="confirmPassword" style="width:100%; padding:10px;" required>
                            </div>
                            <button type="submit" class="btn-small" style="background:#ef5350; color:white; border:none; padding:10px 20px;">Ganti Password</button>
                        </form>
                    </div>
                </div>

            </main>
        </div>
        
        <nav class="bottom-nav">
            <a href="dashboard" class="bottom-nav-item">
                <i class="fas fa-home"></i> <span>Home</span>
            </a>
            <a href="project" class="bottom-nav-item">
                <i class="fas fa-project-diagram"></i> <span>Proyek</span>
            </a>
            <a href="event" class="bottom-nav-item">
                <i class="fas fa-calendar-alt"></i> <span>Event</span>
            </a>
            <a href="#" class="bottom-nav-item" onclick="alert('Fitur Administrasi akan segera hadir!')">
                <i class="fas fa-file-alt"></i> <span>Admin</span>
            </a>
            <a href="profile.jsp" class="bottom-nav-item active">
                <i class="fas fa-user"></i> <span>Akun</span>
            </a>
        </nav>
    </body>
</html>