<%-- 
    Document   : report
    Created on : 26 Dec 2025, 22.16.06
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    Map<String, Integer> s = (Map<String, Integer>) request.getAttribute("summary");
    List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
    List<Project> listP = (List<Project>) request.getAttribute("listProject");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Laporan Kinerja Lab - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard"><i class="bi bi-printer-fill"></i> Pusat Laporan</a>
                <div class="d-flex align-items-center">
                    <a href="dashboard" class="text-white me-3 text-decoration-none">Dashboard</a>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            
            <div class="print-title">
                <h3>LAPORAN KINERJA LABORATORIUM</h3>
                <h4>MBC LABORATORY - TELKOM UNIVERSITY</h4>
                <p>Periode: 2025</p>
                <hr>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-4 no-print">
                <h4 class="text-primary fw-bold">Ringkasan Statistik</h4>
                <button onclick="window.print()" class="btn btn-primary-custom">
                    <i class="bi bi-printer"></i> Cetak Laporan
                </button>
            </div>

            <div class="row g-3 mb-5">
                <div class="col-md-3 col-6">
                    <div class="card bg-primary text-white h-100">
                        <div class="card-body text-center">
                            <h1><%= s.get("totalMember") %></h1>
                            <small>Total Anggota</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-success text-white h-100">
                        <div class="card-body text-center">
                            <h1><%= s.get("projectCompleted") %></h1>
                            <small>Proyek Selesai</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-warning text-dark h-100">
                        <div class="card-body text-center">
                            <h1><%= s.get("projectOngoing") %></h1>
                            <small>Proyek Berjalan</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="card bg-info text-white h-100">
                        <div class="card-body text-center">
                            <h1><%= s.get("totalPublikasi") + s.get("totalHKI") %></h1>
                            <small>Total Output (Pub & HKI)</small>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mb-4 border-0">
                <div class="card-header bg-light fw-bold border-bottom">1. Rekapitulasi Anggota Riset</div>
                <div class="card-body p-0">
                    <table class="table table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th> <th>Nama</th> <th>Divisi</th> <th>Jabatan</th> <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int no=1; for(ResearchAssistant ra : listM) { %>
                            <tr>
                                <td><%= no++ %></td>
                                <td><%= ra.getName() %></td>
                                <td><%= ra.getExpertDivision() %></td>
                                <td><%= ra.getRoleTitle() %></td>
                                <td>Aktif</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card mb-4 border-0">
                <div class="card-header bg-light fw-bold border-bottom">2. Rekapitulasi Aktivitas Proyek</div>
                <div class="card-body p-0">
                    <table class="table table-bordered mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Kode</th> <th>Judul Proyek</th> <th>Leader</th> <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Project p : listP) { %>
                            <tr>
                                <td><%= p.getProjectID() %></td>
                                <td><%= p.getProjectName() %></td>
                                <td><%= p.getLeaderName() == null ? "-" : p.getLeaderName() %></td>
                                <td><%= p.getStatus() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="print-signature">
                <p>Bandung, .......................</p>
                <br><br><br>
                <p class="fw-bold text-decoration-underline"><%= user.getName() %></p>
                <p>Ketua Laboratorium</p>
            </div>

        </div>
    </body>
</html>
