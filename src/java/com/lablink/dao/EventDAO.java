package com.lablink.dao;
import com.lablink.model.LabEvent;
import com.lablink.model.CommitteeMember;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    // Fitur Tambah Event
    public boolean addEvent(LabEvent e) {
        String sql = "INSERT INTO tb_event (event_id, event_name, event_date, pic_id, description) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, e.getEventID());
            stmt.setString(2, e.getEventName());
            stmt.setString(3, e.getEventDate());
            stmt.setString(4, e.getPicID());
            stmt.setString(5, e.getDescription());
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // Fitur Ambil Semua Event
    public List<LabEvent> getAllEvents() {
        List<LabEvent> list = new ArrayList<>();
        String sql = "SELECT e.*, m.name as pic_name FROM tb_event e " +
                     "LEFT JOIN tb_member m ON e.pic_id = m.member_id " +
                     "ORDER BY e.event_date DESC"; // Sort by the newest

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                LabEvent e = new LabEvent(
                    rs.getString("event_id"),
                    rs.getString("event_name"),
                    rs.getString("event_date"), // Make sure this is the 3rd order (Date)
                    rs.getString("pic_id"),
                    rs.getString("pic_name"),   // Make sure this is the 5th order (PIC Name)
                    rs.getString("description") // Make sure this is the 6th order (Description)
                );
                e.getCommitteeNames().addAll(getCommitteeMembers(e.getEventID()));
                list.add(e);
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
        return list;
    }
    
    // Fitur Ambil Event Berdasarkan ID
    public LabEvent getEventById(String id) {
        String sql = "SELECT * FROM tb_event WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if(rs.next()) {
                return new LabEvent(
                    rs.getString("event_id"), 
                    rs.getString("event_name"), 
                    rs.getString("event_date"), 
                    rs.getString("pic_id"), 
                    "",
                    rs.getString("description")
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // Fitur Update Event
    public boolean updateEvent(LabEvent e) {
        String sql = "UPDATE tb_event SET event_name=?, event_date=?, pic_id=?, description=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, e.getEventName());
            stmt.setString(2, e.getEventDate());
            stmt.setString(3, e.getPicID());
            stmt.setString(4, e.getDescription());
            stmt.setString(5, e.getEventID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }

    // Fitur Tambah Anggota Panitia
    public boolean addCommitteeMember(String eventID, String memberID, String role) {
        // The query is adjusted to the role column
        String sql = "INSERT INTO tb_event_committee (event_id, member_id, committee_role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            stmt.setString(2, memberID);
            stmt.setString(3, role);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }

    // Fitur Ambil Anggota Panitia
    private List<String> getCommitteeMembers(String eventID) {
        List<String> names = new ArrayList<>();
        // Get member name AND their committee role
        String sql = "SELECT m.name, ec.committee_role FROM tb_member m " +
                     "JOIN tb_event_committee ec ON m.member_id = ec.member_id " +
                     "WHERE ec.event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                String nama = rs.getString("name");
                String role = rs.getString("committee_role");
                
                // Combined format for easy display in the View
                // Example output: "Budi (Div. Acara)"
                if (role != null && !role.isEmpty()) {
                    names.add(nama + " (" + role + ")"); 
                } else {
                    names.add(nama);
                }
            }
        } catch (SQLException e) {}
        return names;
    }
    
    // Fitur Ambil Detail Panitia
    public List<CommitteeMember> getCommitteeDetails(String eventID) {
        List<CommitteeMember> list = new ArrayList<>();
        String sql = "SELECT m.member_id, m.name, ec.committee_role FROM tb_member m " +
                     "JOIN tb_event_committee ec ON m.member_id = ec.member_id " +
                     "WHERE ec.event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            ResultSet rs = stmt.executeQuery();
            while(rs.next()) {
                list.add(new CommitteeMember(
                    rs.getString("member_id"),
                    rs.getString("name"),
                    rs.getString("committee_role")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Fitur Update Role Panitia
    public boolean updateCommitteeRole(String eventID, String memberID, String newRole) {
        String sql = "UPDATE tb_event_committee SET committee_role = ? WHERE event_id = ? AND member_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setString(2, eventID);
            stmt.setString(3, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }

    // Fitur Hapus Panitia
    public boolean removeCommitteeMember(String eventID, String memberID) {
        String sql = "DELETE FROM tb_event_committee WHERE event_id = ? AND member_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            stmt.setString(2, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }
    
    // Fitur Hapus Event
    public boolean deleteEvent(String id) {
        String sql = "DELETE FROM tb_event WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}
