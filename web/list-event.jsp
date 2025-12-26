<%-- 
    Document   : list-event
    Created on : 26 Dec 2025, 00.15.55
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.LabEvent"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.LabMember"%>

<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    
    // Cek Hak Akses
    String role = user.getAccessRole();
    boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);

    // [PERBAIKAN PENTING] 
    // Deklarasikan listM DI SINI (Global Scope halaman ini)
    List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Kegiatan Eksternal - LabLink</title>
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
                        Halo, <a href="profile" class="text-white text-decoration-none fw-bold"><%= user.getName() %></a>
                        <span class="badge bg-light text-primary ms-1"><%= role %></span>
                    </span>
                    <a href="logout" class="btn btn-sm btn-logout">Logout</a>
                </div>
            </div>
        </nav>

        <div class="container">
            
            <% if (canManage) { %>
            <div class="card card-custom mb-4">
                <div class="card-header card-header-custom"><i class="bi bi-calendar-plus"></i> Tambah Kegiatan Baru</div>
                <div class="card-body card-body-custom">
                    <form action="event" method="post">
                        <input type="hidden" name="action" value="addEvent">
                        <div class="row g-3">
                            <div class="col-md-2">
                                <label class="form-label">Kode Event</label>
                                <input type="text" name="id" class="form-control" placeholder="EVT-01" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Nama Kegiatan</label>
                                <input type="text" name="name" class="form-control" placeholder="Ex: Company Visit" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tanggal Pelaksanaan</label>
                                <input type="date" name="date" class="form-control" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">PIC (Penanggung Jawab)</label>
                                <select name="picID" class="form-select" required>
                                    <option value="" selected disabled>Pilih PIC...</option>
                                    <% 
                                        if(listM != null) {
                                            for(ResearchAssistant ra : listM) {
                                    %>
                                    <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                    <% }} %>
                                </select>
                            </div>
                            <div class="col-12 text-end">
                                <button type="submit" class="btn btn-primary-custom" style="width: auto;">Simpan Kegiatan</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <% } %>

            <div class="card card-custom">
                <div class="card-header card-header-custom border-0"><i class="bi bi-calendar-event"></i> Daftar Kegiatan Lab</div>
                <div class="card-body p-0">
                    
                    <div class="table-responsive">
                        <table class="table table-custom table-hover mb-0 text-nowrap">
                            <thead>
                                <tr>
                                    <th>Kode</th>
                                    <th>Tanggal</th>
                                    <th>Nama Kegiatan</th>
                                    <th>PIC</th>
                                    <th>Panitia</th>
                                    <% if (canManage) { %> <th>Aksi</th> <% } %>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<LabEvent> listE = (List<LabEvent>) request.getAttribute("listEvent");
                                    if (listE != null && !listE.isEmpty()) {
                                        for (LabEvent e : listE) {
                                %>
                                <tr>
                                    <td><%= e.getEventID() %></td>
                                    <td><span class="badge bg-light text-dark border"><i class="bi bi-calendar3"></i> <%= e.getEventDate() %></span></td>
                                    <td class="fw-bold"><%= e.getEventName() %></td>
                                    <td>
                                        <% if(e.getPicName() != null) { %>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-star-fill"></i> <%= e.getPicName() %></span>
                                        <% } else { %> - <% } %>
                                    </td>
                                    <td>
                                        <% for(String com : e.getCommitteeNames()) { %>
                                            <span class="badge bg-info text-dark mb-1"><%= com %></span>
                                        <% } %>
                                    </td>
                                    
                                    <% if (canManage) { %>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="event?action=edit&id=<%= e.getEventID() %>" class="btn btn-sm btn-warning text-white"><i class="bi bi-pencil-square"></i></a>
                                            
                                            <form action="event" method="post" class="d-flex gap-1">
                                                <input type="hidden" name="action" value="addCommittee">
                                                <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                                                
                                                <select name="memberID" class="form-select form-select-sm" style="width: 100px;" required>
                                                    <option value="" disabled selected>+Tim</option>
                                                    <% if(listM != null) { for(ResearchAssistant ra : listM) { %>
                                                    <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                                    <% }} %>
                                                </select>

                                                <select name="roles" class="form-select form-select-sm" style="width: 100px;" required>
                                                    <option value="" disabled selected>Divisi...</option>
                                                    <option value="Acara">Acara</option>
                                                    <option value="Humas">Humas</option>
                                                    <option value="Logistik">Logistik</option>
                                                    <option value="Media">Media</option>
                                                    <option value="Konsumsi">Konsumsi</option>
                                                    <option value="Anggota">Anggota</option>
                                                </select>
                                                
                                                <button type="submit" class="btn btn-sm btn-outline-primary"><i class="bi bi-plus"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                    <% } %>
                                </tr>
                                <% }} else { %>
                                <tr><td colspan="<%= canManage ? 6 : 5 %>" class="text-center py-4 text-muted">Belum ada kegiatan.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div> </div>
            </div>
        </div>
    </body>
</html>