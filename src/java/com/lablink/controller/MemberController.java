/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
/**
 *
 * @author Rudi Firdaus
 */
@WebServlet(name = "MemberController", urlPatterns = {"/member"})
public class MemberController extends HttpServlet {
    // Referensi ke DAO buatan Rudi
    private MemberDAO memberDAO;

    @Override
    public void init() {
        // Inisialisasi DAO saat servlet pertama kali jalan
        memberDAO = new MemberDAO();
    }

    // METHOD GET: Dipanggil saat user membuka URL /member (untuk melihat daftar)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil list member dari Database lewat DAO
        List<ResearchAssistant> listMember = memberDAO.getAllMembers();
        
        // 2. "Titip" data list tersebut ke request agar bisa dibaca di JSP
        request.setAttribute("listRA", listMember);
        
        // 3. Oper (Forward) ke halaman View (list-member.jsp) buatan Fathier
        request.getRequestDispatcher("list-member.jsp").forward(request, response);
    }

    // METHOD POST: Dipanggil saat user Submit Form (Simpan Data)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Tangkap inputan user dari Form HTML (nama atribut harus sama dengan di HTML)
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String division = request.getParameter("division");
        String department = request.getParameter("department");
        String role = request.getParameter("role");

        // 2. Bungkus data ke dalam Objek Model (ResearchAssistant)
        ResearchAssistant newRA = new ResearchAssistant(id, name, division, department, role);

        // 3. Panggil DAO untuk simpan ke Database
        boolean success = memberDAO.addMember(newRA);

        // 4. Redirect kembali ke halaman list member
        // (Gunakan sendRedirect agar URL berubah dan mencegah submit ulang saat refresh)
        response.sendRedirect("member"); 
    }
}
