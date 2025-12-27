/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;

import com.lablink.model.Project;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rudi Firdaus
 */
public class ProjectDAO {

    // 1. UPDATE: Insert dengan Deskripsi & Tim
    public boolean addProject(Project p, String[] teamMemberIDs) {
        String sql = "INSERT INTO tb_project (project_id, project_name, description, status, activity_type, division, leader_id, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Transaction Start

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, p.getProjectID());
                stmt.setString(2, p.getProjectName());
                stmt.setString(3, p.getDescription()); // [BARU]
                stmt.setString(4, p.getStatus());
                stmt.setString(5, p.getActivityType());
                stmt.setString(6, p.getDivision());
                stmt.setString(7, p.getLeaderID());
                stmt.setString(8, p.getStartDate());
                stmt.setString(9, p.getEndDate());
                stmt.executeUpdate();
            }

            // Insert Anggota Tim (Multi-Insert)
            if (teamMemberIDs != null) {
                String sqlTeam = "INSERT INTO tb_project_member (project_id, member_id) VALUES (?, ?)";
                try (PreparedStatement teamStmt = conn.prepareStatement(sqlTeam)) {
                    for (String memberID : teamMemberIDs) {
                        // Jangan masukkan Leader lagi ke tim (opsional, tergantung aturan lab)
                        if (!memberID.equals(p.getLeaderID())) {
                            teamStmt.setString(1, p.getProjectID());
                            teamStmt.setString(2, memberID);
                            teamStmt.addBatch();
                        }
                    }
                    teamStmt.executeBatch();
                }
            }

            conn.commit(); // Transaction Commit
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. UPDATE: Update dengan Deskripsi & Reset Tim
    public boolean updateProject(Project p, String[] teamMemberIDs) {
        String sql = "UPDATE tb_project SET project_name=?, description=?, status=?, activity_type=?, division=?, leader_id=?, start_date=?, end_date=? WHERE project_id=?";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // Update Data Utama
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, p.getProjectName());
                stmt.setString(2, p.getDescription()); // [BARU]
                stmt.setString(3, p.getStatus());
                stmt.setString(4, p.getActivityType());
                stmt.setString(5, p.getDivision());
                stmt.setString(6, p.getLeaderID());
                stmt.setString(7, p.getStartDate());
                stmt.setString(8, p.getEndDate());
                stmt.setString(9, p.getProjectID());
                stmt.executeUpdate();
            }

            // Reset Tim: Hapus semua anggota lama dulu, lalu masukkan yang baru
            String deleteTeam = "DELETE FROM tb_project_member WHERE project_id = ?";
            try (PreparedStatement delStmt = conn.prepareStatement(deleteTeam)) {
                delStmt.setString(1, p.getProjectID());
                delStmt.executeUpdate();
            }

            // Insert Tim Baru
            if (teamMemberIDs != null) {
                String insertTeam = "INSERT INTO tb_project_member (project_id, member_id) VALUES (?, ?)";
                try (PreparedStatement teamStmt = conn.prepareStatement(insertTeam)) {
                    for (String memberID : teamMemberIDs) {
                        if (!memberID.equals(p.getLeaderID())) {
                            teamStmt.setString(1, p.getProjectID());
                            teamStmt.setString(2, memberID);
                            teamStmt.addBatch();
                        }
                    }
                    teamStmt.executeBatch();
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. UPDATE: Ambil Data + Deskripsi + List ID Tim
    public Project getProjectById(String id) {
        String sql = "SELECT * FROM tb_project WHERE project_id = ?";
        Project p = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                p = new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("description"), // [BARU]
                    rs.getString("status"),
                    rs.getString("activity_type"),
                    rs.getString("division"),
                    rs.getString("leader_id"),
                    "", // Leader name nanti diambil lewat join atau biarkan kosong utk edit
                    rs.getString("start_date"),
                    rs.getString("end_date")
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Populate Team IDs (Agar checkbox bisa ter-centang otomatis saat edit)
        if (p != null) {
            String sqlTeam = "SELECT member_id FROM tb_project_member WHERE project_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sqlTeam)) {
                stmt.setString(1, id);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    p.getTeamMemberIDs().add(rs.getString("member_id"));
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return p;
    }

    // 4. UPDATE: getAllProjects (Ambil Description)
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        // Query disederhanakan, ambil deskripsi
        String sql = "SELECT p.*, m.name as leader_name FROM tb_project p LEFT JOIN tb_member m ON p.leader_id = m.member_id ORDER BY p.start_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project p = new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("description"), // [BARU]
                    rs.getString("status"),
                    rs.getString("activity_type"),
                    rs.getString("division"),
                    rs.getString("leader_id"),
                    rs.getString("leader_name"),
                    rs.getString("start_date"),
                    rs.getString("end_date")
                );
                // Load nama tim untuk display di tabel/modal
                populateTeamNames(p);
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private void populateTeamNames(Project p) {
        String sql = "SELECT m.name FROM tb_member m JOIN tb_project_member pm ON m.member_id = pm.member_id WHERE pm.project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getProjectID());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                p.getTeamMembers().add(rs.getString("name"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
    }
    
    public boolean deleteProject(String id) {
        // Hapus relasi dulu (constraint FK)
        String sqlRel = "DELETE FROM tb_project_member WHERE project_id = ?";
        String sqlProj = "DELETE FROM tb_project WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt1 = conn.prepareStatement(sqlRel);
                 PreparedStatement stmt2 = conn.prepareStatement(sqlProj)) {
                stmt1.setString(1, id);
                stmt1.executeUpdate();
                
                stmt2.setString(1, id);
                stmt2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) { return false; }
    }
    
    // (Method getTeamDetails dihapus/disatukan karena sudah ada di getProjectById)
}