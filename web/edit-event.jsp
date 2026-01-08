<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.lablink.model.LabEvent"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.CommitteeMember"%>
<%@ page import="java.util.List"%>
<%
    LabEvent e = (LabEvent) request.getAttribute("event");
    List<ResearchAssistant> listMember = (List<ResearchAssistant>) request.getAttribute("listMember");
    List<CommitteeMember> listCom = (List<CommitteeMember>) request.getAttribute("listCommittee");
    boolean isEdit = (e != null);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Kegiatan" : "Tambah Kegiatan" %> - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-<%= isEdit ? "calendar-edit" : "calendar-plus" %>"></i> <%= isEdit ? "Edit Kegiatan" : "Kegiatan Baru" %></h1>
                    <p class="page-subtitle"><%= isEdit ? e.getEventName() : "Tambahkan kegiatan eksternal baru" %></p>
                </div>
                <div class="top-bar-right"><a href="event" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Kembali</a></div>
            </header>
            <div class="content-grid">
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-edit"></i> Data Utama</h2></div>
                    <div class="card-body">
                        <form action="event" method="post">
                            <input type="hidden" name="action" value="<%= isEdit ? "updateEvent" : "addEvent" %>">
                            <% if (isEdit) { %>
                            <input type="hidden" name="id" value="<%= e.getEventID() %>">
                            <% } %>
                            <div class="form-group">
                                <label class="form-label">Nama Kegiatan <span style="color: var(--danger);">*</span></label>
                                <input type="text" name="name" value="<%= isEdit ? e.getEventName() : "" %>" class="form-control" placeholder="Nama kegiatan" required>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group">
                                    <label class="form-label">Tanggal Pelaksanaan <span style="color: var(--danger);">*</span></label>
                                    <input type="date" name="date" value="<%= isEdit ? e.getEventDate() : "" %>" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">PIC (Penanggung Jawab) <span style="color: var(--danger);">*</span></label>
                                    <select name="picID" class="form-control" required>
                                        <option value="" disabled <%= !isEdit ? "selected" : "" %>>-- Pilih PIC --</option>
                                        <% if (listMember != null) { for(ResearchAssistant ra : listMember) { %>
                                        <option value="<%= ra.getMemberID() %>" <%= isEdit && ra.getMemberID().equals(e.getPicID()) ? "selected" : "" %>><%= ra.getName() %></option>
                                        <% }} %>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Deskripsi Kegiatan</label>
                                <textarea name="description" class="form-control" rows="4" placeholder="Tuliskan detail, tujuan, atau catatan kegiatan..."><%= isEdit && e.getDescription() != null ? e.getDescription() : "" %></textarea>
                            </div>
                            <div style="display: flex; gap: 12px; justify-content: <%= isEdit ? "space-between" : "flex-end" %>; align-items: center;">
                                <% if (isEdit) { %>
                                <a href="event?action=deleteEvent&id=<%= e.getEventID() %>" onclick="return confirm('Hapus kegiatan ini?')" class="btn btn-sm" style="background: var(--danger-light); color: var(--danger);"><i class="fas fa-trash"></i> Hapus Permanen</a>
                                <% } %>
                                <div style="display: flex; gap: 12px;">
                                    <a href="event" class="btn btn-outline">Batal</a>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> <%= isEdit ? "Simpan Perubahan" : "Simpan Kegiatan" %></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="content-card">
                    <div class="card-header"><h2><i class="fas fa-users"></i> Panitia & Tim</h2></div>
                    <div class="card-body">
                        <% if (isEdit) { %>
                        <form action="event" method="post" style="background: #f8fafc; padding: 16px; border-radius: 12px; margin-bottom: 20px;">
                            <input type="hidden" name="action" value="addCommittee">
                            <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                            <div class="form-group" style="margin-bottom: 12px;">
                                <select name="memberID" class="form-control" required>
                                    <option value="" disabled selected>Pilih Anggota</option>
                                    <% if(listMember != null) { for(ResearchAssistant ra : listMember) { %>
                                    <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                    <% }} %>
                                </select>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <select name="roles" class="form-control" required>
                                    <option value="Anggota">Anggota</option>
                                    <option value="Acara">Acara</option>
                                    <option value="Humas">Humas</option>
                                    <option value="Logistik">Logistik</option>
                                    <option value="Media">Media</option>
                                    <option value="Konsumsi">Konsumsi</option>
                                </select>
                                <button type="submit" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i></button>
                            </div>
                        </form>
                        <div style="display: flex; flex-direction: column; gap: 8px;">
                            <% if (listCom != null && !listCom.isEmpty()) { for (CommitteeMember cm : listCom) { %>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; background: white; border: 1px solid var(--border-color); border-radius: 10px;">
                                <div>
                                    <div style="font-weight: 600; color: var(--secondary);"><%= cm.getMemberName() %></div>
                                    <span class="badge badge-info" style="margin-top: 4px;"><%= cm.getRole() %></span>
                                </div>
                                <form action="event" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="removeCommittee">
                                    <input type="hidden" name="eventID" value="<%= e.getEventID() %>">
                                    <input type="hidden" name="memberID" value="<%= cm.getMemberID() %>">
                                    <button type="submit" class="btn btn-sm btn-icon" style="background: var(--danger-light); color: var(--danger);"><i class="fas fa-times"></i></button>
                                </form>
                            </div>
                            <% }} else { %>
                            <div class="empty-state" style="padding: 30px;"><i class="fas fa-user-friends"></i><p>Belum ada panitia</p></div>
                            <% } %>
                        </div>
                        <% } else { %>
                        <div class="empty-state" style="padding: 40px;">
                            <i class="fas fa-user-friends"></i>
                            <p>Panitia dapat ditambahkan setelah kegiatan disimpan</p>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">Simpan kegiatan terlebih dahulu, kemudian edit untuk menambahkan panitia.</p>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
