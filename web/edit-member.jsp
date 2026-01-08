<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null || !"HEAD_OF_LAB".equals(user.getAccessRole())) { response.sendRedirect("member"); return; }
    ResearchAssistant target = (ResearchAssistant) request.getAttribute("member");
    boolean isEdit = (target != null);
    String targetInitial = isEdit ? target.getName().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Anggota" : "Tambah Anggota" %> - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-<%= isEdit ? "user-edit" : "user-plus" %>"></i> <%= isEdit ? "Edit Data Anggota" : "Anggota Baru" %></h1>
                    <p class="page-subtitle"><%= isEdit ? "Perbarui informasi profil dan hak akses sistem" : "Registrasi anggota laboratorium baru" %></p>
                </div>
                <div class="top-bar-right"><a href="member" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Kembali</a></div>
            </header>
            <div class="content-grid">
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-id-card"></i> <%= isEdit ? "Form Perubahan Data" : "Form Registrasi" %></h2></div>
                    <div class="card-body">
                        <% if (isEdit) { %>
                        <div style="display: flex; align-items: center; gap: 16px; margin-bottom: 24px; padding: 16px; background: linear-gradient(135deg, var(--primary-light), #e0f2f1); border-radius: 12px;">
                            <div style="width: 60px; height: 60px; background: linear-gradient(135deg, var(--primary), var(--teal)); border-radius: 16px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; font-weight: 700;"><%= targetInitial %></div>
                            <div><h3 style="margin: 0; color: var(--secondary);"><%= target.getName() %></h3><p style="margin: 0; color: var(--text-muted); font-size: 0.9rem;"><%= target.getMemberID() %></p></div>
                        </div>
                        <% } %>
                        <form action="member" method="post">
                            <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
                            <div class="form-group">
                                <label class="form-label">Member ID (NIM) <span style="color: var(--danger);">*</span></label>
                                <input type="text" name="id" value="<%= isEdit ? target.getMemberID() : "" %>" class="form-control" <%= isEdit ? "readonly style=\"background: #f1f5f9;\"" : "placeholder=\"Masukkan NIM/ID\"" %> required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nama Lengkap <span style="color: var(--danger);">*</span></label>
                                <input type="text" name="name" value="<%= isEdit ? target.getName() : "" %>" class="form-control" placeholder="Nama lengkap anggota" required>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group">
                                    <label class="form-label">Divisi Keahlian <span style="color: var(--danger);">*</span></label>
                                    <select name="division" class="form-control" required>
                                        <option value="" disabled <%= !isEdit ? "selected" : "" %>>-- Pilih Divisi --</option>
                                        <option value="Big Data" <%= isEdit && "Big Data".equals(target.getExpertDivision()) ? "selected" : "" %>>Big Data</option>
                                        <option value="Cyber Security" <%= isEdit && "Cyber Security".equals(target.getExpertDivision()) ? "selected" : "" %>>Cyber Security</option>
                                        <option value="GIS" <%= isEdit && "GIS".equals(target.getExpertDivision()) ? "selected" : "" %>>GIS</option>
                                        <option value="Game Tech" <%= isEdit && "Game Tech".equals(target.getExpertDivision()) ? "selected" : "" %>>Game Tech</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Departemen <span style="color: var(--danger);">*</span></label>
                                    <select name="department" class="form-control" required>
                                        <option value="Internal" <%= isEdit && "Internal".equals(target.getDepartment()) ? "selected" : "" %>>Internal</option>
                                        <option value="Eksternal" <%= isEdit && "Eksternal".equals(target.getDepartment()) ? "selected" : "" %>>Eksternal</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Jabatan (Display Title)</label>
                                <input type="text" name="role" value="<%= isEdit && target.getRoleTitle() != null ? target.getRoleTitle() : "" %>" placeholder="Ex: Staff, Sekretaris" class="form-control">
                            </div>
                            <div style="margin: 24px 0; padding: 20px; background: linear-gradient(135deg, #fef3c7, #fde68a); border-radius: 12px; border: 2px solid var(--orange);">
                                <label style="font-weight: 700; color: var(--secondary); display: flex; align-items: center; gap: 8px; margin-bottom: 8px;"><i class="fas fa-shield-alt" style="color: var(--orange);"></i> Hak Akses Sistem (Access Role)</label>
                                <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 12px;">Role menentukan fitur apa yang bisa dikelola user ini.</p>
                                <select name="accessRole" class="form-control" style="border: 2px solid var(--orange);">
                                    <option value="RESEARCH_ASSISTANT" <%= isEdit && "RESEARCH_ASSISTANT".equals(target.getAccessRole()) ? "selected" : "" %>>RESEARCH_ASSISTANT (Read Only)</option>
                                    <option value="HEAD_OF_INTERNAL" <%= isEdit && "HEAD_OF_INTERNAL".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_INTERNAL (Manajemen Proyek)</option>
                                    <option value="HEAD_OF_EXTERNAL" <%= isEdit && "HEAD_OF_EXTERNAL".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_EXTERNAL (Manajemen Event)</option>
                                    <option value="HEAD_OF_LAB" <%= isEdit && "HEAD_OF_LAB".equals(target.getAccessRole()) ? "selected" : "" %>>HEAD_OF_LAB (Full Admin)</option>
                                </select>
                            </div>
                            <div style="display: flex; gap: 12px; justify-content: <%= isEdit ? "space-between" : "flex-end" %>; align-items: center;">
                                <% if (isEdit) { %>
                                <a href="member?action=delete&id=<%= target.getMemberID() %>" onclick="return confirm('Hapus anggota ini?')" class="btn btn-sm" style="background: var(--danger-light); color: var(--danger);"><i class="fas fa-trash"></i> Hapus Anggota</a>
                                <% } %>
                                <div style="display: flex; gap: 12px;">
                                    <a href="member" class="btn btn-outline">Batal</a>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> <%= isEdit ? "Simpan Perubahan" : "Registrasi Anggota" %></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-info-circle"></i> Informasi Role</h2></div>
                    <div class="card-body">
                        <div style="display: flex; flex-direction: column; gap: 16px;">
                            <div style="padding: 16px; background: #f8fafc; border-radius: 10px; border-left: 4px solid var(--text-muted);"><h4 style="margin: 0 0 6px 0; font-size: 0.9rem; color: var(--secondary);">Research Assistant</h4><p style="margin: 0; font-size: 0.85rem; color: var(--text-muted);">Role default. Hanya bisa melihat data (Read Only).</p></div>
                            <div style="padding: 16px; background: var(--blue-light); border-radius: 10px; border-left: 4px solid var(--blue);"><h4 style="margin: 0 0 6px 0; font-size: 0.9rem; color: var(--secondary);">Head of Internal</h4><p style="margin: 0; font-size: 0.85rem; color: var(--text-muted);">Memiliki wewenang CRUD pada menu <strong>Proyek & Riset</strong>.</p></div>
                            <div style="padding: 16px; background: var(--orange-light); border-radius: 10px; border-left: 4px solid var(--orange);"><h4 style="margin: 0 0 6px 0; font-size: 0.9rem; color: var(--secondary);">Head of External</h4><p style="margin: 0; font-size: 0.85rem; color: var(--text-muted);">Memiliki wewenang CRUD pada menu <strong>Event & Kegiatan</strong>.</p></div>
                            <div style="padding: 16px; background: var(--success-light); border-radius: 10px; border-left: 4px solid var(--success);"><h4 style="margin: 0 0 6px 0; font-size: 0.9rem; color: var(--secondary);">Head of Lab</h4><p style="margin: 0; font-size: 0.85rem; color: var(--text-muted);">Super Admin. Akses penuh ke semua fitur termasuk Manajemen Anggota.</p></div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
