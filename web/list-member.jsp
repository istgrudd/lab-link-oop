<%-- 
    Document   : list-member
    Created on : 25 Nov 2025, 03.04.08
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.lablink.model.ResearchAssistant"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Manajemen Anggota - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        
        <div class="container mt-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2>Daftar Research Assistant</h2>
                <a href="index.html" class="btn btn-secondary">Kembali ke Home</a>
            </div>

            <div class="card mb-4">
                <div class="card-header bg-primary text-white">Tambah Anggota Baru</div>
                <div class="card-body">
                    <form action="member" method="post">
                        <div class="row">
                            <div class="col-md-2 mb-3">
                                <label>Member ID</label>
                                <input type="text" name="id" class="form-control" placeholder="1030..." required>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>Nama Lengkap</label>
                                <input type="text" name="name" class="form-control" placeholder="Nama..." required>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Divisi Keahlian</label>
                                <select name="division" class="form-select">
                                    <option value="Big Data">Big Data</option>
                                    <option value="Cyber Security">Cyber Security</option>
                                    <option value="GIS">GIS</option>
                                    <option value="Game Tech">Game Tech</option>
                                </select>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Departemen</label>
                                <select name="department" class="form-select">
                                    <option value="Internal">Internal</option>
                                    <option value="Eksternal">Eksternal</option>
                                </select>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label>Jabatan</label>
                                <input type="text" name="role" class="form-control" placeholder="Ex: Head/Staff">
                            </div>
                            <div class="col-md-1 mb-3 d-grid">
                                <label>&nbsp;</label>
                                <button type="submit" class="btn btn-success">Simpan</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Nama</th>
                                <th>Divisi</th>
                                <th>Dept.</th>
                                <th>Jabatan</th>
                                <th>Workload (Jam)</th> </tr>
                        </thead>
                        <tbody>
                            <% 
                                // MENGAMBIL DATA DARI CONTROLLER (SHAFWAN)
                                // Data "listRA" dikirim oleh MemberController.java lewat request.setAttribute()
                                List<ResearchAssistant> list = (List<ResearchAssistant>) request.getAttribute("listRA");

                                if (list != null && !list.isEmpty()) {
                                    for (ResearchAssistant ra : list) {
                            %>
                            <tr>
                                <td><%= ra.getMemberID() %></td>
                                <td><%= ra.getName() %></td>
                                <td><%= ra.getExpertDivision() %></td>
                                <td><%= ra.getDepartment() %></td>
                                <td>
                                    <span class="badge bg-info text-dark"><%= ra.getRoleTitle() %></span>
                                </td>
                                <td><%= ra.calculateWorkload() %> Jam</td>
                            </tr>
                            <% 
                                    }
                                } else { 
                            %>
                            <tr>
                                <td colspan="6" class="text-center">Belum ada data anggota.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </div>
    </body>
</html>