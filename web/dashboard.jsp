<%-- 
    Document   : dashboard
    Created on : 25 Dec 2025, 22.39.28
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.LabMember"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.lablink.model.AgendaItem"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>

<%
    // Cek Session
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Ambil Data dari Controller
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<AgendaItem> agendaList = (List<AgendaItem>) request.getAttribute("agendaList");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - LabLink</title>
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>

        <div class="dashboard-container">
            
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>LabLink</h2>
                    <p>Welcome, <%= user.getName() %></p>
                </div>
                
                <nav class="sidebar-menu">
                    <ul>
                        <li class="active"><a href="dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
                        <li><a href="project"><i class="fas fa-project-diagram"></i> Proyek</a></li>
                        <li><a href="event"><i class="fas fa-calendar-alt"></i> Event & Kegiatan</a></li>
                        <li><a href="member"><i class="fas fa-users"></i> Anggota Lab</a></li>
                        <li><a href="archive"><i class="fas fa-archive"></i> Arsip Output</a></li>
                        <li><a href="report"><i class="fas fa-chart-bar"></i> Laporan</a></li>
                        <li><a href="administration.jsp" class="new-feature"><i class="fas fa-file-alt"></i> Administrasi</a></li>
                    </ul>
                </nav>

                <div class="sidebar-footer">
                    <a href="login?action=logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </aside>

            <main class="main-content">
                
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Dashboard Overview</h1>
                        <p class="text-muted small">Ringkasan aktivitas hari ini</p>
                    </div>
                    
                    <div class="date-display">
                        <i class="far fa-calendar-alt me-2"></i>
                        <% 
                            LocalDate today = LocalDate.now();
                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy", new Locale("id", "ID"));
                            String dateString = today.format(formatter);
                        %>
                        <%= dateString %>
                    </div>
                </header>

                <section class="stats-grid">
                    <div class="stat-card blue">
                        <div class="icon"><i class="fas fa-spinner"></i></div>
                        <div class="info">
                            <h3><%= stats.getOrDefault("projectOngoing", 0) %></h3>
                            <p>Proyek Berjalan</p>
                        </div>
                    </div>
                    
                    <div class="stat-card green">
                        <div class="icon"><i class="fas fa-check-circle"></i></div>
                        <div class="info">
                            <h3><%= stats.getOrDefault("projectCompleted", 0) %></h3>
                            <p>Proyek Selesai</p>
                        </div>
                    </div>

                    <div class="stat-card orange">
                        <div class="icon"><i class="fas fa-bullhorn"></i></div>
                        <div class="info">
                            <h3><%= stats.getOrDefault("totalEvent", 0) %></h3>
                            <p>Total Event</p>
                        </div>
                    </div>

                    <div class="stat-card purple">
                        <div class="icon"><i class="fas fa-book"></i></div>
                        <div class="info">
                            <h3><%= stats.getOrDefault("totalPublikasi", 0) %></h3>
                            <p>Total Publikasi</p>
                        </div>
                    </div>
                </section>

                <div class="content-split">
                    <section class="agenda-section">
                        <h2><i class="fas fa-clock"></i> Agenda Mendatang</h2>
                        <div class="agenda-list">
                            <% if (agendaList != null && !agendaList.isEmpty()) { 
                                for (AgendaItem item : agendaList) { 
                                    // [PERBAIKAN 1] Parse String tanggal ke LocalDate
                                    LocalDate date = LocalDate.parse(item.getDate());
                            %>
                                <div class="agenda-card">
                                    <div class="date-box">
                                        <span class="day"><%= date.getDayOfMonth() %></span>
                                        <span class="month"><%= date.getMonth() %></span>
                                    </div>
                                    <div class="agenda-details">
                                        <h4><%= item.getTitle() %></h4>
                                        
                                        <span class="badge <%= "Proyek".equals(item.getCategory()) ? "badge-danger" : "badge-success" %>">
                                            <%= item.getCategory() %>
                                        </span>
                                        
                                        <p><%= item.getInfo() %></p>
                                    </div>
                                </div>
                            <%  } 
                               } else { %>
                                <p class="empty-state">Tidak ada agenda mendesak.</p>
                            <% } %>
                        </div>
                    </section>

                    <section class="tasks-section">
                        <h2><i class="fas fa-tasks"></i> Tugas Saya</h2>
                        <div class="task-placeholder">
                            <p>Fitur "My Tasks" akan menampilkan proyek di mana Anda terlibat.</p>
                            <a href="project" class="btn-small">Lihat Semua Proyek</a>
                        </div>
                    </section>
                </div>

            </main>
        </div>
        <nav class="bottom-nav">
            <a href="dashboard" class="bottom-nav-item active">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </a>
            <a href="project" class="bottom-nav-item">
                <i class="fas fa-project-diagram"></i>
                <span>Proyek</span>
            </a>
            <a href="event" class="bottom-nav-item">
                <i class="fas fa-calendar-alt"></i>
                <span>Event</span>
            </a>
            <a href="administration.jsp" class="bottom-nav-item">
                <i class="fas fa-file-alt"></i>
                <span>Admin</span>
            </a>
            <a href="profile.jsp" class="bottom-nav-item">
                <i class="fas fa-user"></i>
                <span>Akun</span>
            </a>
        </nav>

        <script>
            const currentPath = window.location.pathname;
            const navLinks = document.querySelectorAll('.bottom-nav-item, .sidebar-menu a');
            
            navLinks.forEach(link => {
                if(link.getAttribute('href') !== '#' && currentPath.includes(link.getAttribute('href'))) {
                    link.classList.add('active'); // Tambahkan class active jika URL cocok
                }
            });
        </script>

    </body>
</html>