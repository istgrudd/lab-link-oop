package com.lablink.controller;

import com.lablink.dao.ActivityLogDAO;
import com.lablink.model.ActivityLog;
import com.lablink.model.LabMember;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "ActivityLogController", urlPatterns = { "/activity-log" })
public class ActivityLogController extends HttpServlet {

    private ActivityLogDAO logDAO = new ActivityLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        LabMember user = (LabMember) session.getAttribute("user");
        String role = user.getAccessRole();

        // Hanya HEAD_OF_LAB yang bisa melihat activity log
        if (!"HEAD_OF_LAB".equals(role)) {
            response.sendRedirect("dashboard");
            return;
        }

        String filterType = request.getParameter("type");
        String filterUser = request.getParameter("user");

        List<ActivityLog> logs;

        if (filterType != null && !filterType.isEmpty()) {
            logs = logDAO.getLogsByTargetType(filterType);
        } else if (filterUser != null && !filterUser.isEmpty()) {
            logs = logDAO.getLogsByUser(filterUser);
        } else {
            logs = logDAO.getAllLogs();
        }

        request.setAttribute("logs", logs);
        request.getRequestDispatcher("activity-log.jsp").forward(request, response);
    }
}
