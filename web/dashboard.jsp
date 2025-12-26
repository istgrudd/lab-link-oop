<%-- 
    Document   : dashboard
    Created on : 25 Dec 2025, 22.39.28
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard Utama - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard"><i class="bi bi-diagram-3-fill"></i> LabLink System</a>
                <div class="d-flex align-items-center">
                    <a href="profile" class="text-white text-decoration-none fw-bold me-3" title="Edit Profil">
                        Halo, <%= user.getName() %>
                    </a>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold text-primary">Selamat Datang di LabLink</h2>
                <p class="text-muted">Pilih menu di bawah ini untuk memulai aktivitas manajemen lab.</p>
            </div>

            <div class="row g-4">
                
                <div class="col-md-4">
                    <a href="member" class="text-decoration-none">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-primary text-white mx-auto">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                                <h5 class="card-title text-dark">Manajemen Anggota</h5>
                                <p class="card-text text-muted small">Kelola data Asisten Riset, Jabatan, dan Divisi Keahlian.</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="project" class="text-decoration-none">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-success text-white mx-auto">
                                    <i class="bi bi-kanban-fill"></i>
                                </div>
                                <h5 class="card-title text-dark">Proyek & Riset</h5>
                                <p class="card-text text-muted small">Monitoring status proyek internal, Riset, dan Assignment Tim.</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="event" class="text-decoration-none">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-warning text-white mx-auto">
                                    <i class="bi bi-calendar-event-fill"></i>
                                </div>
                                <h5 class="card-title text-dark">Kegiatan Eksternal</h5>
                                <p class="card-text text-muted small">Manajemen Company Visit, Workshop, dan Kepanitiaan.</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="#" class="text-decoration-none" onclick="alert('Fitur Arsip (F4) akan segera hadir!')">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-danger text-white mx-auto">
                                    <i class="bi bi-journal-bookmark-fill"></i>
                                </div>
                                <h5 class="card-title text-dark">Arsip & Publikasi</h5>
                                <p class="card-text text-muted small">Database Publikasi Ilmiah dan Hak Kekayaan Intelektual (HKI).</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="#" class="text-decoration-none" onclick="alert('Fitur Laporan (F5) akan segera hadir!')">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-info text-white mx-auto">
                                    <i class="bi bi-printer-fill"></i>
                                </div>
                                <h5 class="card-title text-dark">Laporan (Reporting)</h5>
                                <p class="card-text text-muted small">Cetak laporan kinerja anggota dan rekap aktivitas lab.</p>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="col-md-4">
                    <a href="profile" class="text-decoration-none">
                        <div class="card card-custom card-menu">
                            <div class="card-body card-body-custom text-center">
                                <div class="icon-circle bg-secondary text-white mx-auto">
                                    <i class="bi bi-person-circle"></i>
                                </div>
                                <h5 class="card-title text-dark">Profil Saya</h5>
                                <p class="card-text text-muted small">Update biodata diri, divisi, dan ganti password akun.</p>
                            </div>
                        </div>
                    </a>
                </div>

            </div>
            
            <div class="text-center text-muted mt-5 mb-5">
                <small>&copy; 2025 LabLink System - Telkom University</small>
            </div>
        </div>
    </body>
</html>