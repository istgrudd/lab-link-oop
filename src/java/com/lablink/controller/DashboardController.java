/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.controller;

import com.lablink.dao.DashboardDAO; // [BARU]
import com.lablink.model.AgendaItem; // [BARU]
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

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private DashboardDAO dashboardDAO; // [BARU]

    @Override
    public void init() {
        dashboardDAO = new DashboardDAO(); // [BARU]
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // [BARU] Ambil Data Agenda
        List<AgendaItem> agendaList = dashboardDAO.getUpcomingAgenda();
        request.setAttribute("agendaList", agendaList);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
