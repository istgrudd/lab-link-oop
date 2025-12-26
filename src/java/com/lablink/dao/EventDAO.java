/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.dao;
import com.lablink.model.LabEvent;
import com.lablink.model.CommitteeMember;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rudi Firdaus
 */
public class EventDAO {

    // CREATE
    public boolean addEvent(LabEvent e) {
        String sql = "INSERT INTO tb_event (event_id, event_name, event_date, pic_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, e.getEventID());
            stmt.setString(2, e.getEventName());
            stmt.setString(3, e.getEventDate());
            stmt.setString(4, e.getPicID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
    }

    // READ ALL (Join dengan tabel member untuk dapat nama PIC)
    public List<LabEvent> getAllEvents() {
        List<LabEvent> list = new ArrayList<>();
        String sql = "SELECT e.*, m.name as pic_name FROM tb_event e " +
                     "LEFT JOIN tb_member m ON e.pic_id = m.member_id " +
                     "ORDER BY e.event_date DESC"; // Urutkan dari yang terbaru

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                LabEvent e = new LabEvent(
                    rs.getString("event_id"),
                    rs.getString("event_name"),
                    rs.getString("event_date"),
                    rs.getString("pic_id"),
                    rs.getString("pic_name") // Nama PIC dari hasil Join
                );
                e.getCommitteeNames().addAll(getCommitteeMembers(e.getEventID()));
                list.add(e);
            }
        } catch (SQLException ex) { ex.printStackTrace(); }
        return list;
    }
    
    // READ ONE (Untuk Edit)
    public LabEvent getEventById(String id) {
        String sql = "SELECT * FROM tb_event WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if(rs.next()) {
                // Return object (PIC Name bisa null/tidak diambil di sini tidak masalah utk form edit)
                return new LabEvent(rs.getString("event_id"), rs.getString("event_name"), rs.getString("event_date"), rs.getString("pic_id"), "");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // UPDATE
    public boolean updateEvent(LabEvent e) {
        String sql = "UPDATE tb_event SET event_name=?, event_date=?, pic_id=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, e.getEventName());
            stmt.setString(2, e.getEventDate());
            stmt.setString(3, e.getPicID());
            stmt.setString(4, e.getEventID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }

    // 1. UPDATE: Tambahkan parameter 'role'
    public boolean addCommitteeMember(String eventID, String memberID, String role) {
        // Query disesuaikan ada kolom role
        String sql = "INSERT INTO tb_event_committee (event_id, member_id, committee_role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            stmt.setString(2, memberID);
            stmt.setString(3, role); // Set Role
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }

    // 2. UPDATE: Tampilkan Nama beserta Rolenya
    private List<String> getCommitteeMembers(String eventID) {
        List<String> names = new ArrayList<>();
        // Ambil nama member DAN role panitianya
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
                
                // Format gabungan agar mudah ditampilkan di View
                // Contoh output: "Budi (Div. Acara)"
                if (role != null && !role.isEmpty()) {
                    names.add(nama + " (" + role + ")"); 
                } else {
                    names.add(nama);
                }
            }
        } catch (SQLException e) {}
        return names;
    }
    
    // [BARU] Ambil Detail Panitia untuk Halaman Edit
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

    // [BARU] Update Role Panitia
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

    // [BARU] Hapus Panitia
    public boolean removeCommitteeMember(String eventID, String memberID) {
        String sql = "DELETE FROM tb_event_committee WHERE event_id = ? AND member_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, eventID);
            stmt.setString(2, memberID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException ex) { return false; }
    }
}
