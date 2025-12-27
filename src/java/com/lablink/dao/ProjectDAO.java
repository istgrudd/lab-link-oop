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

    // 1. Ambil Semua Data Proyek
    public List<Project> getAllProjects() {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM tb_project ORDER BY created_at DESC"; // Sesuaikan nama tabel

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                // Pastikan urutan parameter sesuai Constructor Project.java Anda!
                // (id, name, status, type, division, leaderID, leaderName, start, end)
                list.add(new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("status"),
                    rs.getString("activity_type"), // Pastikan kolom ini ada di DB
                    rs.getString("division"),
                    rs.getString("leader_id"),
                    rs.getString("leader_name"), // Jika di DB tidak ada kolom nama, mungkin perlu JOIN
                    rs.getString("start_date"),
                    rs.getString("end_date")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Tambah Proyek Baru
    public boolean addProject(Project p) {
        String sql = "INSERT INTO tb_project (project_id, project_name, status, activity_type, division, leader_id, leader_name, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getProjectID());
            ps.setString(2, p.getProjectName());
            ps.setString(3, p.getStatus());
            ps.setString(4, p.getActivityType());
            ps.setString(5, p.getDivision());
            ps.setString(6, p.getLeaderID());
            ps.setString(7, p.getLeaderName());
            ps.setString(8, p.getStartDate());
            ps.setString(9, p.getEndDate());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Hapus Proyek
    public boolean deleteProject(String id) {
        String sql = "DELETE FROM tb_project WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 4. Ambil 1 Proyek (Untuk Edit)
    public Project getProjectById(String id) {
        String sql = "SELECT * FROM tb_project WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Project(
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("status"),
                    rs.getString("activity_type"),
                    rs.getString("division"),
                    rs.getString("leader_id"),
                    rs.getString("leader_name"),
                    rs.getString("start_date"),
                    rs.getString("end_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // 5. Update Proyek
    public boolean updateProject(Project p) {
        String sql = "UPDATE tb_project SET project_name=?, status=?, activity_type=?, division=?, leader_id=?, leader_name=?, start_date=?, end_date=? WHERE project_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getProjectName());
            ps.setString(2, p.getStatus());
            ps.setString(3, p.getActivityType());
            ps.setString(4, p.getDivision());
            ps.setString(5, p.getLeaderID());
            ps.setString(6, p.getLeaderName());
            ps.setString(7, p.getStartDate());
            ps.setString(8, p.getEndDate());
            ps.setString(9, p.getProjectID());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}