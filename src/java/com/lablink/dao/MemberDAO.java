/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;
import com.lablink.model.LabMember;
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
    // FITUR LOGIN: Mencari user berdasarkan username & password
    public LabMember login(String username, String password) {
        String sql = "SELECT * FROM tb_member WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Return sebagai ResearchAssistant (karena saat ini baru ada class ini)
                return new ResearchAssistant(
                    rs.getString("member_id"),
                    rs.getString("name"),
                    rs.getString("division"),
                    rs.getString("department"),
                    rs.getString("role_title"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("access_role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Login gagal
    }

    // CREATE: Update insert query untuk kolom baru
    // 1. UPDATE: Method Add Member dengan Default Credential
    public boolean addMember(ResearchAssistant ra) {
        String sql = "INSERT INTO tb_member (member_id, name, division, department, role_title, member_type, username, password, access_role) VALUES (?, ?, ?, ?, ?, 'RA', ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ra.getMemberID());
            stmt.setString(2, ra.getName());
            stmt.setString(3, ra.getExpertDivision());
            stmt.setString(4, ra.getDepartment());
            stmt.setString(5, ra.getRoleTitle());
            
            // --- FITUR AUTO-REGISTER ---
            // Username default = Member ID (NIM)
            stmt.setString(6, ra.getMemberID());
            // Password default = Member ID (NIM)
            stmt.setString(7, ra.getMemberID());
            // Role default
            stmt.setString(8, "RESEARCH_ASSISTANT");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // READ: Update mapping result set
    public List<ResearchAssistant> getAllMembers() {
        List<ResearchAssistant> listRA = new ArrayList<>();
        String sql = "SELECT * FROM tb_member WHERE member_type = 'RA'";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                listRA.add(new ResearchAssistant(
                    rs.getString("member_id"),
                    rs.getString("name"),
                    rs.getString("division"),
                    rs.getString("department"),
                    rs.getString("role_title"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("access_role")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listRA;
    }
    
    // Method updateProfile yang SUDAH DIMODIFIKASI
    public boolean updateProfile(ResearchAssistant ra) {
        // Tambahkan role_title = ? ke dalam query
        String sql = "UPDATE tb_member SET name = ?, division = ?, department = ?, role_title = ? WHERE member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ra.getName());
            stmt.setString(2, ra.getExpertDivision());
            stmt.setString(3, ra.getDepartment());
            stmt.setString(4, ra.getRoleTitle()); // Set parameter Jabatan
            stmt.setString(5, ra.getMemberID());  // ID sebagai kunci WHERE (parameter terakhir)
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // FITUR: Ganti Password (jika belum ada)
    public boolean updatePassword(String memberID, String newPassword) {
        String sql = "UPDATE tb_member SET password = ? WHERE member_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
