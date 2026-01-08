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
        
        // Feature: Check Session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        // Important: Prevent NullPointerException
        if (action == null) {
            action = "list";
        }

        // Feature: Handle Action
        switch (action) {
            case "add":
                // Send member list for Leader dropdown
                request.setAttribute("listMember", memberDAO.getAllMembers());
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;

            case "edit":
                String id = request.getParameter("id");
                Project p = projectDAO.getProjectById(id);
                // Send project & member data for edit form
                request.setAttribute("project", p);
                request.setAttribute("listMember", memberDAO.getAllMembers());
                request.getRequestDispatcher("edit-project.jsp").forward(request, response);
                break;
            
            // Feature: Delete Project
            case "delete":
                String deleteId = request.getParameter("id");
                projectDAO.deleteProject(deleteId);
                response.sendRedirect("project");
                break;

            default: // "list"
                // Get data for table
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
        
        // Feature: Check Role (Only Internal & Lab Head allowed)
        if (user == null || "HEAD_OF_EXTERNAL".equals(user.getAccessRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak.");
            return;
        }

        String action = request.getParameter("action");
        
        // Feature: Save (Add) & Update (Edit)
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
            
            // Generate ID if new
            if (id == null || id.isEmpty()) {
                id = UUID.randomUUID().toString().substring(0, 8);
            }

            // Create Project object
            Project p = new Project(id, name, description, status, category, division, leaderID, "", startDate, endDate);

            if ("update".equals(action)) {
                // Send teamMemberIDs array to DAO
                projectDAO.updateProject(p, teamMemberIDs);
            } else {
                // Send teamMemberIDs array to DAO
                projectDAO.addProject(p, teamMemberIDs);
            }
        // Feature: Delete Project
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            projectDAO.deleteProject(id);
        }
        
        // Redirect back to list
        response.sendRedirect("project");
    }
}