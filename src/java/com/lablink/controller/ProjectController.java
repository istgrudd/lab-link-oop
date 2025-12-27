/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.ProjectDAO;
import com.lablink.dao.MemberDAO;
import com.lablink.model.Project;
import com.lablink.model.ResearchAssistant;
import com.lablink.model.LabMember;
import java.io.IOException;
import java.util.List;
import java.util.Arrays;
import java.util.UUID;
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
@WebServlet(name = "ProjectController", urlPatterns = {"/project"})
public class ProjectController extends HttpServlet {

    private ProjectDAO projectDAO;
    private MemberDAO memberDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        // [PENTING] Mencegah Error 500 (NullPointerException)
        if (action == null) {
            action = "list";
        }

        // 2. Handle Action
        switch (action) {
            case "add":
                // Kirim daftar member untuk dropdown Ketua
                request.setAttribute("listMember", memberDAO.getAllMembers());
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;

            case "edit":
                String id = request.getParameter("id");
                Project p = projectDAO.getProjectById(id);
                // Kirim data proyek & member untuk form edit
                request.setAttribute("project", p);
                request.setAttribute("listMember", memberDAO.getAllMembers());
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;

            case "delete":
                String deleteId = request.getParameter("id");
                projectDAO.deleteProject(deleteId);
                response.sendRedirect("project");
                break;

            default: // "list"
                // Ambil data untuk tabel
                request.setAttribute("listProject", projectDAO.getAllProjects());
                request.setAttribute("listMember", memberDAO.getAllMembers());
                request.getRequestDispatcher("list-project.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        LabMember user = (LabMember) session.getAttribute("user");
        
        // Cek Role (Hanya Internal & Ketua Lab yang boleh)
        if (user == null || "HEAD_OF_EXTERNAL".equals(user.getAccessRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak.");
            return;
        }

        String action = request.getParameter("action");
        
        // Handle Save (Tambah) & Update (Edit)
        if ("save".equals(action) || "update".equals(action)) {
            String id = request.getParameter("projectID");
            String name = request.getParameter("projectName");
            String description = request.getParameter("description");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            String division = request.getParameter("division");
            String leaderID = request.getParameter("leaderID");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            String[] teamMemberIDs = request.getParameterValues("teamMembers");
            
            // Generate ID jika baru
            if (id == null || id.isEmpty()) {
                id = UUID.randomUUID().toString().substring(0, 8);
            }

            // Buat objek Project
            Project p = new Project(id, name, description, status, category, division, leaderID, "", startDate, endDate);

            if ("update".equals(action)) {
                // [BARU] Kirim array teamMemberIDs ke DAO
                projectDAO.updateProject(p, teamMemberIDs);
            } else {
                // [BARU] Kirim array teamMemberIDs ke DAO
                projectDAO.addProject(p, teamMemberIDs);
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            projectDAO.deleteProject(id);
        }
        
        // Redirect kembali ke list
        response.sendRedirect("project");
    }
}