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
    
    String role = user.getAccessRole();
    // Hak akses: Hanya Kepala Lab dan Ketua Eksternal yang bisa CRUD
    boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);
    List<ResearchAssistant> listM = (List<ResearchAssistant>) request.getAttribute("listMember");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Kegiatan Eksternal - LabLink</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            /* Style Tambahan Khusus Modal (Agar sama dengan Project) */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0; left: 0; width: 100%; height: 100%;
                background: rgba(0,0,0,0.5);
                justify-content: center; align-items: center;
                z-index: 2000;
            }
            .modal-card {
                background: white;
                width: 90%; max-width: 500px;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                animation: slideDown 0.3s ease;
            }
            .modal-header {
                background: var(--primary-color);
                color: white;
                padding: 15px 20px;
                display: flex; justify-content: space-between; align-items: center;
            }
            .modal-body { padding: 20px; }
            .detail-row {
                display: flex; flex-direction: column;
                margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px;
            }
            .detail-label { font-size: 0.85rem; color: #777; margin-bottom: 3px; }
            .detail-value { font-weight: 600; color: #333; }
            .close-btn { background: none; border: none; color: white; font-size: 1.5rem; cursor: pointer; }
            @keyframes slideDown { from {transform: translateY(-20px); opacity: 0;} to {transform: translateY(0); opacity: 1;} }
        </style>
    </head>
    <body>
        
        <div class="dashboard-container">
            <jsp:include page="sidebar.jsp" />

            <main class="main-content">
                <header class="top-bar">
                    <div class="welcome-text">
                        <h1>Kegiatan Eksternal</h1>
                        <p class="text-muted small">Jadwal dan manajemen acara lab</p>
                    </div>
                    <div class="date-display">
                        <i class="fas fa-calendar-alt me-2"></i> Event Organizer
                    </div>
                </header>

                <% if (canManage) { %>
                <div style="margin-bottom: 20px; text-align: right;">
                    <button onclick="document.getElementById('addEventForm').style.display='block'" class="btn-small" style="background: var(--primary-color); color: white; padding: 10px 20px; border-radius: 5px; border:none; cursor:pointer;">
                        <i class="fas fa-plus"></i> Tambah Kegiatan
                    </button>
                </div>
                
                <div id="addEventForm" class="tasks-section" style="display:none; margin-bottom: 20px;">
                     <h3 style="margin-bottom:15px;">Form Kegiatan Baru</h3>
                     <form action="event" method="post">
                        <input type="hidden" name="action" value="addEvent">
                        <div class="row" style="display:flex; gap:15px; margin-bottom:15px;">
                            <input type="text" name="id" class="form-control" placeholder="Kode (EVT-...)" style="flex:1; padding:10px;" required>
                            <input type="text" name="name" class="form-control" placeholder="Nama Kegiatan" style="flex:2; padding:10px;" required>
                        </div>
                        <div class="row" style="display:flex; gap:15px; margin-bottom:15px;">
                             <input type="date" name="date" class="form-control" style="flex:1; padding:10px;" required>
                             <select name="picID" class="form-control" style="flex:1; padding:10px;" required>
                                <option value="" disabled selected>-- Pilih PIC --</option>
                                <% if(listM != null) { for(ResearchAssistant ra : listM) { %>
                                    <option value="<%= ra.getMemberID() %>"><%= ra.getName() %></option>
                                <% }} %>
                             </select>
                        </div>
                        <div class="row" style="margin-bottom:15px;">
                            <textarea name="description" class="form-control" rows="3" placeholder="Deskripsi singkat kegiatan..." style="width:100%; padding:10px;"></textarea>
                        </div>

                        <button type="submit" class="btn-small" style="background:var(--secondary-color); color:white; border:none; padding:8px 15px;">Simpan</button>
                        <button type="button" onclick="document.getElementById('addEventForm').style.display='none'" class="btn-small" style="background:#ccc; color:#333; border:none; padding:8px 15px;">Batal</button>
                     </form>
                </div>
                <% } %>

                <div class="tasks-section" style="width: 100%;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: #e0f2f1; text-align: left; color: var(--secondary-color);">
                                <th style="padding: 15px; border-radius: 8px 0 0 8px;">Tanggal</th>
                                <th style="padding: 15px;">Nama Kegiatan</th>
                                <th style="padding: 15px;">PIC</th>
                                <th style="padding: 15px;">Panitia</th>
                                <th style="padding: 15px; border-radius: 0 8px 8px 0;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<LabEvent> listE = (List<LabEvent>) request.getAttribute("listEvent");
                                if (listE != null && !listE.isEmpty()) {
                                    for (LabEvent e : listE) {
                            %>
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 15px;"><span class="badge badge-success"><%= e.getEventDate() %></span></td>
                                <td style="padding: 15px; font-weight:600;"><%= e.getEventName() %></td>
                                <td style="padding: 15px;"><%= (e.getPicName() != null) ? e.getPicName() : "-" %></td>
                                <td style="padding: 15px;">
                                    <% for(String com : e.getCommitteeNames()) { %>
                                        <span class="badge" style="background:#e3f2fd; color:#1565c0; margin-right:2px; font-size:0.75rem;"><%= com %></span>
                                    <% } %>
                                </td>
                                <td style="padding: 15px;">
                                    <button onclick="showEventDetail(this)" 
                                            class="btn-icon"
                                            data-title="<%= e.getEventName() %>"
                                            data-date="<%= e.getEventDate() %>"
                                            data-pic="<%= e.getPicName() != null ? e.getPicName() : "-" %>"
                                            data-desc="<%= (e.getDescription() != null && !e.getDescription().isEmpty()) ? e.getDescription() : "Tidak ada deskripsi." %>"
                                            data-committee="<%= String.join(", ", e.getCommitteeNames()) %>"
                                            style="background:none; border:none; cursor:pointer; color: var(--primary-color); margin-right: 10px;" 
                                            title="Lihat Detail">
                                        <i class="fas fa-eye"></i>
                                    </button>

                                    <% if (canManage) { %>
                                    <a href="event?action=edit&id=<%= e.getEventID() %>" style="color: var(--accent-color); margin-right: 10px;" title="Edit">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    
                                    <a href="event?action=deleteEvent&id=<%= e.getEventID() %>" 
                                       onclick="return confirm('Yakin ingin menghapus kegiatan <%= e.getEventName() %>? Data akan hilang permanen.');" 
                                       style="color: #ef5350;" 
                                       title="Hapus">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% }} else { %>
                            <tr><td colspan="5" class="empty-state">Belum ada agenda kegiatan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

            </main>
        </div>
        
        <div id="eventModal" class="modal-overlay">
            <div class="modal-card">
                <div class="modal-header">
                    <h3>Detail Kegiatan</h3>
                    <button class="close-btn" onclick="closeEventModal()">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="detail-row">
                        <span class="detail-label">Nama Kegiatan</span>
                        <span class="detail-value" id="evTitle"></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Deskripsi</span>
                        <span class="detail-value" id="evDesc" style="white-space: pre-wrap;"></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Tanggal Pelaksanaan</span>
                        <span class="detail-value" id="evDate"></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">PIC (Penanggung Jawab)</span>
                        <span class="detail-value" id="evPic" style="color: var(--primary-color);"></span>
                    </div>
                    <div class="detail-row" style="border:none;">
                        <span class="detail-label">Panitia Bertugas</span>
                        <span class="detail-value" id="evCom"></span>
                    </div>
                </div>
            </div>
        </div>

        <nav class="bottom-nav">
            <a href="dashboard" class="bottom-nav-item">
                <i class="fas fa-home"></i> <span>Home</span>
            </a>
            <a href="project" class="bottom-nav-item">
                <i class="fas fa-project-diagram"></i> <span>Proyek</span>
            </a>
            <a href="event" class="bottom-nav-item active">
                <i class="fas fa-calendar-alt"></i> <span>Event</span>
            </a>
            <a href="#" class="bottom-nav-item" onclick="alert('Fitur Administrasi akan segera hadir!')">
                <i class="fas fa-file-alt"></i> <span>Admin</span>
            </a>
            <a href="profile.jsp" class="bottom-nav-item">
                <i class="fas fa-user"></i> <span>Akun</span>
            </a>
        </nav>
        
        <script>
            function showEventDetail(btn) {
                // Ambil data dari atribut tombol
                document.getElementById('evTitle').innerText = btn.getAttribute('data-title');
                document.getElementById('evDesc').innerText = btn.getAttribute('data-desc');
                document.getElementById('evDate').innerText = btn.getAttribute('data-date');
                document.getElementById('evPic').innerText = btn.getAttribute('data-pic');
                
                // Cek jika panitia kosong
                let com = btn.getAttribute('data-committee');
                if(!com || com === "") com = "-";
                document.getElementById('evCom').innerText = com;

                // Tampilkan Modal
                document.getElementById('eventModal').style.display = 'flex';
            }

            function closeEventModal() {
                document.getElementById('eventModal').style.display = 'none';
            }

            // Tutup jika klik di luar kartu
            window.onclick = function(event) {
                if (event.target == document.getElementById('eventModal')) {
                    closeEventModal();
                }
            }
        </script>

    </body>
</html>