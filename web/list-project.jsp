<%-- 
    Document   : list-project
    Created on : 25 Dec 2025, 22.50.34
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.LabMember"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>

<%
    // 1. Cek Session & Role
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String role = user.getAccessRole();
    boolean canManageProject = "HEAD_OF_LAB".equals(role) || "HEAD_OF_INTERNAL".equals(role);
    
    // Ambil Data dari Controller
    List<Project> listP = (List<Project>) request.getAttribute("listProject");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manajemen Proyek - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                    <% if (listP != null && !listP.isEmpty()) { %>
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="background: #e0f2f1; text-align: left; color: var(--secondary-color);">
                                    <th style="padding: 15px; border-radius: 8px 0 0 8px;">Nama Proyek</th>
                                    <th style="padding: 15px;">Kategori</th>
                                    <th style="padding: 15px;">Status</th>
                                    <th style="padding: 15px;">Deadline</th>
                                    <th style="padding: 15px; border-radius: 0 8px 8px 0;">Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Project p : listP) { 
                                    // Persiapkan Data untuk Modal (Team Members to String)
                                    String teamStr = "Belum ada anggota";
                                    if (p.getTeamMembers() != null && !p.getTeamMembers().isEmpty()) {
                                        teamStr = String.join(", ", p.getTeamMembers());
                                    }
                                %>
                                <tr style="border-bottom: 1px solid #eee;">
                                    <td style="padding: 15px; font-weight: 600; color: var(--secondary-color);"><%= p.getProjectName() %></td>
                                    
                                    <td style="padding: 15px;"><%= p.getActivityType() %></td>
                                    
                                    <td style="padding: 15px;">
                                        <span class="badge <%= "Completed".equals(p.getStatus()) ? "badge-success" : "badge-danger" %>">
                                            <%= p.getStatus() %>
                                        </span>
                                    </td>
                                    <td style="padding: 15px;"><%= p.getEndDate() %></td>
                                    
                                    <td style="padding: 15px;">
                                        <button onclick="showDetail(this)" 
                                                class="btn-icon"
                                                data-title="<%= p.getProjectName() %>"
                                                data-description="<%= p.getDescription() != null ? p.getDescription() : "-" %>"
                                                data-category="<%= p.getActivityType() %>"
                                                data-status="<%= p.getStatus() %>"
                                                data-division="<%= p.getDivision() %>"
                                                data-leader="<%= p.getLeaderName() != null ? p.getLeaderName() : "Belum ditentukan" %>"
                                                data-start="<%= p.getStartDate() %>"
                                                data-end="<%= p.getEndDate() %>"
                                                data-team="<%= teamStr %>"
                                                style="background:none; border:none; cursor:pointer; color: var(--primary-color); margin-right: 10px;" 
                                                title="Lihat Detail">
                                            <i class="fas fa-eye"></i>
                                        </button>

                                        <% if (canManageProject) { %>
                                            
                                            <a href="project?action=edit&id=<%= p.getProjectID() %>" style="color: var(--accent-color); margin-right: 10px;" title="Edit">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            
                                            <% if ("Completed".equals(p.getStatus())) { %>
                                                <a href="archive?action=createFromProject&projectID=<%= p.getProjectID() %>" 
                                                   style="color: #2e7d32; margin-right: 10px;" 
                                                   title="Arsipkan">
                                                   <i class="fas fa-file-archive"></i>
                                                </a>
                                            <% } %>

                                            <a href="project?action=delete&id=<%= p.getProjectID() %>" style="color: #ef5350;" onclick="return confirm('Yakin hapus proyek ini?')" title="Hapus">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        <% } %>
                                    </td>
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
            <a href="#" class="bottom-nav-item" onclick="alert('Fitur Administrasi akan segera hadir!')">
                <i class="fas fa-file-alt"></i> <span>Admin</span>
            </a>
            <a href="profile.jsp" class="bottom-nav-item">
                <i class="fas fa-user"></i> <span>Akun</span>
            </a>
        </nav>

        <div id="projectModal" class="modal-overlay">
            <div class="modal-card">
                <div class="modal-header">
                    <h3>Detail Proyek</h3>
                    <button class="close-btn" onclick="closeModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="detail-row">
                        <span class="detail-label">Nama Proyek</span>
                        <span class="detail-value" id="mTitle"></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Deskripsi</span>
                        <span class="detail-value" id="mDescription"></span>
                    </div>
                    
                    <div class="detail-row" style="display: flex; gap: 20px;">
                        <div style="flex: 1;">
                            <span class="detail-label">Kategori</span>
                            <span class="detail-value" id="mCategory"></span>
                        </div>
                        <div style="flex: 1;">
                            <span class="detail-label">Divisi</span>
                            <span class="detail-value" id="mDivision"></span>
                        </div>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Ketua Tim (Leader)</span>
                        <span class="detail-value" id="mLeader" style="color: var(--primary-color);"></span>
                    </div>

                    <div class="detail-row">
                        <span class="detail-label">Anggota Tim</span>
                        <span class="detail-value" id="mTeam" style="line-height: 1.5;"></span>
                    </div>

                    <div class="detail-row" style="display: flex; gap: 20px;">
                        <div style="flex: 1;">
                            <span class="detail-label">Mulai</span>
                            <span class="detail-value" id="mStart"></span>
                        </div>
                        <div style="flex: 1;">
                            <span class="detail-label">Deadline</span>
                            <span class="detail-value" id="mEnd" style="color: #d32f2f;"></span>
                        </div>
                    </div>

                    <div class="detail-row" style="border: none;">
                        <span class="detail-label">Status Saat Ini</span>
                        <span id="mStatusBadge" class="badge"></span>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function showDetail(btn) {
                // Ambil data dari atribut tombol
                document.getElementById('mTitle').innerText = btn.getAttribute('data-title');
                document.getElementById('mDescription').innerText = btn.getAttribute('data-description');
                document.getElementById('mCategory').innerText = btn.getAttribute('data-category');
                document.getElementById('mDivision').innerText = btn.getAttribute('data-division');
                document.getElementById('mLeader').innerText = btn.getAttribute('data-leader');
                document.getElementById('mTeam').innerText = btn.getAttribute('data-team');
                document.getElementById('mStart').innerText = btn.getAttribute('data-start');
                document.getElementById('mEnd').innerText = btn.getAttribute('data-end');
                
                // Atur Badge Status
                var status = btn.getAttribute('data-status');
                var badge = document.getElementById('mStatusBadge');
                badge.innerText = status;
                
                if(status === 'Completed') {
                    badge.className = 'badge badge-success';
                } else {
                    badge.className = 'badge badge-danger';
                }

                // Tampilkan Modal
                document.getElementById('projectModal').style.display = 'flex';
            }

            function closeModal() {
                document.getElementById('projectModal').style.display = 'none';
            }

            // Tutup jika klik di luar area kartu
            window.onclick = function(event) {
                var modal = document.getElementById('projectModal');
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>

    </body>
</html>