package com.lablink.dao;
import com.lablink.model.LabMember;
import com.lablink.model.ResearchAssistant;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;  

public class MemberDAO {
    
    private Connection conn;

    public MemberDAO() {
        conn = DBConnection.getConnection();
    }
    
    // Fitur Login
    public LabMember login(String username, String password) {
        String sql = "SELECT * FROM tb_member WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Return as ResearchAssistant (because currently only this class exists)
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
        return null; // Login failed
    }

    // Fitur Tambah Member
    // Feature: Add Member with Default Credential
    public boolean addMember(ResearchAssistant ra) {
        String sql = "INSERT INTO tb_member (member_id, name, division, department, role_title, member_type, username, password, access_role) VALUES (?, ?, ?, ?, ?, 'RA', ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ra.getMemberID());
            stmt.setString(2, ra.getName());
            stmt.setString(3, ra.getExpertDivision());
            stmt.setString(4, ra.getDepartment());
            stmt.setString(5, ra.getRoleTitle());
            
            // Feature: Auto-Register
            // Default username = Member ID (NIM)
            stmt.setString(6, ra.getMemberID());
            // Default password = Member ID (NIM)
            stmt.setString(7, ra.getMemberID());
            // Default role
            stmt.setString(8, "RESEARCH_ASSISTANT");

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateMember(ResearchAssistant ra) {
        String sql = "UPDATE tb_member SET name = ?, division = ?, department = ?, role_title = ?, access_role = ? WHERE member_id = ?";
        
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, ra.getName());
            stmt.setString(2, ra.getExpertDivision()); // This getter gets the value for the 'division' column
            stmt.setString(3, ra.getDepartment());
            stmt.setString(4, ra.getRoleTitle());
            stmt.setString(5, ra.getAccessRole());
            stmt.setString(6, ra.getMemberID());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteMember(String id) {
        String sql = "DELETE FROM tb_member WHERE member_id = ?";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            // If it fails (e.g., due to FK constraint), print error
            e.printStackTrace();
            return false;
        }
    }
    
    // Fitur Ambil Member Berdasarkan ID
    public ResearchAssistant getMemberById(String id) {
        ResearchAssistant ra = null;
        String sql = "SELECT * FROM tb_member WHERE member_id = ?";
        
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                ra = new ResearchAssistant(
                    rs.getString("member_id"),
                    rs.getString("name"),
                    rs.getString("division"),    // DB Column: division
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
        return ra;
    }
    
    // Fitur Ambil Semua Member
    public List<ResearchAssistant> getAllMembers() {
        List<ResearchAssistant> list = new ArrayList<>();
        String sql = "SELECT * FROM tb_member";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                list.add(new ResearchAssistant(
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
        return list;
    }
    
    // Fitur Update Profil
    public boolean updateProfile(ResearchAssistant ra) {
        // Add role_title = ? to the query
        String sql = "UPDATE tb_member SET name = ?, division = ?, department = ?, role_title = ? WHERE member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ra.getName());
            stmt.setString(2, ra.getExpertDivision());
            stmt.setString(3, ra.getDepartment());
            stmt.setString(4, ra.getRoleTitle()); // Set Position parameter
            stmt.setString(5, ra.getMemberID());  // ID as WHERE key (last parameter)
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Fitur Ganti Password
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
