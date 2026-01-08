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
        
        // Fitur Membuat Arsip dari Proyek
        if ("createFromProject".equals(action)) {
            String projectID = request.getParameter("projectID");
            Project p = projectDAO.getProjectById(projectID);
            
            request.setAttribute("sourceProject", p);
            request.getRequestDispatcher("create-archive.jsp").forward(request, response);
            return;
        }

        // Fitur Tampilkan List Arsip
        List<Archive> listArchive = archiveDAO.getAllArchives();
        request.setAttribute("listArchive", listArchive);
        request.getRequestDispatcher("list-archive.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Fitur Simpan Arsip
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
            
        // Fitur Hapus Arsip
        } else if ("deleteArchive".equals(action)) {
            String id = request.getParameter("id");
            archiveDAO.deleteArchive(id);
        }
        
        response.sendRedirect("archive");
    }
}