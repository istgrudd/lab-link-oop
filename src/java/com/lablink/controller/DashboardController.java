/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.DashboardDAO;
import com.lablink.dao.ReportDAO; // [BARU] Import ReportDAO
import com.lablink.model.AgendaItem;
import java.io.IOException;
import java.util.List;
import java.util.Map; // [BARU]
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

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private DashboardDAO dashboardDAO;
    private ReportDAO reportDAO; // [BARU] Deklarasi ReportDAO

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO();
        reportDAO = new ReportDAO(); // [BARU] Inisialisasi
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Ambil Data Agenda (Fitur Lama)
        List<AgendaItem> agendaList = dashboardDAO.getUpcomingAgenda();
        request.setAttribute("agendaList", agendaList);

        // 2. [BARU] Ambil Data Statistik untuk Widget
        // Map keys: totalMember, projectOngoing, projectCompleted, totalEvent, totalPublikasi, totalHKI
        Map<String, Integer> stats = reportDAO.getLabSummary();
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
