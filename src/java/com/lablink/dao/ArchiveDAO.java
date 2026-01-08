package com.lablink.dao;

import com.lablink.model.Archive;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArchiveDAO {

    // Fitur Tambah Arsip
    public boolean addArchive(Archive a) {
        String sql = "INSERT INTO tb_archive (archive_id, project_id, title, archive_type, publish_location, reference_number, publish_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getArchiveID());
            stmt.setString(2, a.getProjectID());
            stmt.setString(3, a.getTitle());
            stmt.setString(4, a.getType());
            stmt.setString(5, a.getPublishLocation());
            stmt.setString(6, a.getReferenceNumber());
            stmt.setString(7, a.getPublishDate());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // Fitur Ambil Semua Arsip
    public List<Archive> getAllArchives() {
        List<Archive> list = new ArrayList<>();
        String sql = "SELECT a.*, p.project_name, m.name as leader_name " +
                     "FROM tb_archive a " +
                     "JOIN tb_project p ON a.project_id = p.project_id " +
                     "LEFT JOIN tb_member m ON p.leader_id = m.member_id " +
                     "ORDER BY a.publish_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new Archive(
                    rs.getString("archive_id"),
                    rs.getString("project_id"),
                    rs.getString("project_name"),
                    rs.getString("title"),
                    rs.getString("archive_type"),
                    rs.getString("publish_location"),
                    rs.getString("reference_number"),
                    rs.getString("publish_date"),
                    rs.getString("leader_name")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    // Fitur Hapus Arsip
    public boolean deleteArchive(String id) {
        String sql = "DELETE FROM tb_archive WHERE archive_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
    
    // Fitur Cek Status Arsip Proyek
    public boolean isProjectArchived(String projectID) {
        String sql = "SELECT 1 FROM tb_archive WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, projectID);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) { return false; }
    }
}
