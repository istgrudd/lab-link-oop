package com.lablink.dao;

import com.lablink.model.ActivityLog;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * DAO untuk Activity Log / Audit Trail
 */
public class ActivityLogDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    /**
     * Tambah log aktivitas baru
     */
    public void addLog(ActivityLog log) {
        String sql = "INSERT INTO tb_activity_log (log_id, user_id, user_name, action, target_type, target_id, target_name, description, ip_address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                String logId = "LOG-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                stmt.setString(1, logId);
                stmt.setString(2, log.getUserID());
                stmt.setString(3, log.getUserName());
                stmt.setString(4, log.getAction());
                stmt.setString(5, log.getTargetType());
                stmt.setString(6, log.getTargetID());
                stmt.setString(7, log.getTargetName());
                stmt.setString(8, log.getDescription());
                stmt.setString(9, log.getIpAddress());

                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Helper method untuk logging dari controller
     */
    public void log(String userID, String userName, String action, String targetType,
            String targetID, String targetName, String description) {
        ActivityLog log = new ActivityLog();
        log.setUserID(userID);
        log.setUserName(userName);
        log.setAction(action);
        log.setTargetType(targetType);
        log.setTargetID(targetID);
        log.setTargetName(targetName);
        log.setDescription(description);
        addLog(log);
    }

    /**
     * Ambil semua log (sorted by newest first)
     */
    public List<ActivityLog> getAllLogs() {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM tb_activity_log ORDER BY created_at DESC LIMIT 100";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql)) {

                while (rs.next()) {
                    logs.add(mapResultSet(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * Ambil log terbaru dengan limit
     */
    public List<ActivityLog> getRecentLogs(int limit) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM tb_activity_log ORDER BY created_at DESC LIMIT ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, limit);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        logs.add(mapResultSet(rs));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * Ambil log berdasarkan user
     */
    public List<ActivityLog> getLogsByUser(String userID) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM tb_activity_log WHERE user_id = ? ORDER BY created_at DESC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, userID);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        logs.add(mapResultSet(rs));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    /**
     * Ambil log berdasarkan tipe target
     */
    public List<ActivityLog> getLogsByTargetType(String targetType) {
        List<ActivityLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM tb_activity_log WHERE target_type = ? ORDER BY created_at DESC";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, targetType);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        logs.add(mapResultSet(rs));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }

    private ActivityLog mapResultSet(ResultSet rs) throws SQLException {
        ActivityLog log = new ActivityLog();
        log.setLogID(rs.getString("log_id"));
        log.setUserID(rs.getString("user_id"));
        log.setUserName(rs.getString("user_name"));
        log.setAction(rs.getString("action"));
        log.setTargetType(rs.getString("target_type"));
        log.setTargetID(rs.getString("target_id"));
        log.setTargetName(rs.getString("target_name"));
        log.setDescription(rs.getString("description"));
        log.setIpAddress(rs.getString("ip_address"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            log.setCreatedAt(ts.toLocalDateTime());
        }

        return log;
    }
}
