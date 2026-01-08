<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember userSession = (LabMember) session.getAttribute("user");
    if (userSession == null) { response.sendRedirect("login.jsp"); return; }
    ResearchAssistant user = null;
    if (userSession instanceof ResearchAssistant) { user = (ResearchAssistant) userSession; }
    String userInitial = user != null ? user.getName().substring(0, 1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Saya - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section"><h1 class="page-title"><i class="fas fa-user-cog"></i> Pengaturan Akun</h1><p class="page-subtitle">Kelola informasi profil dan keamanan</p></div>
            </header>
            <div class="content-grid">
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-id-card"></i> Informasi Profil</h2></div>
                    <div class="card-body">
                        <% if (request.getAttribute("msgInfo") != null) { %>
                        <div style="padding: 14px 16px; background: var(--success-light); color: var(--success); border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;"><i class="fas fa-check-circle"></i><%= request.getAttribute("msgInfo") %></div>
                        <% } %>
                        <div style="text-align: center; margin-bottom: 24px;">
                            <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary), var(--teal)); border-radius: 20px; display: inline-flex; align-items: center; justify-content: center; color: white; font-size: 2rem; font-weight: 700; box-shadow: 0 10px 30px rgba(0, 150, 136, 0.3);"><%= userInitial %></div>
                            <h3 style="margin-top: 16px; color: var(--secondary);"><%= user.getName() %></h3>
                            <p style="color: var(--text-muted); font-size: 0.9rem;"><%= user.getAccessRole() %></p>
                        </div>
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="updateInfo">
                            <div class="form-group"><label class="form-label">Member ID</label><input type="text" value="<%= user.getMemberID() %>" class="form-control" disabled style="background: #f1f5f9;"></div>
                            <div class="form-group"><label class="form-label">Nama Lengkap</label><input type="text" name="name" value="<%= user.getName() %>" class="form-control" required></div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group"><label class="form-label">Divisi</label><select name="division" class="form-control"><option value="Big Data" <%= "Big Data".equals(user.getExpertDivision()) ? "selected" : "" %>>Big Data</option><option value="Cyber Security" <%= "Cyber Security".equals(user.getExpertDivision()) ? "selected" : "" %>>Cyber Security</option><option value="GIS" <%= "GIS".equals(user.getExpertDivision()) ? "selected" : "" %>>GIS</option><option value="Game Tech" <%= "Game Tech".equals(user.getExpertDivision()) ? "selected" : "" %>>Game Tech</option></select></div>
                                <div class="form-group"><label class="form-label">Departemen</label><select name="department" class="form-control"><option value="Internal" <%= "Internal".equals(user.getDepartment()) ? "selected" : "" %>>Internal</option><option value="Eksternal" <%= "Eksternal".equals(user.getDepartment()) ? "selected" : "" %>>Eksternal</option></select></div>
                            </div>
                            <button type="submit" class="btn btn-primary" style="width: 100%;"><i class="fas fa-save"></i> Simpan Profil</button>
                        </form>
                    </div>
                </div>
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-shield-alt"></i> Keamanan</h2></div>
                    <div class="card-body">
                        <% if (request.getAttribute("msgPass") != null) { %>
                        <div style="padding: 14px 16px; background: var(--danger-light); color: var(--danger); border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;"><i class="fas fa-exclamation-circle"></i><%= request.getAttribute("msgPass") %></div>
                        <% } %>
                        <div style="text-align: center; margin-bottom: 24px;">
                            <div style="width: 64px; height: 64px; background: var(--orange-light); border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; color: var(--orange); font-size: 1.5rem;"><i class="fas fa-lock"></i></div>
                            <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 12px;">Ganti password secara berkala untuk keamanan akun</p>
                        </div>
                        <form action="profile" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="form-group"><label class="form-label">Password Baru</label><input type="password" name="newPassword" class="form-control" placeholder="Masukkan password baru" required></div>
                            <div class="form-group"><label class="form-label">Konfirmasi Password</label><input type="password" name="confirmPassword" class="form-control" placeholder="Ulangi password baru" required></div>
                            <button type="submit" class="btn btn-danger" style="width: 100%;"><i class="fas fa-key"></i> Ganti Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
