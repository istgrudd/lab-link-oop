/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.ProjectDAO;
import com.lablink.model.ProjectTeamMember;
import com.lablink.dao.MemberDAO;
import com.lablink.model.Project;
import com.lablink.model.ResearchAssistant;
import com.lablink.model.LabMember;
import java.io.IOException;
import java.util.List;
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
    private MemberDAO memberDAO; // Butuh ini untuk dropdown list member saat assign

    @Override
    public void init() {
        projectDAO = new ProjectDAO();
        memberDAO = new MemberDAO();
    }
    
    private boolean isAuthorized(LabMember user) {
        if (user == null) return false;
        String role = user.getAccessRole();
        
        // ATURAN: Ketua Eksternal DILARANG kelola proyek (Hanya View)
        if ("HEAD_OF_EXTERNAL".equalsIgnoreCase(role)) {
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
                Project p = projectDAO.getProjectById(id);
                List<ProjectTeamMember> listTeam = projectDAO.getTeamDetails(id);

                // [BARU] Ambil semua member untuk Dropdown Leader di Edit Page
                List<ResearchAssistant> listMember = memberDAO.getAllMembers(); 
                request.setAttribute("listMember", listMember);

                request.setAttribute("listTeam", listTeam);
                request.setAttribute("project", p);
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;
                
            case "delete":
                String deleteId = request.getParameter("id");
                projectDAO.deleteProject(deleteId);
                response.sendRedirect("project");
                break;
                
            default: // "list"
                List<Project> listProject = projectDAO.getAllProjects();
                request.setAttribute("listProject", listProject);

                request.getRequestDispatcher("list-project.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil User dari Session
        HttpSession session = request.getSession(false);
        LabMember user = (LabMember) session.getAttribute("user");
        
        // 2. Cek apakah user berhak mengelola?
        String role = user.getAccessRole();
        boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_INTERNAL".equals(role);
        
        if (!canManage) {
            // Jika RA biasa mencoba POST data, tolak!
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak: Anda tidak memiliki izin mengelola proyek.");
            return;
        }

        // 3. Jika berhak, lanjut proses...
        String action = request.getParameter("action");
        
        if ("addProject".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String status = request.getParameter("status");
            String type = request.getParameter("type");
            String division = request.getParameter("division"); // [BARU] Tangkap Input

            String leaderID = request.getParameter("leaderID"); // [BARU]
        
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
        
            // Gunakan constructor baru
            Project p = new Project(id, name, status, type, division, leaderID, "", startDate, endDate);
            projectDAO.addProject(p);

        } else if ("updateProject".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String status = request.getParameter("status");
            String type = request.getParameter("type");
            String division = request.getParameter("division");
            String leaderID = request.getParameter("leaderID"); // [BARU]
        
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
        
            Project p = new Project(id, name, status, type, division, leaderID, "", startDate, endDate);
            projectDAO.updateProject(p);
        } else if ("deleteProject".equals(action)) {
            String id = request.getParameter("id");
            projectDAO.deleteProject(id);
        } else if ("assignMember".equals(action)) {
            // ... (Kode assignMember tetap sama) ...
            String projectID = request.getParameter("projectID");
            String memberID = request.getParameter("memberID");
            projectDAO.addMemberToProject(projectID, memberID);
        } else if ("removeMember".equals(action)) {
            // [BARU] Logika Hapus Member
            String projectID = request.getParameter("projectID");
            String memberID = request.getParameter("memberID");
            
            projectDAO.removeMemberFromProject(projectID, memberID);
            
            // Redirect kembali ke halaman edit
            response.sendRedirect("project?action=edit&id=" + projectID);
            return;
        }
        
        response.sendRedirect("project");
    }
}