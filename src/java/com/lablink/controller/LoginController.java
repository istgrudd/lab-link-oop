/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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

/**
 *
 * @author Rudi Firdaus
 */

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/logout"})
public class LoginController extends HttpServlet {
    private final MemberDAO memberDAO;

    // Default constructor untuk penggunaan normal oleh Tomcat
    public LoginController() {
        this(new MemberDAO());
    }

    // Constructor untuk testing, memungkinkan injeksi DAO palsu (mock)
    LoginController(MemberDAO memberDAO) {
        this.memberDAO = memberDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        if (path.equals("/logout")) {
            // Hapus session saat logout
            HttpSession session = request.getSession(false); // Jangan buat session baru jika tidak ada
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        } else {
            // Tampilkan halaman login
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
            
            // UBAH DARI "member" MENJADI "dashboard"
            response.sendRedirect("dashboard"); 
        } else {
            // LOGIN GAGAL
            request.setAttribute("error", "Username atau Password salah!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
