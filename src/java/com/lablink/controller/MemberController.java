package com.lablink.controller;

import com.lablink.dao.MemberDAO;
import com.lablink.model.ResearchAssistant;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lablink.model.LabMember;
import javax.servlet.http.HttpSession;

@WebServlet(name = "MemberController", urlPatterns = { "/member" })
public class MemberController extends HttpServlet {
    // Member DAO
    private MemberDAO memberDAO;

    @Override
    public void init() {
        memberDAO = new MemberDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Fitur Tampilkan Form Edit
        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            ResearchAssistant ra = memberDAO.getMemberById(id);
            request.setAttribute("member", ra);
            request.getRequestDispatcher("edit-member.jsp").forward(request, response);

            // Fitur Tampilkan Form Tambah
        } else if ("add".equals(action)) {
            // Forward to edit-member.jsp without member attribute (isEdit = false)
            request.getRequestDispatcher("edit-member.jsp").forward(request, response);

            // Fitur Hapus Member
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            memberDAO.deleteMember(id);
            response.sendRedirect("member");

            // Fitur Tampilkan List Member
        } else {
            List<ResearchAssistant> list = memberDAO.getAllMembers();
            request.setAttribute("listRA", list);
            request.getRequestDispatcher("list-member.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fitur Cek Hak Akses
        HttpSession session = request.getSession(false);
        LabMember currentUser = (LabMember) session.getAttribute("user");

        String action = request.getParameter("action");

        // Fitur Update Member
        if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String division = request.getParameter("division");
            String dept = request.getParameter("department");
            String roleTitle = request.getParameter("role"); // Jabatan text
            String accessRole = request.getParameter("accessRole"); // System Role

            // We fill in the username & password with an empty string because the
            // updateMember DAO doesn't change it.
            ResearchAssistant ra = new ResearchAssistant(
                    id, name, division, dept, roleTitle, "", "", accessRole);

            memberDAO.updateMember(ra);
            response.sendRedirect("member");

            // Fitur Tambah Member
        } else if ("add".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String division = request.getParameter("division");
            String department = request.getParameter("department");
            String role = request.getParameter("role");
            String accessRole = request.getParameter("accessRole");

            // Default ke RESEARCH_ASSISTANT jika tidak dipilih
            if (accessRole == null || accessRole.isEmpty()) {
                accessRole = "RESEARCH_ASSISTANT";
            }

            // Username & password default = ID
            ResearchAssistant newRA = new ResearchAssistant(id, name, division, department, role, id, id, accessRole);

            memberDAO.addMember(newRA);
            response.sendRedirect("member");
        }

    }
}
