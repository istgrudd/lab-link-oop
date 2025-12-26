/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;

import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;


/**
 *
 * @author Rudi Firdaus
 */
public class ReportDAO {

    // Mengambil ringkasan statistik (Total Member, Proyek, dll)
    public Map<String, Integer> getLabSummary() {
        Map<String, Integer> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // 1. Total Member Aktif
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_member");
            if(rs.next()) stats.put("totalMember", rs.getInt(1));
            
            // 2. Proyek Ongoing
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_project WHERE status='Ongoing'");
            if(rs.next()) stats.put("projectOngoing", rs.getInt(1));
            
            // 3. Proyek Completed
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_project WHERE status='Completed'");
            if(rs.next()) stats.put("projectCompleted", rs.getInt(1));
            
            // 4. Total Kegiatan Eksternal
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_event");
            if(rs.next()) stats.put("totalEvent", rs.getInt(1));
            
            // 5. Total Publikasi
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_archive WHERE archive_type='Publikasi'");
            if(rs.next()) stats.put("totalPublikasi", rs.getInt(1));
            
            // 6. Total HKI
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_archive WHERE archive_type='HKI'");
            if(rs.next()) stats.put("totalHKI", rs.getInt(1));
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
