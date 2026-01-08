package com.lablink.dao;

import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;


public class ReportDAO {

    // Fitur Ambil Ringkasan Statistik
    public Map<String, Integer> getLabSummary() {
        Map<String, Integer> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // 1. Total Active Members
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_member");
            if(rs.next()) stats.put("totalMember", rs.getInt(1));
            
            // 2. Ongoing Projects
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_project WHERE status='Ongoing'");
            if(rs.next()) stats.put("projectOngoing", rs.getInt(1));
            
            // 3. Completed Projects
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_project WHERE status='Completed'");
            if(rs.next()) stats.put("projectCompleted", rs.getInt(1));
            
            // 4. Total External Activities
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_event");
            if(rs.next()) stats.put("totalEvent", rs.getInt(1));
            
            // 5. Total Publications
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_archive WHERE archive_type='Publikasi'");
            if(rs.next()) stats.put("totalPublikasi", rs.getInt(1));
            
            // 6. Total IPR
            rs = stmt.executeQuery("SELECT COUNT(*) FROM tb_archive WHERE archive_type='HKI'");
            if(rs.next()) stats.put("totalHKI", rs.getInt(1));
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
