/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;
import com.lablink.model.ResearchAssistant;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Rudi Firdaus
 */
public class MemberDAO {
    // CREATE: Menambah Anggota ke Database [cite: 33]
    public boolean addMember(ResearchAssistant ra) {
        String sql = "INSERT INTO tb_member (member_id, name, division, department, role_title, member_type) VALUES (?, ?, ?, ?, ?, 'RA')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ra.getMemberID());
            stmt.setString(2, ra.getName());
            stmt.setString(3, ra.getExpertDivision());
            stmt.setString(4, ra.getDepartment());
            stmt.setString(5, ra.getRoleTitle());
            
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
            
        } catch (SQLException e) {
            e.printStackTrace(); // Exception handling sederhana [cite: 75]
            return false;
        }
    }

    // READ: Mengambil semua data Anggota untuk ditampilkan di Website
    public List<ResearchAssistant> getAllMembers() {
        List<ResearchAssistant> listRA = new ArrayList<>();
        String sql = "SELECT * FROM tb_member WHERE member_type = 'RA'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                ResearchAssistant ra = new ResearchAssistant(
                    rs.getString("member_id"),
                    rs.getString("name"),
                    rs.getString("division"),
                    rs.getString("department"),
                    rs.getString("role_title")
                );
                listRA.add(ra);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listRA;
    }
}
