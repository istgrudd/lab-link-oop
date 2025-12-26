/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;

import com.lablink.model.Project;
import com.lablink.model.ProjectTeamMember;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rudi Firdaus
 */
public class ProjectDAO {

    // 1. UPDATE: Method addProject
    public boolean addProject(Project p) {
        // Tambah kolom leader_id
        String sql = "INSERT INTO tb_project (project_id, project_name, status, activity_type, division, leader_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getProjectID());
            stmt.setString(2, p.getProjectName());
            stmt.setString(3, p.getStatus());
            stmt.setString(4, p.getActivityType());
            stmt.setString(5, p.getDivision());
            stmt.setString(6, p.getLeaderID()); // [BARU]
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ASSIGN MEMBER KE PROYEK (Menambah data ke tabel relasi)
    public boolean addMemberToProject(String projectID, String memberID) {
        String sql = "INSERT INTO tb_project_member (project_id, member_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, projectID);
            stmt.setString(2, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace(); // Kemungkinan error: Duplicate entry (sudah join)
            return false;
        }
    }

    // 2. UPDATE: Method getAllProjects (Ambil Nama Leader)
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        // JOIN ke tb_member untuk ambil nama leader
        String sql = "SELECT p.*, m.name as leader_name FROM tb_project p " +
                     "LEFT JOIN tb_member m ON p.leader_id = m.member_id";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project p = new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("status"),
                    rs.getString("activity_type"),
                    rs.getString("division"),
                    rs.getString("leader_id"),     // [BARU]
                    rs.getString("leader_name")    // [BARU]
                );
                p.getTeamMembers().addAll(getTeamMembers(p.getProjectID()));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Helper: Ambil nama anggota per proyek
    private List<String> getTeamMembers(String projectID) {
        List<String> names = new ArrayList<>();
        String sql = "SELECT m.name FROM tb_member m " +
                     "JOIN tb_project_member pm ON m.member_id = pm.member_id " +
                     "WHERE pm.project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, projectID);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                names.add(rs.getString("name"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return names;
    }
    
    // 3. UPDATE: Method getProjectById (Untuk Edit)
    public Project getProjectById(String id) {
        String sql = "SELECT * FROM tb_project WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Leader Name dikosongkan dulu tidak apa-apa utk form edit
                return new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("status"),
                    rs.getString("activity_type"),
                    rs.getString("division"),
                    rs.getString("leader_id"), // [BARU]
                    "" 
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 4. UPDATE: Method updateProject
    public boolean updateProject(Project p) {
        String sql = "UPDATE tb_project SET project_name=?, status=?, activity_type=?, division=?, leader_id=? WHERE project_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getProjectName());
            stmt.setString(2, p.getStatus());
            stmt.setString(3, p.getActivityType());
            stmt.setString(4, p.getDivision());
            stmt.setString(5, p.getLeaderID()); // [BARU]
            stmt.setString(6, p.getProjectID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
    
    public List<ProjectTeamMember> getTeamDetails(String projectID) {
        List<ProjectTeamMember> list = new ArrayList<>();
        String sql = "SELECT m.member_id, m.name FROM tb_member m " +
                     "JOIN tb_project_member pm ON m.member_id = pm.member_id " +
                     "WHERE pm.project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, projectID);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                list.add(new ProjectTeamMember(
                    rs.getString("member_id"),
                    rs.getString("name")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // [BARU] Hapus Member dari Proyek
    public boolean removeMemberFromProject(String projectID, String memberID) {
        String sql = "DELETE FROM tb_project_member WHERE project_id = ? AND member_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, projectID);
            stmt.setString(2, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
    
    public boolean deleteProject(String id) {
        String sql = "DELETE FROM tb_project WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}
