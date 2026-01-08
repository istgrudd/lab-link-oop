<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String errorMsg = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LabLink</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="login-body">
    <div class="login-card">
        <div class="login-logo">
            <div class="logo-icon"><i class="fas fa-flask"></i></div>
            <h1>LabLink</h1>
            <p>Sistem Manajemen Laboratorium</p>
        </div>
        <% if (errorMsg != null) { %>
        <div class="login-error"><i class="fas fa-exclamation-circle"></i><span><%= errorMsg %></span></div>
        <% } %>
        <form action="login" method="post" class="login-form" id="loginForm">
            <div class="form-group">
                <label class="form-label">Member ID (NIM)</label>
                <input type="text" name="username" id="usernameInput" class="form-control" placeholder="Masukkan NIM/ID Anda" required>
                <div class="validation-msg" id="usernameError"></div>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <div class="password-wrapper">
                    <input type="password" name="password" id="passwordInput" class="form-control" placeholder="Masukkan password" required>
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <i class="fas fa-eye" id="toggleIcon"></i>
                    </button>
                </div>
                <div class="validation-msg" id="passwordError"></div>
            </div>
            <button type="submit" class="btn btn-primary btn-login"><i class="fas fa-sign-in-alt"></i> Masuk</button>
        </form>
        <div class="back-link"><a href="index.html"><i class="fas fa-arrow-left"></i> Kembali ke Beranda</a></div>
    </div>
    <script>
        function togglePassword() {
            const passInput = document.getElementById('passwordInput');
            const toggleIcon = document.getElementById('toggleIcon');
            if (passInput.type === 'password') {
                passInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }
        
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            let valid = true;
            const username = document.getElementById('usernameInput');
            const password = document.getElementById('passwordInput');
            const usernameError = document.getElementById('usernameError');
            const passwordError = document.getElementById('passwordError');
            
            usernameError.textContent = '';
            passwordError.textContent = '';
            username.classList.remove('input-error');
            password.classList.remove('input-error');
            
            if (username.value.trim() === '') {
                usernameError.textContent = 'Member ID tidak boleh kosong';
                username.classList.add('input-error');
                valid = false;
            }
            
            if (password.value.length < 1) {
                passwordError.textContent = 'Password tidak boleh kosong';
                password.classList.add('input-error');
                valid = false;
            }
            
            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
