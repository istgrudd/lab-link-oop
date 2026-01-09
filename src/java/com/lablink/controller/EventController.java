package com.lablink.controller;

import com.lablink.dao.EventDAO;
import com.lablink.dao.MemberDAO;
import com.lablink.dao.ActivityLogDAO;
import com.lablink.model.LabEvent;
import com.lablink.model.LabMember;
import com.lablink.model.ResearchAssistant;
import com.lablink.model.CommitteeMember;
import java.io.IOException;
import java.util.List;
import com.lablink.util.IDGenerator;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "EventController", urlPatterns = { "/event" })
public class EventController extends HttpServlet {
    private EventDAO eventDAO;
    private MemberDAO memberDAO;
    private ActivityLogDAO logDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
        memberDAO = new MemberDAO();
        logDAO = new ActivityLogDAO();
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

        // Fitur Edit Event
        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            LabEvent e = eventDAO.getEventById(id);
            List<ResearchAssistant> listMember = memberDAO.getAllMembers();

            // Fitur Ambil Data Detail Panitia
            List<CommitteeMember> listCommittee = eventDAO.getCommitteeDetails(id);
            request.setAttribute("listCommittee", listCommittee);

            request.setAttribute("event", e);
            request.setAttribute("listMember", listMember);
            request.getRequestDispatcher("edit-event.jsp").forward(request, response);
            return;
        }

        // Fitur Tambah Event (Show Form)
        if ("add".equals(action)) {
            List<ResearchAssistant> listMember = memberDAO.getAllMembers();
            request.setAttribute("listMember", listMember);
            request.getRequestDispatcher("edit-event.jsp").forward(request, response);
            return;
        }

        // Fitur Hapus Event (via GET link)
        if ("deleteEvent".equals(action)) {
            // Check permission
            LabMember user = (LabMember) session.getAttribute("user");
            String role = user.getAccessRole();
            boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);

            if (canManage) {
                String id = request.getParameter("id");
                LabEvent delEvent = eventDAO.getEventById(id);
                String delName = (delEvent != null) ? delEvent.getEventName() : id;
                eventDAO.deleteEvent(id);
                logDAO.log(user.getMemberID(), user.getName(), "DELETE", "EVENT", id, delName,
                        "Menghapus kegiatan: " + delName);
            }
            response.sendRedirect("event");
            return;
        }

        // Fitur Tampilkan List Event
        List<LabEvent> listEvent = eventDAO.getAllEvents();
        // Fitur Tambah Event
        List<ResearchAssistant> listMember = memberDAO.getAllMembers();

        request.setAttribute("listEvent", listEvent);
        request.setAttribute("listMember", listMember);
        request.getRequestDispatcher("list-event.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fitur Cek Hak Akses
        HttpSession session = request.getSession(false);
        LabMember user = (LabMember) session.getAttribute("user");
        String role = user.getAccessRole();

        boolean canManage = "HEAD_OF_LAB".equals(role) || "HEAD_OF_EXTERNAL".equals(role);

        if (!canManage) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Akses Ditolak.");
            return;
        }

        String action = request.getParameter("action");

        // Fitur Tambah Event
        if ("addEvent".equals(action)) {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String date = request.getParameter("date");
            String picID = request.getParameter("picID");
            
            // Generate Event ID automatically
            String id = IDGenerator.generateEventID();

            LabEvent e = new LabEvent(id, name, date, picID, "", description);
            boolean success = eventDAO.addEvent(e);
            if (success) {
                logDAO.log(user.getMemberID(), user.getName(), "CREATE", "EVENT", id, name,
                        "Menambah kegiatan baru: " + name);
            } else {
                System.err.println("[EventController] GAGAL menambah event: " + id + " - " + name);
            }

            // Fitur Update Event
        } else if ("updateEvent".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String date = request.getParameter("date");
            String picID = request.getParameter("picID");

            LabEvent e = new LabEvent(id, name, date, picID, "", description);
            boolean success = eventDAO.updateEvent(e);
            if (success) {
                logDAO.log(user.getMemberID(), user.getName(), "UPDATE", "EVENT", id, name, "Mengupdate kegiatan: " + name);
            } else {
                System.err.println("[EventController] GAGAL update event: " + id);
            }

            // Fitur Hapus Event
        } else if ("deleteEvent".equals(action)) {
            String id = request.getParameter("id");
            LabEvent delE = eventDAO.getEventById(id);
            String delName = (delE != null) ? delE.getEventName() : id;
            eventDAO.deleteEvent(id);
            logDAO.log(user.getMemberID(), user.getName(), "DELETE", "EVENT", id, delName,
                    "Menghapus kegiatan: " + delName);
            // Fitur Tambah Panitia
        } else if ("addCommittee".equals(action)) {
            String eventID = request.getParameter("eventID");
            String memberID = request.getParameter("memberID");
            String roles = request.getParameter("roles");

            eventDAO.addCommitteeMember(eventID, memberID, roles);
            // Fitur Update Role Panitia
        } else if ("updateCommitteeRole".equals(action)) {
            String eventID = request.getParameter("eventID");
            String memberID = request.getParameter("memberID");
            String newRole = request.getParameter("roles");

            eventDAO.updateCommitteeRole(eventID, memberID, newRole);
            // Redirect kembali ke halaman edit (bukan ke list event) agar bisa lanjut edit
            response.sendRedirect("event?action=edit&id=" + eventID);
            return;

            // Fitur Hapus Panitia
        } else if ("removeCommittee".equals(action)) {
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
