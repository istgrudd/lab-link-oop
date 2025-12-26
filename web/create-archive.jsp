<%-- 
    Document   : create-archive
    Created on : 26 Dec 2025, 22.01.12
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.lablink.model.Project"%>
<%
    Project p = (Project) request.getAttribute("sourceProject");
    if (p == null) { response.sendRedirect("project"); return; }
    
    // Tentukan Tipe Otomatis berdasarkan tipe proyek
    String archiveType = "Riset".equals(p.getActivityType()) ? "Publikasi" : "HKI";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Buat Arsip - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            Formulir Arsip Output (Project Completion)
                        </div>
                        <div class="card-body">
                            <form action="archive" method="post">
                                <input type="hidden" name="action" value="saveArchive">
                                <input type="hidden" name="projectID" value="<%= p.getProjectID() %>">
                                
                                <div class="alert alert-info">
                                    <strong>Sumber Proyek:</strong> <%= p.getProjectName() %> (<%= p.getProjectID() %>)
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">ID Arsip</label>
                                    <input type="text" name="id" class="form-control" placeholder="ARC-..." required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Judul Publikasi / HKI</label>
                                    <input type="text" name="title" class="form-control" value="<%= p.getProjectName() %>" required>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tipe Output</label>
                                        <input type="text" name="type" class="form-control" value="<%= archiveType %>" readonly>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tanggal Terbit/Grant</label>
                                        <input type="date" name="date" class="form-control" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nama Jurnal / Badan HKI</label>
                                        <input type="text" name="location" class="form-control" placeholder="Contoh: IEEE Access / DJKI" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">No. Referensi (DOI / No. Reg)</label>
                                        <input type="text" name="refNum" class="form-control" placeholder="Contoh: 10.1109/... atau IDM000..." required>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-between mt-3">
                                    <a href="project" class="btn btn-secondary">Batal</a>
                                    <button type="submit" class="btn btn-primary">Simpan ke Arsip</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
