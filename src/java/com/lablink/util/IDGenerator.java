package com.lablink.util;

import java.sql.*;

/**
 * Utility class untuk generate ID otomatis dengan format tertentu
 */
public class IDGenerator {
    
    /**
     * Generate Project ID berdasarkan kategori
     * @param category - "Riset", "HKI", atau "Pengabdian"
     * @return ID dengan format RST-0001, HKI-0001, atau PKM-0001
     */
    public static String generateProjectID(String category) {
        String prefix;
        switch (category) {
            case "HKI":
                prefix = "HKI";
                break;
            case "Pengabdian":
                prefix = "PKM";
                break;
            default: // Riset
                prefix = "RST";
                break;
        }
        return generateID(prefix, "tb_project", "project_id");
    }
    
    /**
     * Generate Event ID
     * @return ID dengan format EVT-0001
     */
    public static String generateEventID() {
        return generateID("EVT", "tb_event", "event_id");
    }
    
    /**
     * Generate Archive ID berdasarkan tipe
     * @param archiveType - "Publikasi", "HKI", atau "Pengabdian"
     * @return ID dengan format PUB-0001, ARH-0001, atau ABD-0001
     */
    public static String generateArchiveID(String archiveType) {
        String prefix;
        switch (archiveType) {
            case "HKI":
                prefix = "ARH";
                break;
            case "Pengabdian":
                prefix = "ABD";
                break;
            default: // Publikasi
                prefix = "PUB";
                break;
        }
        return generateID(prefix, "tb_archive", "archive_id");
    }
    
    /**
     * Method internal untuk generate ID dengan query ke database
     */
    private static String generateID(String prefix, String tableName, String columnName) {
        int nextNumber = 1;
        
        // Query untuk mencari ID dengan prefix yang sama dan ambil nomor tertinggi
        String sql = "SELECT " + columnName + " FROM " + tableName + 
                     " WHERE " + columnName + " LIKE ? ORDER BY " + columnName + " DESC LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, prefix + "-%");
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String lastID = rs.getString(1);
                // Extract number from ID (e.g., "RST-0005" -> 5)
                String numberPart = lastID.substring(prefix.length() + 1);
                try {
                    nextNumber = Integer.parseInt(numberPart) + 1;
                } catch (NumberFormatException e) {
                    nextNumber = 1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Format: PREFIX-0001 (4 digit padding)
        return String.format("%s-%04d", prefix, nextNumber);
    }
}
