<%-- 
    Document   : login
    Created on : 25 Dec 2025, 21.41.07
    Author     : Rudi Firdaus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - LabLink</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">
        <div class="card shadow p-4" style="width: 400px;">
            <h3 class="text-center mb-4">Login LabLink</h3>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Masuk</button>
                </div>
            </form>
            <div class="mt-3 text-center">
                <small>Belum punya akun? Hubungi Admin Lab.</small>
            </div>
        </div>
    </body>
</html>