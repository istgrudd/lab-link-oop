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
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Cek Hak Akses Admin
    boolean isAdmin = "HEAD_OF_LAB".equals(user.getAccessRole());
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Anggota Lab - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>

        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Anggota Lab</h1>
                        <p class="text-muted small">Daftar Research Assistant & Dosen</p>
                    </div>
                </header>

                <% if (isAdmin) { %>
                <div class="agenda-section" style="margin-bottom: 25px;">
                    <h3 style="font-size:1rem; margin-bottom:15px; color:var(--secondary-color);">+ Registrasi Anggota Baru</h3>
                    <form action="member" method="post" style="display:flex; gap:10px; flex-wrap:wrap;">
                        <input type="hidden" name="action" value="add"> <input type="text" name="id" placeholder="NIM/ID" style="padding:10px; flex:1;" required>
                        <input type="text" name="name" placeholder="Nama Lengkap" style="padding:10px; flex:2;" required>
                        <select name="division" style="padding:10px; flex:1;">
                            <option value="Big Data">Big Data</option>
                            <option value="Cyber Security">Cyber Security</option>
                            <option value="GIS">GIS</option>
                            <option value="Game Tech">Game Tech</option>
                        </select>
                        <select name="department" style="padding:10px; flex:1;">
                            <option value="Internal">Internal</option>
                            <option value="Eksternal">Eksternal</option>
                        </select>
                        <input type="text" name="role" placeholder="Jabatan (Opsional)" style="padding:10px; flex:1;">
                        <button type="submit" class="btn-small" style="background:var(--primary-color); color:white; border:none; cursor:pointer;">Tambah</button>
                    </form>
                </div>
                <% } %>

                <div class="tasks-section" style="width:100%;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: #e0f2f1; text-align: left; color: var(--secondary-color);">
                                <th style="padding: 15px; border-radius: 8px 0 0 8px;">ID</th>
                                <th style="padding: 15px;">Nama</th>
                                <th style="padding: 15px;">Divisi</th>
                                <th style="padding: 15px;">Departemen</th>
                                <th style="padding: 15px;">Jabatan</th>
                                <th style="padding: 15px;">Beban Kerja</th>
                                
                                <% if (isAdmin) { %>
                                    <th style="padding: 15px; border-radius: 0 8px 8px 0;">Aksi</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<ResearchAssistant> list = (List<ResearchAssistant>) request.getAttribute("listRA");
                                if (list != null && !list.isEmpty()) {
                                    for (ResearchAssistant ra : list) {
                            %>
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 15px; font-weight:bold; color:#888;"><%= ra.getMemberID() %></td>
                                <td style="padding: 15px; font-weight:600;"><%= ra.getName() %></td>
                                <td style="padding: 15px;"><%= ra.getExpertDivision() %></td>
                                <td style="padding: 15px;"><span class="badge" style="background:#eee; color:#333;"><%= ra.getDepartment() %></span></td>
                                <td style="padding: 15px;"><span class="badge badge-success"><%= (ra.getRoleTitle() != null ? ra.getRoleTitle() : "-") %></span></td>
                                <td style="padding: 15px;"><%= ra.calculateWorkload() %> Jam</td>

                                <% if (isAdmin) { %>
                                <td style="padding: 15px;">
                                    <div style="display:flex; gap:15px;">
                                        <a href="member?action=edit&id=<%= ra.getMemberID() %>" 
                                           style="color: var(--accent-color); font-size: 1.1rem;" 
                                           title="Edit Data & Role">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <a href="member?action=delete&id=<%= ra.getMemberID() %>" 
                                           onclick="return confirm('Yakin ingin menghapus anggota <%= ra.getName() %>?')" 
                                           style="color: #ef5350; font-size: 1.1rem;" 
                                           title="Hapus Anggota">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                                <% } %>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="<%= isAdmin ? 7 : 6 %>" class="empty-state">Belum ada data anggota.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
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