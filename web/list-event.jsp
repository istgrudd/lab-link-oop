<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.lablink.model.LabEvent"%>
<%@ page import="com.lablink.model.ResearchAssistant"%>
<%@ page import="com.lablink.model.LabMember"%>
<%
    LabMember user = (LabMember) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    String role = user.getAccessRole();
    boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kegiatan Eksternal - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="app-body">
    <div class="dashboard-container">
        <jsp:include page="sidebar.jsp" />
        <main class="main-content">
            <header class="top-bar">
                <div class="welcome-section">
                    <h1 class="page-title"><i class="fas fa-calendar-alt"></i> Kegiatan Eksternal</h1>
                    <p class="page-subtitle">Jadwal dan manajemen acara laboratorium</p>
                </div>
                <div class="top-bar-right">
                    <% if (canManage) { %>
                    <a href="event?action=add" class="btn btn-primary"><i class="fas fa-plus"></i> Tambah Kegiatan</a>
                    <% } %>
                </div>
            </header>
            <div class="content-card">
                <div class="card-body" style="padding: 0;">
                    <table class="data-table">
                        <thead><tr><th>Tanggal</th><th>Nama Kegiatan</th><th>PIC</th><th>Panitia</th><th>Aksi</th></tr></thead>
                        <tbody>
                            <% List<LabEvent> listE = (List<LabEvent>) request.getAttribute("listEvent");
                               if (listE != null && !listE.isEmpty()) { for (LabEvent e : listE) { %>
                            <tr>
                                <td><span class="badge badge-success"><i class="far fa-calendar"></i> <%= e.getEventDate() %></span></td>
                                <td style="font-weight: 600; color: var(--secondary);"><%= e.getEventName() %></td>
                                <td><%= (e.getPicName() != null) ? e.getPicName() : "-" %></td>
                                <td><div style="display: flex; flex-wrap: wrap; gap: 4px;"><% for(String com : e.getCommitteeNames()) { %><span class="badge badge-info" style="font-size: 0.7rem;"><%= com %></span><% } %></div></td>
                                <td>
                                    <div style="display: flex; gap: 8px;">
                                        <button onclick="showEventDetail(this)" class="btn btn-outline btn-sm btn-icon" data-title="<%= e.getEventName() %>" data-date="<%= e.getEventDate() %>" data-pic="<%= e.getPicName() != null ? e.getPicName() : "-" %>" data-desc="<%= (e.getDescription() != null && !e.getDescription().isEmpty()) ? e.getDescription() : "Tidak ada deskripsi." %>" data-committee="<%= String.join(", ", e.getCommitteeNames()) %>" title="Detail"><i class="fas fa-eye"></i></button>
                                        <% if (canManage) { %>
                                        <a href="event?action=edit&id=<%= e.getEventID() %>" class="btn btn-outline btn-sm btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <a href="event?action=deleteEvent&id=<%= e.getEventID() %>" onclick="return confirm('Yakin ingin menghapus kegiatan <%= e.getEventName() %>?');" class="btn btn-sm btn-icon" style="background: var(--danger-light); color: var(--danger);" title="Hapus"><i class="fas fa-trash"></i></a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="5" class="empty-state"><i class="fas fa-calendar-times"></i><p>Belum ada agenda kegiatan</p></td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    <div id="eventModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header"><h3><i class="fas fa-calendar-alt"></i> Detail Kegiatan</h3><button class="close-btn" onclick="closeEventModal()">&times;</button></div>
            <div class="modal-body">
                <div class="detail-row"><span class="detail-label">Nama Kegiatan</span><span class="detail-value" id="evTitle"></span></div>
                <div class="detail-row"><span class="detail-label">Deskripsi</span><span class="detail-value" id="evDesc"></span></div>
                <div class="detail-row"><span class="detail-label">Tanggal Pelaksanaan</span><span class="detail-value" id="evDate"></span></div>
                <div class="detail-row"><span class="detail-label">PIC (Penanggung Jawab)</span><span class="detail-value" id="evPic"></span></div>
                <div class="detail-row"><span class="detail-label">Panitia Bertugas</span><span class="detail-value" id="evCom"></span></div>
            </div>
        </div>
    </div>
    <script>
        function showEventDetail(btn) {
            document.getElementById('evTitle').innerText = btn.getAttribute('data-title');
            document.getElementById('evDesc').innerText = btn.getAttribute('data-desc');
            document.getElementById('evDate').innerText = btn.getAttribute('data-date');
            document.getElementById('evPic').innerText = btn.getAttribute('data-pic');
            document.getElementById('evCom').innerText = btn.getAttribute('data-committee') || '-';
            document.getElementById('eventModal').style.display = 'flex';
        }
        function closeEventModal() { document.getElementById('eventModal').style.display = 'none'; }
        window.onclick = function(event) { if (event.target == document.getElementById('eventModal')) { closeEventModal(); } }
    </script>
</body>
</html>
