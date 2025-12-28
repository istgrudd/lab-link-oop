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
    List<CommitteeMember> listCom = (List<CommitteeMember>) request.getAttribute("listCommittee");
    if (e == null) { response.sendRedirect("event"); return; }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Edit Kegiatan - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <h1>Edit Kegiatan: <%= e.getEventName() %></h1>
                </header>

                <div class="content-split">
                    <div class="agenda-section">
                        <h2>Data Utama</h2>
                        <form action="event" method="post">
                            <input type="hidden" name="action" value="updateEvent">
                            <input type="hidden" name="id" value="<%= e.getEventID() %>">
                            
                            <div style="margin-bottom: 15px;">
                                <label>Nama Kegiatan</label>
                                <input type="text" name="name" value="<%= e.getEventName() %>" style="width:100%; padding:10px;" required>
                            </div>
                            
                            <div style="margin-bottom: 15px;">
                                <label>Tanggal</label>
                                <input type="date" name="date" value="<%= e.getEventDate() %>" style="width:100%; padding:10px;" required>
                            </div>
                            
                            <div style="margin-bottom: 15px;">
                                <label>PIC (Penanggung Jawab)</label>
                                <select name="picID" style="width:100%; padding:10px;" required>
                                    <% for(ResearchAssistant ra : listMember) { %>
                                        <option value="<%= ra.getMemberID() %>" <%= ra.getMemberID().equals(e.getPicID()) ? "selected" : "" %>><%= ra.getName() %></option>
                                    <% } %>
                                </select>
                            </div>

                            <div style="margin-bottom: 15px;">
                                <label>Deskripsi Kegiatan</label>
                                <textarea name="description" style="width:100%; padding:10px; height:120px; font-family: inherit; resize: vertical;" placeholder="Tuliskan detail, tujuan, atau catatan kegiatan..."><%= (e.getDescription() != null) ? e.getDescription() : "" %></textarea>
                            </div>

                            <button type="submit" class="btn-small" style="background:var(--primary-color); color:white; border:none; padding:10px 15px;">Simpan Perubahan</button>
                            
                            <a href="event?action=deleteEvent&id=<%= e.getEventID() %>" onclick="return confirm('Hapus kegiatan ini?')" style="color:red; float:right; font-size:0.9rem; margin-top:10px;">Hapus Permanen</a>
                        </form>
                    </div>

                    <div class="tasks-section">
                        <h2>Panitia & Tim</h2>
                        
                        <form action="event" method="post" style="background:#f9f9f9; padding:15px; border-radius:8px; margin-bottom:15px;">
                            <input type="hidden" name="action" value="addCommittee">
                            <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                            <div style="display:flex; gap:5px; margin-bottom:5px;">
                                <select name="memberID" style="flex:1; padding:5px;" required>
                                    <option value="" disabled selected>Pilih Anggota</option>
                                    <% if(listMember != null) { for(ResearchAssistant ra : listMember) { %>
                                        <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                    <% }} %>
                                </select>
                            </div>
                            <div style="display:flex; gap:5px;">
                                <select name="role" style="flex:1; padding:5px;" required>
                                    <option value="Anggota">Anggota</option>
                                    <option value="Acara">Acara</option>
                                    <option value="Humas">Humas</option>
                                    <option value="Logistik">Logistik</option>
                                    <option value="Media">Media</option>
                                    <option value="Konsumsi">Konsumsi</option>
                                </select>
                                <button type="submit" style="background:var(--secondary-color); color:white; border:none; padding:5px 10px; border-radius:4px;">+</button>
                            </div>
                        </form>

                        <ul style="list-style:none; padding:0;">
                            <% if (listCom != null && !listCom.isEmpty()) { 
                                for (CommitteeMember cm : listCom) { %>
                                <li style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #eee; padding:8px 0;">
                                    <div>
                                        <strong><%= cm.getMemberName() %></strong><br>
                                        <small class="text-muted"><%= cm.getRole() %></small>
                                    </div>
                                    <form action="event" method="post" style="margin:0;">
                                        <input type="hidden" name="action" value="removeCommittee">
                                        <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                                        <input type="hidden" name="memberID" value="<%= cm.getMemberID() %>">
                                        <button type="submit" style="background:none; border:none; color:red; cursor:pointer;"><i class="fas fa-trash"></i></button>
                                    </form>
                                </li>
                            <% }} else { %>
                                <li class="text-muted small">Belum ada panitia.</li>
                            <% } %>
                        </ul>
                    </div>
                </div>

            </main>
        </div>
    </body>
</html>