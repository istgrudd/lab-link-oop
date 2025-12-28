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
        <title>Laporan Kinerja - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* Style khusus Print agar Sidebar Hilang */
            @media print {
                .sidebar, .bottom-nav, .top-bar, .no-print { display: none !important; }
                .main-content { margin-left: 0 !important; width: 100% !important; padding: 0 !important; }
                body { background: white; }
                .print-title { display: block !important; text-align: center; margin-bottom: 20px; }
            }
            .print-title { display: none; }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar no-print">
                    <div class="welcome-text">
                        <h1>Pusat Laporan</h1>
                        <p class="text-muted small">Rekapitulasi Kinerja Laboratorium</p>
                    </div>
                    <div>
                        <button onclick="window.print()" class="btn-small" style="background:var(--secondary-color); color:white; border:none; cursor:pointer;">
                            <i class="fas fa-print"></i> Cetak Laporan
                        </button>
                    </div>
                </header>

                <div class="print-title">
                    <h3>LAPORAN KINERJA LABORATORIUM</h3>
                    <h4>MBC LABORATORY - TELKOM UNIVERSITY</h4>
                    <p>Periode: 2025</p>
                    <hr>
                </div>

                <div class="stats-grid">
                    <div class="stat-card blue">
                        <div class="info"><h3><%= s.get("totalMember") %></h3><p>Total Anggota</p></div>
                    </div>
                    <div class="stat-card green">
                        <div class="info"><h3><%= s.get("projectCompleted") %></h3><p>Proyek Selesai</p></div>
                    </div>
                    <div class="stat-card orange">
                        <div class="info"><h3><%= s.get("projectOngoing") %></h3><p>Proyek Berjalan</p></div>
                    </div>
                    <div class="stat-card purple">
                        <div class="info"><h3><%= s.get("totalPublikasi") + s.get("totalHKI") %></h3><p>Total Output</p></div>
                    </div>
                </div>

                <div class="tasks-section" style="margin-top:20px;">
                    <h3>1. Rekapitulasi Anggota Riset</h3>
                    <table style="width:100%; border-collapse:collapse; margin-top:10px;" border="1" bordercolor="#eee">
                        <thead style="background:#f5f5f5;">
                            <tr><th>No</th><th>Nama</th><th>Divisi</th><th>Jabatan</th></tr>
                        </thead>
                        <tbody>
                            <% int no=1; for(ResearchAssistant ra : listM) { %>
                            <tr>
                                <td style="padding:8px;"><%= no++ %></td>
                                <td style="padding:8px;"><%= ra.getName() %></td>
                                <td style="padding:8px;"><%= ra.getExpertDivision() %></td>
                                <td style="padding:8px;"><%= ra.getRoleTitle() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                 <div class="tasks-section" style="margin-top:20px;">
                    <h3>2. Rekapitulasi Aktivitas Proyek</h3>
                    <table style="width:100%; border-collapse:collapse; margin-top:10px;" border="1" bordercolor="#eee">
                        <thead style="background:#f5f5f5;">
                            <tr><th>Kode</th><th>Judul Proyek</th><th>Leader</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <% for(Project p : listP) { %>
                            <tr>
                                <td style="padding:8px;"><%= p.getProjectID() %></td>
                                <td style="padding:8px;"><%= p.getProjectName() %></td>
                                <td style="padding:8px;"><%= p.getLeaderName() == null ? "-" : p.getLeaderName() %></td>
                                <td style="padding:8px;"><%= p.getStatus() %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="print-signature" style="margin-top:50px; display:none;">
                    <p>Bandung, .......................</p>
                    <br><br>
                    <p style="font-weight:bold; text-decoration:underline;"><%= user.getName() %></p>
                    <p>Ketua Laboratorium</p>
                </div>

                <script>
                    window.onbeforeprint = function() {
                        document.querySelector('.print-signature').style.display = 'block';
                    };
                    window.onafterprint = function() {
                        document.querySelector('.print-signature').style.display = 'none';
                    };
                </script>

            </main>
        </div>
        
         <nav class="bottom-nav">
             <a href="dashboard" class="bottom-nav-item"><i class="fas fa-home"></i> <span>Home</span></a>
             <a href="report" class="bottom-nav-item active"><i class="fas fa-chart-bar"></i> <span>Laporan</span></a>
        </nav>
    </body>
</html>