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
        
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            // TAMPILKAN FORM EDIT
            String id = request.getParameter("id");
            ResearchAssistant ra = memberDAO.getMemberById(id);
            request.setAttribute("member", ra);
            request.getRequestDispatcher("edit-member.jsp").forward(request, response);
            
        } else if ("delete".equals(action)) {
            // HAPUS MEMBER (Opsional)
            String id = request.getParameter("id");
            memberDAO.deleteMember(id);
            response.sendRedirect("member");
            
        } else {
            // DEFAULT: TAMPILKAN LIST
            List<ResearchAssistant> list = memberDAO.getAllMembers();
            request.setAttribute("listRA", list);
            request.getRequestDispatcher("list-member.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. CEK HAK AKSES: Hanya 'HEAD_OF_LAB' yang boleh nambah data
        HttpSession session = request.getSession(false);
        LabMember currentUser = (LabMember) session.getAttribute("user");
        
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            // AMBIL DATA DARI FORM
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String division = request.getParameter("division");
            String dept = request.getParameter("department");
            String roleTitle = request.getParameter("role"); // Jabatan text
            String accessRole = request.getParameter("accessRole"); // System Role

            // Buat objek baru untuk update.
            // Username & Password kita isi string kosong karena updateMember DAO tidak mengubahnya.
            ResearchAssistant ra = new ResearchAssistant(
                id, name, division, dept, roleTitle, "", "", accessRole
            );

            memberDAO.updateMember(ra);
            response.sendRedirect("member"); // Kembali ke list
            
        } else if ("add".equals(action)) {
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
}
