/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.EventDAO;
import com.lablink.dao.MemberDAO;
import com.lablink.model.LabEvent;
import com.lablink.model.LabMember;
import com.lablink.model.ResearchAssistant;
import com.lablink.model.CommitteeMember;
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
@WebServlet(name = "EventController", urlPatterns = {"/event"})
public class EventController extends HttpServlet {
    private EventDAO eventDAO;
    private MemberDAO memberDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
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
        
        // FITUR EDIT: Ambil data event by ID
        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            LabEvent e = eventDAO.getEventById(id);
            List<ResearchAssistant> listMember = memberDAO.getAllMembers(); 
            
            // [BARU] Ambil data detail panitia
            List<CommitteeMember> listCommittee = eventDAO.getCommitteeDetails(id);
            request.setAttribute("listCommittee", listCommittee); // Kirim ke JSP
            
            request.setAttribute("event", e);
            request.setAttribute("listMember", listMember);
            request.getRequestDispatcher("edit-event.jsp").forward(request, response);
            return;
        }

        // DEFAULT: Tampilkan List Event
        List<LabEvent> listEvent = eventDAO.getAllEvents();
        List<ResearchAssistant> listMember = memberDAO.getAllMembers(); // Untuk form Tambah Event
        
        request.setAttribute("listEvent", listEvent);
        request.setAttribute("listMember", listMember);
        request.getRequestDispatcher("list-event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cek Hak Akses
        HttpSession session = request.getSession(false);
        LabMember user = (LabMember) session.getAttribute("user");
        String role = user.getAccessRole();
        
        boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);
        
        if (!canManage) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak.");
            return;
        }

        String action = request.getParameter("action");
        
        if ("addEvent".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String date = request.getParameter("date"); // Format dari input type="date"
            String picID = request.getParameter("picID");

            LabEvent e = new LabEvent(id, name, date, picID, "", description);
            eventDAO.addEvent(e);

        } else if ("updateEvent".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String date = request.getParameter("date");
            String picID = request.getParameter("picID");
            
            LabEvent e = new LabEvent(id, name, date, picID, "", description);
            eventDAO.updateEvent(e);
            
        } else if ("deleteEvent".equals(action)) {
            String id = request.getParameter("id");
            eventDAO.deleteEvent(id);
        } else if ("addCommittee".equals(action)) {
            String eventID = request.getParameter("eventID");
            String memberID = request.getParameter("memberID");
            String roles = request.getParameter("role"); // [BARU] Tangkap Role
            
            // Panggil method DAO yang baru
            eventDAO.addCommitteeMember(eventID, memberID, role);
        } else if ("updateCommitteeRole".equals(action)) {
            // [BARU] Logika Ganti Role
            String eventID = request.getParameter("eventID");
            String memberID = request.getParameter("memberID");
            String newRole = request.getParameter("role");
            
            eventDAO.updateCommitteeRole(eventID, memberID, newRole);
            // Redirect kembali ke halaman edit (bukan ke list event) agar bisa lanjut edit
            response.sendRedirect("event?action=edit&id=" + eventID);
            return;

        } else if ("removeCommittee".equals(action)) {
            // [BARU] Logika Hapus Panitia
            String eventID = request.getParameter("eventID");
            String memberID = request.getParameter("memberID");
            
            eventDAO.removeCommitteeMember(eventID, memberID);
            // Redirect kembali ke halaman edit
            response.sendRedirect("event?action=edit&id=" + eventID);
            return;
        }
        
        response.sendRedirect("event");
    }
}
