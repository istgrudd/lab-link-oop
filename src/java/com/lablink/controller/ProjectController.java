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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");

        // LOGIKA BARU: Jika action = edit, tampilkan form edit
        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            Project p = projectDAO.getProjectById(id);
            
            // [BARU] Ambil detail tim
            List<ProjectTeamMember> listTeam = projectDAO.getTeamDetails(id);
            request.setAttribute("listTeam", listTeam); // Kirim ke JSP
            
            request.setAttribute("project", p);
            request.getRequestDispatcher("edit-project.jsp").forward(request, response);
            return;
        }
        
        // Ambil Data Proyek
        List<Project> listProject = projectDAO.getAllProjects();
        request.setAttribute("listProject", listProject);

        // Ambil Data Member (Untuk Form Assign Member)
        List<ResearchAssistant> listMember = memberDAO.getAllMembers();
        request.setAttribute("listMember", listMember);

        request.getRequestDispatcher("list-project.jsp").forward(request, response);
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

            // Buat objek dengan divisi
            Project p = new Project(id, name, status, type, division);
            
            projectDAO.addProject(p);

        } else if ("updateProject".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String status = request.getParameter("status");
            String type = request.getParameter("type");
            String division = request.getParameter("division");

            Project p = new Project(id, name, status, type, division);
            projectDAO.updateProject(p);
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
