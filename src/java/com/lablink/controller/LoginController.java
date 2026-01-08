package com.lablink.controller;

import com.lablink.dao.MemberDAO;
import com.lablink.model.LabMember;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout"})
public class LoginController extends HttpServlet {
    private final MemberDAO memberDAO;

    // Default constructor
    public LoginController() {
        this(new MemberDAO());
    }

    // Constructor for testing
    LoginController(MemberDAO memberDAO) {
        this.memberDAO = memberDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/logout")) {
            // Fitur Logout
            HttpSession session = request.getSession(false); // Don't create a new session if one doesn't exist
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        } else {
            // Fitur Tampilkan Halaman Login
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        LabMember member = memberDAO.login(u, p);

        if (member != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", member);
            
            response.sendRedirect("dashboard"); 
        } else {
            // Fitur Login Gagal
            request.setAttribute("error", "Username atau Password salah!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
