/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.ProjectDAO;
import com.lablink.model.LabMember; // Pastikan import Model User ada
import com.lablink.model.Project;
import java.io.IOException;
import java.util.List;
import java.util.UUID; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // [PERBAIKAN UTAMA: Import ini sebelumnya hilang]

/**
 *
 * @author Rudi Firdaus
 */
@WebServlet(name = "ProjectController", urlPatterns = {"/project"})
public class ProjectController extends HttpServlet {

    private ProjectDAO projectDAO;

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
    }

    // Method Helper: Cek Hak Akses (RBAC)
    private boolean isAuthorized(LabMember user) {
        if (user == null) return false;
        String role = user.getAccessRole();
        
        // ATURAN: Ketua Eksternal DILARANG kelola proyek (Hanya View)
        if ("Ketua Eksternal".equalsIgnoreCase(role)) {
            return false;
        }
        
        // Role lain (Ketua Lab, Ketua Internal, Asisten Riset) BOLEH
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Session Login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        LabMember user = (LabMember) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        // 2. Cek RBAC untuk aksi Modifikasi (Add/Edit/Delete)
        if (("add".equals(action) || "edit".equals(action) || "delete".equals(action))) {
            if (!isAuthorized(user)) {
                // Jika akses ditolak, kembalikan ke list dengan pesan error
                request.setAttribute("errorMessage", "Akses Ditolak! Role Anda (" + user.getAccessRole() + ") tidak memiliki izin mengelola Proyek.");
                
                // Tetap tampilkan list agar user tidak bingung
                List<Project> list = projectDAO.getAllProjects();
                request.setAttribute("projectList", list);
                request.getRequestDispatcher("list-project.jsp").forward(request, response);
                return;
            }
        }

        // 3. Logika Switch Case
        switch (action) {
            case "add":
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;
                
            case "edit":
                String id = request.getParameter("id");
                Project existingProject = projectDAO.getProjectById(id);
                request.setAttribute("project", existingProject);
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;
                
            case "delete":
                String deleteId = request.getParameter("id");
                projectDAO.deleteProject(deleteId);
                response.sendRedirect("project");
                break;
                
            default: // "list"
                List<Project> list = projectDAO.getAllProjects();
                request.setAttribute("projectList", list);
                request.getRequestDispatcher("list-project.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        LabMember user = (LabMember) session.getAttribute("user");

        // 2. Cek RBAC (Keamanan Ganda di Backend)
        if (!isAuthorized(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak.");
            return;
        }

        // 3. Ambil Data Form
        String action = request.getParameter("action");
        String id = request.getParameter("projectID");
        String name = request.getParameter("projectName");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String division = request.getParameter("division");
        String leaderName = request.getParameter("leaderName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Generate ID jika baru
        if (id == null || id.isEmpty()) {
            id = UUID.randomUUID().toString().substring(0, 8);
        }

        // Buat Objek Project
        Project p = new Project(id, name, status, category, division, "L001", leaderName, startDate, endDate);

        // Simpan ke Database
        if ("update".equals(action)) {
            projectDAO.updateProject(p);
        } else {
            projectDAO.addProject(p);
        }
        
        response.sendRedirect("project");
    }
}