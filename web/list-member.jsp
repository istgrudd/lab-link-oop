<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    boolean isAdmin = "HEAD_OF_LAB".equals(user.getAccessRole());
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Anggota Lab - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-users"></i> Anggota Lab</h1>
                    <p class="page-subtitle">Daftar Research Assistant & Dosen</p>
                </div>
                <div class="top-bar-right">
                    <% if (isAdmin) { %>
                    <a href="member?action=add" class="btn btn-primary"><i class="fas fa-plus"></i> Tambah Anggota</a>
                    <% } %>
                </div>
            </header>
            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <table class="data-table">
                        <thead>
                            <tr><th>ID</th><th>Nama</th><th>Divisi</th><th>Departemen</th><th>Jabatan</th><th>Beban Kerja</th><% if (isAdmin) { %><th>Aksi</th><% } %></tr>
                        </thead>
                        <tbody>
                            <% List<ResearchAssistant> list = (List<ResearchAssistant>) request.getAttribute("listRA");
                               if (list != null && !list.isEmpty()) { for (ResearchAssistant ra : list) { %>
                            <tr>
                                <td style="font-weight: 600; color: var(--text-muted);"><%= ra.getMemberID() %></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <div style="width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), var(--teal)); border-radius: 10px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700;"><%= ra.getName().substring(0, 1).toUpperCase() %></div>
                                        <div><div style="font-weight: 600; color: var(--secondary);"><%= ra.getName() %></div><div style="font-size: 0.75rem; color: var(--text-muted);"><%= ra.getAccessRole() %></div></div>
                                    </div>
                                </td>
                                <td><span class="badge badge-primary"><%= ra.getExpertDivision() %></span></td>
                                <td><span class="badge <%= "Internal".equals(ra.getDepartment()) ? "badge-success" : "badge-info" %>"><%= ra.getDepartment() %></span></td>
                                <td><%= (ra.getRoleTitle() != null && !ra.getRoleTitle().isEmpty()) ? ra.getRoleTitle() : "-" %></td>
                                <td>
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <div style="flex: 1; height: 6px; background: var(--border-color); border-radius: 3px; overflow: hidden;"><div style="width: <%= Math.min(ra.calculateWorkload() * 10, 100) %>%; height: 100%; background: linear-gradient(135deg, var(--primary), var(--teal));"></div></div>
                                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--secondary);"><%= ra.calculateWorkload() %> Jam</span>
                                    </div>
                                </td>
                                <% if (isAdmin) { %>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="member?action=edit&id=<%= ra.getMemberID() %>" class="btn btn-outline btn-sm btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <a href="member?action=delete&id=<%= ra.getMemberID() %>" onclick="return confirm('Yakin ingin menghapus anggota <%= ra.getName() %>?')" class="btn btn-sm btn-icon" style="background: var(--danger-light); color: var(--danger);" title="Hapus"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                                <% } %>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="<%= isAdmin ? 7 : 6 %>" class="empty-state"><i class="fas fa-users"></i><p>Belum ada data anggota</p></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
