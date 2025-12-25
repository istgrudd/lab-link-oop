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
        
        String action = request.getParameter("action");
        
        if ("addProject".equals(action)) {
            // Logika Tambah Proyek
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String status = request.getParameter("status");
            String type = request.getParameter("type");
            
            Project p = new Project(id, name, status, type);
            projectDAO.addProject(p);
            
        } else if ("assignMember".equals(action)) {
            // Logika Tambah Anggota ke Proyek
            String projectID = request.getParameter("projectID");
            String memberID = request.getParameter("memberID");
            
            projectDAO.addMemberToProject(projectID, memberID);
        }
        
        response.sendRedirect("project");
    }
}
