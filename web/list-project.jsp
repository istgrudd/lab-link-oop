<%-- 
    Document   : list-project
    Created on : 25 Dec 2025, 22.50.34
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.Project"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // --- LOGIKA HAK AKSES ---
    String role = user.getAccessRole();
    // Siapa yang boleh MENGELOLA Proyek? (Admin & Ketua Internal)
    boolean canManageProject = "HEAD_OF_LAB".equals(role) || "HEAD_OF_INTERNAL".equals(role);
    
    // [PERBAIKAN SCOPE] Ambil data di sini agar bisa dipakai di FORM ATAS dan TABEL BAWAH
    List<Project> listP = (List<Project>) request.getAttribute("listProject");
    List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Manajemen Proyek - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard"><i class="bi bi-diagram-3-fill"></i> LabLink System</a>
                <div class="d-flex align-items-center">
                    <a href="dashboard" class="text-white me-3 text-decoration-none">Dashboard</a>
                    <span class="text-white me-3">
                        Halo, 
                        <a href="profile" class="text-white text-decoration-none fw-bold" title="Edit Profil">
                            <%= user.getName() %>
                        </a>
                        <span class="badge bg-light text-primary ms-1"><%= role %></span>
                    </span>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            
            <% if (canManageProject) { %>
            <div class="card card-custom mb-4">
                <div class="card-header card-header-custom">
                    <i class="bi bi-plus-circle"></i> Buat Proyek Baru
                </div>
                <div class="card-body card-body-custom">
                    <form action="project" method="post">
                        <input type="hidden" name="action" value="addProject">
                        <div class="row g-3">
                            
                            <div class="col-md-2">
                                <label class="form-label">Kode</label>
                                <input type="text" name="id" class="form-control" placeholder="PRJ-..." required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Nama Proyek</label>
                                <input type="text" name="name" class="form-control" placeholder="Judul..." required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Divisi Pemilik</label>
                                <select name="division" class="form-select">
                                    <option value="Big Data">Big Data</option>
                                    <option value="Cyber Security">Cyber Security</option>
                                    <option value="GIS">GIS</option>
                                    <option value="Game Tech">Game Tech</option>
                                    <option value="Lintas Divisi" class="fw-bold text-primary">Lintas Divisi</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">PM / Lead</label>
                                <select name="leaderID" class="form-select" required>
                                    <option value="" selected disabled>Pilih...</option>
                                    <% if(listM != null) { for(ResearchAssistant ra : listM) { %>
                                    <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                    <% }} %>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Tanggal Mulai</label>
                                <input type="date" name="startDate" class="form-control" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Target Selesai</label>
                                <input type="date" name="endDate" class="form-control" required>
                            </div>
                            
                            <div class="col-md-3">
                                <label class="form-label">Tipe & Status</label>
                                <div class="input-group">
                                    <select name="type" class="form-select">
                                        <option value="Riset">Riset</option>
                                        <option value="HKI">HKI</option>
                                    </select>
                                    <select name="status" class="form-select">
                                        <option value="Ongoing">On</option>
                                        <option value="Done">Done</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary-custom w-100">Simpan Proyek</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

            <div class="card card-custom">
                <div class="card-header card-header-custom border-0">
                    <i class="bi bi-list-task"></i> Daftar Aktivitas Lab
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-custom table-hover mb-0 text-nowrap">
                            <thead>
                                <tr>
                                    <th>Kode</th>
                                    <th>Divisi</th> 
                                    <th>Nama Proyek</th>
                                    <th>Leader</th> 
                                    <th>Timeline</th> <th>Tipe</th>
                                    <th>Status</th>
                                    <th>Tim (Member)</th>
                                    <% if (canManageProject) { %> <th>Aksi</th> <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    if (listP != null && !listP.isEmpty()) {
                                        for (Project p : listP) {
                                %>
                                <tr>
                                    <td><%= p.getProjectID() %></td>
                                    
                                    <td>
                                        <% if("Lintas Divisi".equals(p.getDivision())) { %>
                                            <span class="badge bg-primary"><i class="bi bi-diagram-3"></i> Lintas</span>
                                        <% } else { %>
                                            <span class="text-secondary fw-bold"><%= p.getDivision() %></span>
                                        <% } %>
                                    </td>

                                    <td class="fw-bold"><%= p.getProjectName() %></td>
                                    
                                    <td>
                                        <% if(p.getLeaderName() != null) { %>
                                            <span class="badge bg-warning text-dark">
                                                <i class="bi bi-star-fill"></i> <%= p.getLeaderName() %>
                                            </span>
                                        <% } else { %> - <% } %>
                                    </td>
                                    
                                    <td>
                                        <small class="text-muted d-block">Start: <%= p.getStartDate() == null ? "-" : p.getStartDate() %></small>
                                        <small class="text-muted">End: <%= p.getEndDate() == null ? "-" : p.getEndDate() %></small>
                                    </td>
                                    
                                    <td><span class="badge bg-secondary"><%= p.getActivityType() %></span></td>
                                    
                                    <td>
                                        <% if("Ongoing".equals(p.getStatus())) { %>
                                            <span class="badge bg-warning text-dark">Ongoing</span>
                                        <% } else { %>
                                            <span class="badge bg-success">Completed</span>
                                        <% } %>
                                    </td>
                                    
                                    <td>
                                        <% for(String memberName : p.getTeamMembers()) { %>
                                            <span class="badge bg-info text-dark mb-1"><%= memberName %></span>
                                        <% } %>
                                        
                                        <% if (p.getTeamMembers().isEmpty()) { %>
                                            <small class="text-muted fst-italic">Belum ada tim</small>
                                        <% } %>
                                    </td>
                                    
                                    <% if (canManageProject) { %>
                                    <td>
                                        <div class="d-flex gap-2">
                                            
                                            <a href="project?action=edit&id=<%= p.getProjectID() %>" 
                                               class="btn btn-sm btn-warning text-white" 
                                               title="Edit Proyek">
                                                <i class="bi bi-pencil-square"></i>
                                            </a>

                                            <% if ("Completed".equals(p.getStatus())) { %>
                                                <a href="archive?action=createFromProject&projectID=<%= p.getProjectID() %>" 
                                                   class="btn btn-sm btn-success text-white" 
                                                   title="Masuk ke Arsip (F4)">
                                                    <i class="bi bi-archive-fill"></i>
                                                </a>
                                            <% } %>

                                            <form action="project" method="post" class="d-flex gap-1">
                                                <input type="hidden" name="action" value="assignMember">
                                                <input type="hidden" name="projectID" value="<%= p.getProjectID() %>">
                                                
                                                <select name="memberID" class="form-select form-select-sm" style="width: 100px;" required>
                                                    <option value="" selected disabled>+Tim</option>
                                                    <% if(listM != null) { 
                                                        for(ResearchAssistant ra : listM) { %>
                                                        <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                                    <% }} %>
                                                </select>
                                                <button type="submit" class="btn btn-sm btn-outline-primary" title="Tambahkan">
                                                    <i class="bi bi-plus"></i>
                                                </button>
                                            </form>

                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <% 
                                        }
                                    } else { 
                                %>
                                <tr><td colspan="<%= canManageProject ? 9 : 8 %>" class="text-center py-4 text-muted">Belum ada proyek terdaftar.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>