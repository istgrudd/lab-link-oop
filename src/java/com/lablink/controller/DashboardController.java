package com.lablink.controller;

import com.lablink.dao.DashboardDAO;
import com.lablink.dao.ReportDAO;
import com.lablink.model.AgendaItem;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private DashboardDAO dashboardDAO;
    private ReportDAO reportDAO;

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fitur Tampilkan Agenda
        List<AgendaItem> agendaList = dashboardDAO.getUpcomingAgenda();
        request.setAttribute("agendaList", agendaList);

        // Fitur Tampilkan Statistik
        // Map keys: totalMember, projectOngoing, projectCompleted, totalEvent, totalPublikasi, totalHKI
        Map<String, Integer> stats = reportDAO.getLabSummary();
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
