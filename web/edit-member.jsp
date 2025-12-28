<%-- 
    Document   : edit-member
    Created on : 28 Dec 2025, 22.34.38
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    // 1. Cek Login & Hak Akses (Hanya HEAD_OF_LAB yang boleh edit)
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null || !"HEAD_OF_LAB".equals(user.getAccessRole())) { 
        response.sendRedirect("member"); 
        return; 
    }
    
    // 2. Ambil data member yang dikirim dari Controller
    ResearchAssistant target = (ResearchAssistant) request.getAttribute("member");
    if (target == null) { 
        response.sendRedirect("member"); 
        return; 
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Anggota - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Edit Data Anggota</h1>
                        <p class="text-muted small">Perbarui informasi profil dan hak akses sistem</p>
                    </div>
                </header>

                <div class="content-split">
                    <div class="agenda-section">
                        <h2><i class="fas fa-user-edit"></i> Form Perubahan Data</h2>
                        
                        <form action="member" method="post">
                            <input type="hidden" name="action" value="update">
                            
                            <div style="margin-bottom: 15px;">
                                <label style="font-weight:600; font-size:0.9rem;">Member ID (NIM)</label>
                                <input type="text" name="id" value="<%= target.getMemberID() %>" 
                                       style="width:100%; padding:10px; border:1px solid #ddd; background:#eee; color:#555; border-radius:5px;" 
                                       readonly>
                            </div>

                            <div style="margin-bottom: 15px;">
                                <label style="font-weight:600; font-size:0.9rem;">Nama Lengkap</label>
                                <input type="text" name="name" value="<%= target.getName() %>" 
                                       style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px;" required>
                            </div>

                            <div style="display:flex; gap:15px; margin-bottom:15px;">
                                <div style="flex:1;">
                                    <label style="font-weight:600; font-size:0.9rem;">Divisi Keahlian</label>
                                    <select name="division" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px;">
                                        <option value="Big Data" <%= "Big Data".equals(target.getExpertDivision()) ? "selected" : "" %>>Big Data</option>
                                        <option value="Cyber Security" <%= "Cyber Security".equals(target.getExpertDivision()) ? "selected" : "" %>>Cyber Security</option>
                                        <option value="GIS" <%= "GIS".equals(target.getExpertDivision()) ? "selected" : "" %>>GIS</option>
                                        <option value="Game Tech" <%= "Game Tech".equals(target.getExpertDivision()) ? "selected" : "" %>>Game Tech</option>
                                    </select>
                                </div>
                                <div style="flex:1;">
                                    <label style="font-weight:600; font-size:0.9rem;">Departemen</label>
                                    <select name="department" style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px;">
                                        <option value="Internal" <%= "Internal".equals(target.getDepartment()) ? "selected" : "" %>>Internal</option>
                                        <option value="Eksternal" <%= "Eksternal".equals(target.getDepartment()) ? "selected" : "" %>>Eksternal</option>
                                    </select>
                                </div>
                            </div>

                            <div style="margin-bottom: 15px;">
                                <label style="font-weight:600; font-size:0.9rem;">Jabatan (Display Title)</label>
                                <input type="text" name="role" value="<%= target.getRoleTitle() %>" 
                                       placeholder="Ex: Staff, Sekretaris" 
                                       style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px;">
                            </div>

                            <hr style="border:0; border-top:1px dashed #ccc; margin: 25px 0;">

                            <div style="margin-bottom: 20px; background: #e0f2f1; padding: 15px; border-radius: 8px; border: 1px solid var(--primary-color);">
                                <label style="font-weight:bold; color:var(--secondary-color); display:block; margin-bottom:5px;">
                                    <i class="fas fa-shield-alt"></i> Hak Akses Sistem (Access Role)
                                </label>
                                <p style="font-size:0.8rem; color:#666; margin-bottom:10px;">
                                    Role menentukan fitur apa yang bisa dikelola user ini (CRUD).
                                </p>
                                
                                <select name="accessRole" style="width:100%; padding:10px; border:2px solid var(--accent-color); border-radius:5px; font-weight:bold;">
                                    <option value="RESEARCH_ASSISTANT" <%= "RESEARCH_ASSISTANT".equals(target.getAccessRole()) ? "selected" : "" %>>RESEARCH_ASSISTANT (Read Only)</option>
                                    <option value="HEAD_OF_INTERNAL" <%= "HEAD_OF_INTERNAL".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_INTERNAL (Manajemen Proyek)</option>
                                    <option value="HEAD_OF_EXTERNAL" <%= "HEAD_OF_EXTERNAL".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_EXTERNAL (Manajemen Event)</option>
                                    <option value="HEAD_OF_LAB" <%= "HEAD_OF_LAB".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_LAB (Full Admin)</option>
                                </select>
                            </div>

                            <div style="display:flex; justify-content:flex-end; gap:10px;">
                                <a href="member" class="btn-small" style="background:#b0bec5; color:white; padding:10px 20px; border-radius:5px; border:none; cursor:pointer;">Batal</a>
                                <button type="submit" class="btn-small" style="background:var(--primary-color); color:white; padding:10px 20px; border-radius:5px; border:none; cursor:pointer;">
                                    <i class="fas fa-save"></i> Simpan Perubahan
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="tasks-section">
                        <h3 style="font-size:1.1rem; color:var(--secondary-color); margin-bottom:15px;">Informasi Role</h3>
                        <ul style="font-size:0.9rem; color:#555; padding-left:20px; line-height:1.6;">
                            <li style="margin-bottom:10px;">
                                <strong>Research Assistant:</strong><br>
                                Role default. Hanya bisa melihat data (Read Only).
                            </li>
                            <li style="margin-bottom:10px;">
                                <strong>Head of Internal:</strong><br>
                                Memiliki wewenang CRUD penuh pada menu <em>Proyek & Riset</em>.
                            </li>
                            <li style="margin-bottom:10px;">
                                <strong>Head of External:</strong><br>
                                Memiliki wewenang CRUD penuh pada menu <em>Event & Kegiatan</em>.
                            </li>
                            <li>
                                <strong>Head of Lab:</strong><br>
                                Super Admin. Akses penuh ke semua fitur termasuk Manajemen Anggota dan Laporan.
                            </li>
                        </ul>
                    </div>
                </div>
            </main>
        </div>
        
        <nav class="bottom-nav">
             <a href="dashboard" class="bottom-nav-item"><i class="fas fa-home"></i> <span>Home</span></a>
             <a href="member" class="bottom-nav-item active"><i class="fas fa-users"></i> <span>Anggota</span></a>
             <a href="profile.jsp" class="bottom-nav-item"><i class="fas fa-user"></i> <span>Akun</span></a>
        </nav>
    </body>
</html>
