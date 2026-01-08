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
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    List<AgendaItem> agendaList = (List<AgendaItem>) request.getAttribute("agendaList");
    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, dd MMMM yyyy", new Locale("id", "ID"));
    String dateString = today.format(formatter);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-th-large"></i> Dashboard</h1>
                    <p class="page-subtitle">Selamat datang kembali, <strong><%= user.getName() %></strong></p>
                </div>
                <div class="top-bar-right">
                    <div class="date-badge"><i class="far fa-calendar-alt"></i> <span><%= dateString %></span></div>
                </div>
            </header>
            <section class="stats-section">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fas fa-spinner fa-pulse"></i></div>
                    <div class="stat-info">
                        <h3 class="stat-value"><%= stats != null ? stats.getOrDefault("projectOngoing", 0) : 0 %></h3>
                        <p class="stat-label">Proyek Berjalan</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-info">
                        <h3 class="stat-value"><%= stats != null ? stats.getOrDefault("projectCompleted", 0) : 0 %></h3>
                        <p class="stat-label">Proyek Selesai</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange"><i class="fas fa-bullhorn"></i></div>
                    <div class="stat-info">
                        <h3 class="stat-value"><%= stats != null ? stats.getOrDefault("totalEvent", 0) : 0 %></h3>
                        <p class="stat-label">Total Event</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="fas fa-book"></i></div>
                    <div class="stat-info">
                        <h3 class="stat-value"><%= stats != null ? stats.getOrDefault("totalPublikasi", 0) : 0 %></h3>
                        <p class="stat-label">Publikasi</p>
                    </div>
                </div>
            </section>
            <div class="content-grid">
                <section class="content-card agenda-card">
                    <div class="card-header">
                        <h2><i class="fas fa-clock"></i> Agenda Mendatang</h2>
                        <a href="event" class="btn-link">Lihat Semua <i class="fas fa-arrow-right"></i></a>
                    </div>
                    <div class="card-body">
                        <div class="agenda-list">
                            <% if (agendaList != null && !agendaList.isEmpty()) { 
                                for (AgendaItem item : agendaList) { 
                                    LocalDate date = LocalDate.parse(item.getDate());
                            %>
                                <div class="agenda-item">
                                    <div class="agenda-date">
                                        <span class="day"><%= date.getDayOfMonth() %></span>
                                        <span class="month"><%= date.getMonth().toString().substring(0, 3) %></span>
                                    </div>
                                    <div class="agenda-content">
                                        <h4><%= item.getTitle() %></h4>
                                        <div class="agenda-meta">
                                            <span class="badge <%= "Proyek".equals(item.getCategory()) ? "badge-danger" : "badge-success" %>"><%= item.getCategory() %></span>
                                            <span class="agenda-info"><%= item.getInfo() %></span>
                                        </div>
                                    </div>
                                </div>
                            <% } } else { %>
                                <div class="empty-state"><i class="fas fa-calendar-check"></i><p>Tidak ada agenda mendatang</p></div>
                            <% } %>
                        </div>
                    </div>
                </section>
                <section class="content-card tasks-card">
                    <div class="card-header"><h2><i class="fas fa-bolt"></i> Aksi Cepat</h2></div>
                    <div class="card-body">
                        <div class="quick-actions">
                            <a href="project" class="quick-action-item"><div class="qa-icon blue"><i class="fas fa-folder-plus"></i></div><span>Lihat Proyek</span></a>
                            <a href="event" class="quick-action-item"><div class="qa-icon orange"><i class="fas fa-calendar-plus"></i></div><span>Lihat Event</span></a>
                            <a href="member" class="quick-action-item"><div class="qa-icon green"><i class="fas fa-user-plus"></i></div><span>Anggota Lab</span></a>
                            <a href="report" class="quick-action-item"><div class="qa-icon purple"><i class="fas fa-file-alt"></i></div><span>Laporan</span></a>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </div>
</body>
</html>
