/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;
import com.lablink.dao.MemberDAO;
import com.lablink.model.ResearchAssistant;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lablink.model.LabMember;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Rudi Firdaus
 */

@WebServlet(name = "MemberController", urlPatterns = {"/member"})
public class MemberController extends HttpServlet {
    // Referensi ke DAO buatan Rudi
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. CEK SESSION: Apakah sudah login?
        HttpSession session = request.getSession(false); // false = jangan buat session baru jika tidak ada
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login"); // Tendang ke login
            return;
        }

        // 2. Ambil data (Logika lama)
        List<ResearchAssistant> listMember = memberDAO.getAllMembers();
        request.setAttribute("listRA", listMember);
        request.getRequestDispatcher("list-member.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. CEK HAK AKSES: Hanya 'HEAD_OF_LAB' yang boleh nambah data
        HttpSession session = request.getSession(false);
        LabMember currentUser = (LabMember) session.getAttribute("user");
        
        if (currentUser == null || !currentUser.getAccessRole().equals("HEAD_OF_LAB")) {
            // Jika bukan ketua, tolak akses
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki akses untuk menambah data.");
            return;
        }

        // 2. Logika Simpan Data (Logika lama, sesuaikan constructor)
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String division = request.getParameter("division");
        String department = request.getParameter("department");
        String role = request.getParameter("role");

        // Constructor baru (param login diisi default/null dulu di controller)
        ResearchAssistant newRA = new ResearchAssistant(id, name, division, department, role, id, id, "RESEARCH_ASSISTANT");

        memberDAO.addMember(newRA);
        response.sendRedirect("member"); 
    }
}
