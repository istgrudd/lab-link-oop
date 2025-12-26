/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.MemberDAO;
import com.lablink.dao.ProjectDAO;
import com.lablink.dao.ReportDAO;
import com.lablink.model.LabMember;
import com.lablink.model.Project;
import com.lablink.model.ResearchAssistant;
import java.io.IOException;
import java.util.List;
import java.util.Map;
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
@WebServlet(name = "ReportController", urlPatterns = {"/report"})
public class ReportController extends HttpServlet {
    
    private ReportDAO reportDAO;
    private MemberDAO memberDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
        memberDAO = new MemberDAO();
        projectDAO = new ProjectDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Ambil Data Ringkasan (Angka-angka)
        Map<String, Integer> summary = reportDAO.getLabSummary();
        request.setAttribute("summary", summary);
        
        // 2. Ambil Data Detail untuk Tabel Rekap
        List<ResearchAssistant> listMember = memberDAO.getAllMembers();
        List<Project> listProject = projectDAO.getAllProjects();
        
        request.setAttribute("listMember", listMember);
        request.setAttribute("listProject", listProject);

        request.getRequestDispatcher("report.jsp").forward(request, response);
    }
}
