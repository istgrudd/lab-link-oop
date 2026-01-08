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
        // Fitur Cek Login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Fitur Tampilkan Halaman Profil
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        LabMember currentUser = (LabMember) session.getAttribute("user");
        
        // Get the 'action' parameter to differentiate which form was submitted
        String action = request.getParameter("action");

        if ("updateInfo".equals(action)) {
            handleUpdateInfo(request, session, currentUser);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(request, currentUser);
        }
        
        // Return to the profile page
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    private void handleUpdateInfo(HttpServletRequest request, HttpSession session, LabMember currentUser) {
        String name = request.getParameter("name");
        String division = request.getParameter("division");
        String department = request.getParameter("department");
        
        String roleToSave = "";
        
        // Get the old position as a default
        if (currentUser instanceof ResearchAssistant) {
            roleToSave = ((ResearchAssistant) currentUser).getRoleTitle();
        }
        
        // If the user is an ADMIN, we allow overwriting the old position with new input
        if ("HEAD_OF_LAB".equals(currentUser.getAccessRole())) {
            String inputRole = request.getParameter("role"); // Get from form name="role"
            if (inputRole != null && !inputRole.trim().isEmpty()) {
                roleToSave = inputRole;
            }
        }

        ResearchAssistant updatedRA = new ResearchAssistant(
            currentUser.getMemberID(), 
            name, 
            division, 
            department, 
            roleToSave, // Use the variable that has passed the logic above
            currentUser.getMemberID(), 
            "", 
            currentUser.getAccessRole()
        );

        // Update to Database (Requires updating the method in the DAO as well!)
        if (memberDAO.updateProfile(updatedRA)) {
            session.setAttribute("user", updatedRA);
            request.setAttribute("msgInfo", "Profil berhasil diperbarui!");
            request.setAttribute("msgType", "success");
        } else {
            request.setAttribute("msgInfo", "Gagal memperbarui profil.");
            request.setAttribute("msgType", "danger");
        }
    }

    // Feature: Change Password
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
