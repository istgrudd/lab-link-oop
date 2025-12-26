<%-- 
    Document   : edit-event
    Created on : 26 Dec 2025, 00.16.30
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.LabEvent"%>
<%@page import="com.lablink.model.ResearchAssistant"%>
<%@page import="com.lablink.model.CommitteeMember"%> 
<%@page import="java.util.List"%>

<%
    LabEvent e = (LabEvent) request.getAttribute("event");
    List<ResearchAssistant> listMember = (List<ResearchAssistant>) request.getAttribute("listMember");
    // Ambil list panitia
    List<CommitteeMember> listCom = (List<CommitteeMember>) request.getAttribute("listCommittee");
    
    if (e == null) { response.sendRedirect("event"); return; }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Kegiatan - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"> 
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        
        <nav class="navbar navbar-expand-lg navbar-custom mb-5">
            <div class="container">
                <a class="navbar-brand" href="dashboard">LabLink System</a>
            </div>
        </nav>

        <div class="container mt-5 mb-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    
                    <div class="card card-custom mb-4">
                        <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                            <span>Edit Data Kegiatan</span>
                            
                            <form action="event" method="post" onsubmit="return confirm('Yakin ingin MENGHAPUS kegiatan ini? Data tidak bisa dikembalikan.');">
                                <input type="hidden" name="action" value="deleteEvent">
                                <input type="hidden" name="id" value="<%= e.getEventID() %>">
                                <button type="submit" class="btn btn-sm btn-danger">
                                    <i class="bi bi-trash-fill"></i> Hapus Kegiatan
                                </button>
                            </form>
                        </div>

                        <div class="card-body card-body-custom">
                            <form action="event" method="post">
                                <input type="hidden" name="action" value="updateEvent">
                                
                                <div class="mb-3">
                                    <label class="form-label">Kode Event</label>
                                    <input type="text" name="id" class="form-control" value="<%= e.getEventID() %>" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nama Kegiatan</label>
                                    <input type="text" name="name" class="form-control" value="<%= e.getEventName() %>" required>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Tanggal</label>
                                        <input type="date" name="date" class="form-control" value="<%= e.getEventDate() %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">PIC</label>
                                        <select name="picID" class="form-select" required>
                                            <% for(ResearchAssistant ra : listMember) { 
                                                boolean isSelected = ra.getMemberID().equals(e.getPicID()); %>
                                            <option value="<%= ra.getMemberID() %>" <%= isSelected ? "selected" : "" %>><%= ra.getName() %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <a href="event" class="btn btn-outline-secondary">Kembali</a>
                                    <button type="submit" class="btn btn-primary-custom" style="width: auto;">Simpan Data Utama</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card card-custom">
                        <div class="card-header card-header-custom bg-light d-flex justify-content-between align-items-center">
                            <span>Manajemen Panitia</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0 align-middle text-nowrap">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">Nama Anggota</th>
                                            <th>Divisi / Peran</th>
                                            <th class="text-end pe-4">Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (listCom != null && !listCom.isEmpty()) { 
                                            for (CommitteeMember cm : listCom) { 
                                        %>
                                        <tr>
                                            <td class="ps-4 fw-bold"><%= cm.getMemberName() %></td>
                                            <td>
                                                <form action="event" method="post" class="d-flex align-items-center">
                                                    <input type="hidden" name="action" value="updateCommitteeRole">
                                                    <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                                                    <input type="hidden" name="memberID" value="<%= cm.getMemberID() %>">
                                                    
                                                    <select name="role" class="form-select form-select-sm me-2" style="width: 140px;" onchange="this.form.submit()">
                                                        <option value="Acara" <%= "Acara".equals(cm.getRole()) ? "selected" : "" %>>Acara</option>
                                                        <option value="Humas" <%= "Humas".equals(cm.getRole()) ? "selected" : "" %>>Humas</option>
                                                        <option value="Logistik" <%= "Logistik".equals(cm.getRole()) ? "selected" : "" %>>Logistik</option>
                                                        <option value="Media" <%= "Media".equals(cm.getRole()) ? "selected" : "" %>>Media</option>
                                                        <option value="Konsumsi" <%= "Konsumsi".equals(cm.getRole()) ? "selected" : "" %>>Konsumsi</option>
                                                        <option value="Anggota" <%= "Anggota".equals(cm.getRole()) ? "selected" : "" %>>Anggota</option>
                                                    </select>
                                                </form>
                                            </td>
                                            <td class="text-end pe-4">
                                                <form action="event" method="post" onsubmit="return confirm('Hapus <%= cm.getMemberName() %> dari panitia?');">
                                                    <input type="hidden" name="action" value="removeCommittee">
                                                    <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                                                    <input type="hidden" name="memberID" value="<%= cm.getMemberID() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Hapus"><i class="bi bi-trash"></i></button>
                                                </form>
                                            </td>
                                        </tr>
                                        <% }} else { %>
                                        <tr><td colspan="3" class="text-center py-4 text-muted">Belum ada panitia. Tambahkan di menu utama.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div> </div>
                    </div>

                </div>
            </div>
        </div>
    </body>
</html>