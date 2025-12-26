<%-- 
    Document   : dashboard
    Created on : 25 Dec 2025, 22.39.28
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.LabMember"%>
<%@page import="com.lablink.model.AgendaItem"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Ambil data agenda dari Controller
    List<AgendaItem> agenda = (List<AgendaItem>) request.getAttribute("agendaList");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard Utama - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Custom Style untuk Timeline */
            .timeline-date {
                font-size: 0.85rem;
                font-weight: bold;
                color: #6c757d;
                width: 90px;
            }
            .timeline-content {
                border-left: 3px solid #dee2e6;
                padding-left: 15px;
                padding-bottom: 15px;
            }
            .timeline-item:last-child .timeline-content {
                padding-bottom: 0;
            }
        </style>
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-4">
            <div class="container">
                <a class="navbar-brand" href="dashboard"><i class="bi bi-diagram-3-fill"></i> LabLink System</a>
                <div class="d-flex align-items-center">
                    <span class="text-white me-3">
                        Halo, <a href="profile" class="text-white text-decoration-none fw-bold"><%= user.getName() %></a>
                    </span>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="mb-4">
                <h3 class="fw-bold text-primary">Dashboard Overview</h3>
                <p class="text-muted">Selamat datang kembali. Berikut adalah ringkasan aktivitas lab.</p>
            </div>

            <div class="row">
                
                <div class="col-lg-8 mb-4">
                    <div class="row g-3">
                        
                        <div class="col-6 col-lg-6">
                            <a href="member" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-primary text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-people-fill"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Manajemen Anggota</h6>
                                            <small class="text-muted">Database Asisten Riset</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-6 col-lg-6">
                            <a href="project" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-success text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-kanban-fill"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Proyek & Riset</h6>
                                            <small class="text-muted">Monitoring Progres Internal</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-6 col-lg-6">
                            <a href="event" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-warning text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-calendar-event-fill"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Kegiatan Eksternal</h6>
                                            <small class="text-muted">Event & Kepanitiaan</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-6 col-lg-6">
                            <a href="archive" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-danger text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-journal-bookmark-fill"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Arsip Output</h6>
                                            <small class="text-muted">Publikasi & HKI</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-6 col-lg-6">
                            <a href="report" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-info text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-printer-fill"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Pusat Laporan</h6>
                                            <small class="text-muted">Cetak Kinerja Lab</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-6 col-lg-6">
                            <a href="profile" class="text-decoration-none">
                                <div class="card card-custom card-menu h-100">
                                    <div class="card-body card-body-custom d-flex align-items-center">
                                        <div class="icon-circle bg-secondary text-white me-3 mb-0" style="width: 50px; height: 50px; font-size: 1.2rem;">
                                            <i class="bi bi-person-circle"></i>
                                        </div>
                                        <div>
                                            <h6 class="card-title text-dark mb-1 fw-bold">Profil Saya</h6>
                                            <small class="text-muted">Pengaturan Akun</small>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>

                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card card-custom h-100 border-0 shadow-sm">
                        <div class="card-header bg-white border-0 pt-4 px-4">
                            <h5 class="fw-bold mb-0"><i class="bi bi-clock-history text-primary"></i> Agenda Mendatang</h5>
                            <small class="text-muted">Jadwal Event & Deadline Proyek</small>
                        </div>
                        <div class="card-body px-4">
                            
                            <% if (agenda != null && !agenda.isEmpty()) { 
                                for (AgendaItem item : agenda) {
                            %>
                            <div class="d-flex timeline-item">
                                <div class="timeline-date pt-1">
                                    <%= item.getDate() %>
                                </div>
                                <div class="timeline-content w-100">
                                    <span class="badge bg-<%= item.getBadgeColor() %> mb-1"><%= item.getCategory() %></span>
                                    <h6 class="mb-1 fw-bold text-dark" style="font-size: 0.95rem;"><%= item.getTitle() %></h6>
                                    <small class="text-muted"><i class="bi bi-info-circle"></i> <%= item.getInfo() %></small>
                                </div>
                            </div>
                            <%  } 
                               } else { 
                            %>
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-check text-muted" style="font-size: 3rem;"></i>
                                <p class="text-muted mt-2">Tidak ada agenda dalam waktu dekat.</p>
                            </div>
                            <% } %>

                        </div>
                        <div class="card-footer bg-white border-0 text-center pb-4">
                            <a href="project" class="text-decoration-none small fw-bold">Lihat Semua Proyek &rarr;</a>
                        </div>
                    </div>
                </div>

            </div>
            
            <div class="text-center text-muted mt-5 mb-4">
                <small>&copy; 2025 LabLink System - Telkom University</small>
            </div>
        </div>

        <div class="bottom-nav">
            <a href="dashboard" class="bottom-nav-item active">
                <i class="bi bi-house-door-fill"></i>
                Home
            </a>
            <a href="project" class="bottom-nav-item">
                <i class="bi bi-kanban"></i>
                Proyek
            </a>
            <a href="event" class="bottom-nav-item">
                <i class="bi bi-calendar-event"></i>
                Event
            </a>
            <a href="report" class="bottom-nav-item">
                <i class="bi bi-file-earmark-bar-graph"></i>
                Laporan
            </a>
            <a href="profile" class="bottom-nav-item">
                <i class="bi bi-person-circle"></i>
                Profil
            </a>
        </div>

    </body>
</html>