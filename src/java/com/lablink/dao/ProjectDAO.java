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

    // CREATE PROYEK
    public boolean addProject(Project p) {
        String sql = "INSERT INTO tb_project (project_id, project_name, status, activity_type) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, p.getProjectID());
            stmt.setString(2, p.getProjectName());
            stmt.setString(3, p.getStatus());
            stmt.setString(4, p.getActivityType());
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

    // READ ALL PROJECTS (Beserta Anggotanya)
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM tb_project";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Project p = new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("status"),
                    rs.getString("activity_type")
                );
                
                // Ambil daftar anggota tim untuk proyek ini
                p.getTeamMembers().addAll(getTeamMembers(p.getProjectID()));
                
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
}
