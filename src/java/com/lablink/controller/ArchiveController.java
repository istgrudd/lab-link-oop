/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.ArchiveDAO;
import com.lablink.dao.ProjectDAO;
import com.lablink.model.Archive;
import com.lablink.model.LabMember;
import com.lablink.model.Project;
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
@WebServlet(name = "ArchiveController", urlPatterns = {"/archive"})
public class ArchiveController extends HttpServlet {
    private ArchiveDAO archiveDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() {
        archiveDAO = new ArchiveDAO();
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

        String action = request.getParameter("action");
        
        // JIKA KLIK "ARSIPKAN" DARI MENU PROYEK (F2)
        if ("createFromProject".equals(action)) {
            String projectID = request.getParameter("projectID");
            Project p = projectDAO.getProjectById(projectID);
            
            request.setAttribute("sourceProject", p);
            request.getRequestDispatcher("create-archive.jsp").forward(request, response);
            return;
        }

        // DEFAULT: TAMPILKAN LIST ARSIP
        List<Archive> listArchive = archiveDAO.getAllArchives();
        request.setAttribute("listArchive", listArchive);
        request.getRequestDispatcher("list-archive.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("saveArchive".equals(action)) {
            String id = request.getParameter("id");
            String projectID = request.getParameter("projectID");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            String location = request.getParameter("location"); // Jurnal/Badan HKI
            String refNum = request.getParameter("refNum");     // DOI/No Reg
            String date = request.getParameter("date");
            
            Archive a = new Archive(id, projectID, "", title, type, location, refNum, date, "");
            archiveDAO.addArchive(a);
            
        } else if ("deleteArchive".equals(action)) {
            String id = request.getParameter("id");
            archiveDAO.deleteArchive(id);
        }
        
        response.sendRedirect("archive");
    }
}