<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lablink.model.Project"%>
<%@ page import="com.lablink.model.LabMember"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    String role = user.getAccessRole();
    boolean canManageProject = "HEAD_OF_LAB".equals(role) || "HEAD_OF_INTERNAL".equals(role);
    List<Project> listP = (List<Project>) request.getAttribute("listProject");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Proyek - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-project-diagram"></i> Manajemen Proyek</h1>
                    <p class="page-subtitle">Daftar dan status proyek riset laboratorium</p>
                </div>
                <div class="top-bar-right">
                    <% if (canManageProject) { %>
                    <a href="project?action=add" class="btn btn-primary"><i class="fas fa-plus"></i> Tambah Proyek</a>
                    <% } %>
                </div>
            </header>
            <% if (errorMessage != null) { %>
            <div class="alert alert-danger" style="margin-bottom: 20px;"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></div>
            <% } %>
            
            <!-- Search & Filter Bar -->
            <div class="search-filter-bar">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Cari proyek atau ketua..." onkeyup="filterTable()">
                </div>
                <select class="filter-dropdown" id="statusFilter" onchange="filterTable()">
                    <option value="">Semua Status</option>
                    <option value="Ongoing">Ongoing</option>
                    <option value="Completed">Completed</option>
                </select>
                <select class="filter-dropdown" id="divisionFilter" onchange="filterTable()">
                    <option value="">Semua Divisi</option>
                    <option value="Big Data">Big Data</option>
                    <option value="Cyber Security">Cyber Security</option>
                    <option value="GIS">GIS</option>
                    <option value="Game Tech">Game Tech</option>
                </select>
                <span class="search-result-info" id="resultInfo"></span>
            </div>
            
            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <% if (listP != null && !listP.isEmpty()) { %>
                    <table class="data-table" id="projectTable">
                        <thead>
                            <tr><th>Nama Proyek</th><th>Kategori</th><th>Divisi</th><th>Status</th><th>Deadline</th><th>Aksi</th></tr>
                        </thead>
                        <tbody>
                            <% for (Project p : listP) { 
                                String teamStr = "Belum ada anggota";
                                if (p.getTeamMembers() != null && !p.getTeamMembers().isEmpty()) {
                                    teamStr = String.join(", ", p.getTeamMembers());
                                }
                            %>
                            <tr data-name="<%= p.getProjectName().toLowerCase() %>" data-status="<%= p.getStatus() %>" data-division="<%= p.getDivision() %>" data-leader="<%= p.getLeaderName() != null ? p.getLeaderName().toLowerCase() : "" %>">
                                <td>
                                    <div style="font-weight: 600; color: var(--secondary);"><%= p.getProjectName() %></div>
                                    <div style="font-size: 0.8rem; color: var(--text-muted);"><%= p.getLeaderName() != null ? "Leader: " + p.getLeaderName() : "" %></div>
                                </td>
                                <td><span class="badge badge-info"><%= p.getActivityType() %></span></td>
                                <td><%= p.getDivision() %></td>
                                <td><span class="badge <%= "Completed".equals(p.getStatus()) ? "badge-success" : "badge-warning" %>"><i class="fas <%= "Completed".equals(p.getStatus()) ? "fa-check-circle" : "fa-clock" %>"></i> <%= p.getStatus() %></span></td>
                                <td><%= p.getEndDate() %></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <button onclick="showDetail(this)" class="btn btn-outline btn-sm btn-icon" data-title="<%= p.getProjectName() %>" data-description="<%= p.getDescription() != null ? p.getDescription() : "-" %>" data-category="<%= p.getActivityType() %>" data-status="<%= p.getStatus() %>" data-division="<%= p.getDivision() %>" data-leader="<%= p.getLeaderName() != null ? p.getLeaderName() : "Belum ditentukan" %>" data-start="<%= p.getStartDate() %>" data-end="<%= p.getEndDate() %>" data-team="<%= teamStr %>" title="Detail"><i class="fas fa-eye"></i></button>
                                        <% if (canManageProject) { %>
                                        <a href="project?action=edit&id=<%= p.getProjectID() %>" class="btn btn-outline btn-sm btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <% if ("Completed".equals(p.getStatus())) { %>
                                        <a href="archive?action=createFromProject&projectID=<%= p.getProjectID() %>" class="btn btn-sm btn-icon" style="background: var(--success-light); color: var(--success);" title="Arsipkan"><i class="fas fa-file-archive"></i></a>
                                        <% } %>
                                        <a href="project?action=delete&id=<%= p.getProjectID() %>" onclick="return confirm('Yakin hapus proyek ini?')" class="btn btn-sm btn-icon" style="background: var(--danger-light); color: var(--danger);" title="Hapus"><i class="fas fa-trash"></i></a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <div id="noResults" class="no-results" style="display: none;">
                        <i class="fas fa-search"></i>
                        <p>Tidak ada proyek yang cocok dengan pencarian</p>
                    </div>
                    <% } else { %>
                    <div class="empty-state" style="padding: 60px 20px;">
                        <i class="fas fa-folder-open"></i>
                        <p>Belum ada data proyek</p>
                        <% if (canManageProject) { %><a href="project?action=add" class="btn btn-primary btn-sm" style="margin-top: 16px;"><i class="fas fa-plus"></i> Tambah Proyek Pertama</a><% } %>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    <div id="projectModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header"><h3><i class="fas fa-project-diagram"></i> Detail Proyek</h3><button class="close-btn" onclick="closeModal()">&times;</button></div>
            <div class="modal-body">
                <div class="detail-row"><span class="detail-label">Nama Proyek</span><span class="detail-value" id="mTitle"></span></div>
                <div class="detail-row"><span class="detail-label">Deskripsi</span><span class="detail-value" id="mDescription"></span></div>
                <div class="detail-row"><span class="detail-label">Kategori</span><span class="detail-value" id="mCategory"></span></div>
                <div class="detail-row"><span class="detail-label">Divisi</span><span class="detail-value" id="mDivision"></span></div>
                <div class="detail-row"><span class="detail-label">Ketua Tim (Leader)</span><span class="detail-value" id="mLeader"></span></div>
                <div class="detail-row"><span class="detail-label">Anggota Tim</span><span class="detail-value" id="mTeam"></span></div>
                <div class="detail-row"><span class="detail-label">Tanggal Mulai</span><span class="detail-value" id="mStart"></span></div>
                <div class="detail-row"><span class="detail-label">Deadline</span><span class="detail-value" id="mEnd"></span></div>
                <div class="detail-row"><span class="detail-label">Status</span><span class="detail-value" id="mStatusBadge"></span></div>
            </div>
        </div>
    </div>
    <script>
        function showDetail(btn) {
            document.getElementById('mTitle').innerText = btn.getAttribute('data-title');
            document.getElementById('mDescription').innerText = btn.getAttribute('data-description');
            document.getElementById('mCategory').innerText = btn.getAttribute('data-category');
            document.getElementById('mDivision').innerText = btn.getAttribute('data-division');
            document.getElementById('mLeader').innerText = btn.getAttribute('data-leader');
            document.getElementById('mTeam').innerText = btn.getAttribute('data-team');
            document.getElementById('mStart').innerText = btn.getAttribute('data-start');
            document.getElementById('mEnd').innerText = btn.getAttribute('data-end');
            document.getElementById('mStatusBadge').innerText = btn.getAttribute('data-status');
            document.getElementById('projectModal').style.display = 'flex';
        }
        function closeModal() { document.getElementById('projectModal').style.display = 'none'; }
        window.onclick = function(event) { if (event.target == document.getElementById('projectModal')) { closeModal(); } }
        
        function filterTable() {
            const searchText = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const divisionFilter = document.getElementById('divisionFilter').value;
            const rows = document.querySelectorAll('#projectTable tbody tr');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const name = row.getAttribute('data-name');
                const leader = row.getAttribute('data-leader');
                const status = row.getAttribute('data-status');
                const division = row.getAttribute('data-division');
                
                const matchSearch = name.includes(searchText) || leader.includes(searchText);
                const matchStatus = !statusFilter || status === statusFilter;
                const matchDivision = !divisionFilter || division === divisionFilter;
                
                if (matchSearch && matchStatus && matchDivision) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.getElementById('resultInfo').textContent = visibleCount + ' proyek ditemukan';
            document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
            document.getElementById('projectTable').style.display = visibleCount === 0 ? 'none' : '';
        }
    </script>
</body>
</html>
