<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.lablink.model.ActivityLog" %>
            <%@ page import="com.lablink.model.LabMember" %>
                <% LabMember user=(LabMember) session.getAttribute("user"); if (user==null) {
                    response.sendRedirect("login.jsp"); return; } if (!"HEAD_OF_LAB".equals(user.getAccessRole())) {
                    response.sendRedirect("dashboard"); return; } List<ActivityLog> logs = (List<ActivityLog>)
                        request.getAttribute("logs");
                        %>
                        <!DOCTYPE html>
                        <html lang="id">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Activity Log - LabLink</title>
                            <link rel="stylesheet" href="css/style.css">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        </head>

                        <body class="app-body">
                            <div class="dashboard-container">
                                <jsp:include page="sidebar.jsp" />
                                <main class="main-content">
                                    <header class="top-bar">
                                        <div class="welcome-section">
                                            <h1 class="page-title"><i class="fas fa-history"></i> Activity Log</h1>
                                            <p class="page-subtitle">Riwayat aktivitas dan audit trail sistem</p>
                                        </div>
                                    </header>

                                    <!-- Search & Filter Bar -->
                                    <div class="search-filter-bar">
                                        <div class="search-box">
                                            <i class="fas fa-search"></i>
                                            <input type="text" id="searchInput" placeholder="Cari aktivitas..."
                                                onkeyup="filterTable()">
                                        </div>
                                        <select class="filter-dropdown" id="actionFilter" onchange="filterTable()">
                                            <option value="">Semua Aksi</option>
                                            <option value="CREATE">Create</option>
                                            <option value="UPDATE">Update</option>
                                            <option value="DELETE">Delete</option>
                                            <option value="LOGIN">Login</option>
                                            <option value="LOGOUT">Logout</option>
                                        </select>
                                        <select class="filter-dropdown" id="typeFilter" onchange="filterTable()">
                                            <option value="">Semua Tipe</option>
                                            <option value="PROJECT">Project</option>
                                            <option value="MEMBER">Member</option>
                                            <option value="EVENT">Event</option>
                                            <option value="AUTH">Auth</option>
                                        </select>
                                        <span class="search-result-info" id="resultInfo"></span>
                                    </div>

                                    <div class="content-card">
                                        <div class="card-body" style="padding: 0;">
                                            <% if (logs !=null && !logs.isEmpty()) { %>
                                                <table class="data-table" id="logTable">
                                                    <thead>
                                                        <tr>
                                                            <th>Waktu</th>
                                                            <th>User</th>
                                                            <th>Aksi</th>
                                                            <th>Tipe</th>
                                                            <th>Target</th>
                                                            <th>Deskripsi</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for (ActivityLog log : logs) { %>
                                                            <tr data-action="<%= log.getAction() %>"
                                                                data-type="<%= log.getTargetType() %>"
                                                                data-user="<%= log.getUserName().toLowerCase() %>"
                                                                data-desc="<%= log.getDescription() != null ? log.getDescription().toLowerCase() : "" %>">
                                                                <td>
                                                                    <div
                                                                        style="font-size: 0.85rem; color: var(--text-muted);">
                                                                        <i class="far fa-clock"></i>
                                                                        <%= log.getFormattedTime() %>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div
                                                                        style="display: flex; align-items: center; gap: 10px;">
                                                                        <div
                                                                            style="width: 32px; height: 32px; background: linear-gradient(135deg, var(--primary), var(--teal)); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 0.8rem;">
                                                                            <%= log.getUserName().substring(0,
                                                                                1).toUpperCase() %>
                                                                        </div>
                                                                        <div>
                                                                            <div
                                                                                style="font-weight: 600; color: var(--secondary);">
                                                                                <%= log.getUserName() %>
                                                                            </div>
                                                                            <div
                                                                                style="font-size: 0.7rem; color: var(--text-muted);">
                                                                                <%= log.getUserID() %>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <span
                                                                        class="badge <%= log.getActionBadgeClass() %>">
                                                                        <i class="fas <%= log.getActionIcon() %>"></i>
                                                                        <%= log.getAction() %>
                                                                    </span>
                                                                </td>
                                                                <td><span class="badge badge-primary">
                                                                        <%= log.getTargetType() %>
                                                                    </span></td>
                                                                <td style="font-weight: 500;">
                                                                    <%= log.getTargetName() !=null ? log.getTargetName()
                                                                        : "-" %>
                                                                </td>
                                                                <td
                                                                    style="font-size: 0.85rem; color: var(--text-muted); max-width: 300px;">
                                                                    <%= log.getDescription() !=null ?
                                                                        log.getDescription() : "-" %>
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                    </tbody>
                                                </table>
                                                <div id="noResults" class="no-results" style="display: none;">
                                                    <i class="fas fa-search"></i>
                                                    <p>Tidak ada log yang cocok dengan filter</p>
                                                </div>
                                                <% } else { %>
                                                    <div class="empty-state" style="padding: 60px 20px;">
                                                        <i class="fas fa-history"></i>
                                                        <p>Belum ada activity log</p>
                                                        <small style="color: var(--text-muted);">Log akan muncul setelah
                                                            ada aktivitas di sistem</small>
                                                    </div>
                                                    <% } %>
                                        </div>
                                    </div>
                                </main>
                            </div>
                            <script>
                                function filterTable() {
                                    const searchText = document.getElementById('searchInput').value.toLowerCase();
                                    const actionFilter = document.getElementById('actionFilter').value;
                                    const typeFilter = document.getElementById('typeFilter').value;
                                    const rows = document.querySelectorAll('#logTable tbody tr');
                                    let visibleCount = 0;

                                    rows.forEach(row => {
                                        const action = row.getAttribute('data-action');
                                        const type = row.getAttribute('data-type');
                                        const user = row.getAttribute('data-user');
                                        const desc = row.getAttribute('data-desc');

                                        const matchSearch = user.includes(searchText) || desc.includes(searchText);
                                        const matchAction = !actionFilter || action === actionFilter;
                                        const matchType = !typeFilter || type === typeFilter;

                                        if (matchSearch && matchAction && matchType) {
                                            row.style.display = '';
                                            visibleCount++;
                                        } else {
                                            row.style.display = 'none';
                                        }
                                    });

                                    document.getElementById('resultInfo').textContent = visibleCount + ' log ditemukan';
                                    document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
                                    document.getElementById('logTable').style.display = visibleCount === 0 ? 'none' : '';
                                }
                            </script>
                        </body>

                        </html>