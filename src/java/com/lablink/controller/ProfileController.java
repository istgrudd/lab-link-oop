/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.MemberDAO;
import com.lablink.model.ResearchAssistant;
import com.lablink.model.LabMember;
import java.io.IOException;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Rudi Firdaus
 */

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cek Login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Tampilkan halaman profil
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        LabMember currentUser = (LabMember) session.getAttribute("user");
        
        // Ambil parameter 'action' untuk membedakan form mana yang disubmit
        String action = request.getParameter("action");

        if ("updateInfo".equals(action)) {
            handleUpdateInfo(request, session, currentUser);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, currentUser);
        }
        
        // Kembali ke halaman profil
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void handleUpdateInfo(HttpServletRequest request, HttpSession session, LabMember currentUser) {
        String name = request.getParameter("name");
        String division = request.getParameter("division");
        String department = request.getParameter("department");
        
        // --- LOGIKA BARU MULAI SINI ---
        
        String roleToSave = "";
        
        // 1. Ambil jabatan lama sebagai default
        if (currentUser instanceof ResearchAssistant) {
            roleToSave = ((ResearchAssistant) currentUser).getRoleTitle();
        }
        
        // 2. Jika user adalah ADMIN, kita izinkan menimpa jabatan lama dengan input baru
        if ("HEAD_OF_LAB".equals(currentUser.getAccessRole())) {
            String inputRole = request.getParameter("role"); // Ambil dari form name="role"
            if (inputRole != null && !inputRole.trim().isEmpty()) {
                roleToSave = inputRole;
            }
        }
        
        // --- LOGIKA BARU SELESAI ---

        ResearchAssistant updatedRA = new ResearchAssistant(
            currentUser.getMemberID(), 
            name, 
            division, 
            department, 
            roleToSave, // Gunakan variabel yang sudah melewati logika di atas
            currentUser.getMemberID(), 
            "", 
            currentUser.getAccessRole()
        );

        // Bagian Update ke Database (Perlu update method di DAO juga!)
        if (memberDAO.updateProfile(updatedRA)) {
            session.setAttribute("user", updatedRA);
            request.setAttribute("msgInfo", "Profil berhasil diperbarui!");
            request.setAttribute("msgType", "success");
        } else {
            request.setAttribute("msgInfo", "Gagal memperbarui profil.");
            request.setAttribute("msgType", "danger");
        }
    }

    private void handleChangePassword(HttpServletRequest request, LabMember currentUser) {
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");

        if (newPass != null && newPass.equals(confirmPass)) {
            if (memberDAO.updatePassword(currentUser.getMemberID(), newPass)) {
                request.setAttribute("msgPass", "Password berhasil diubah!");
                request.setAttribute("msgTypePass", "success");
            } else {
                request.setAttribute("msgPass", "Gagal mengubah password.");
                request.setAttribute("msgTypePass", "danger");
            }
        } else {
            request.setAttribute("msgPass", "Konfirmasi password tidak cocok!");
            request.setAttribute("msgTypePass", "danger");
        }
    }
}
