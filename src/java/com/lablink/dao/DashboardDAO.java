package com.lablink.dao;

import com.lablink.model.AgendaItem;
import com.lablink.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DashboardDAO {

    // Fitur Ambil Agenda Mendatang
    public List<AgendaItem> getUpcomingAgenda() {
        List<AgendaItem> list = new ArrayList<>();
        
        // Get the 7 closest agendas from today
        String sql = "SELECT * FROM (" +
                     // 1. Get Project Deadlines (Ongoing only)
                     "  SELECT end_date as agenda_date, project_name as title, 'Proyek' as category, 'Tenggat Waktu' as info, 'warning' as color " +
                     "  FROM tb_project WHERE status = 'Ongoing' AND end_date >= CURDATE() " +
                     " UNION ALL " +
                     // 2. Get Event Schedules
                     "  SELECT event_date as agenda_date, event_name as title, 'Event' as category, 'Kegiatan Eksternal' as info, 'success' as color " +
                     "  FROM tb_event WHERE event_date >= CURDATE() " +
                     ") AS combined_agenda " +
                     "ORDER BY agenda_date ASC LIMIT 7";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                list.add(new AgendaItem(
                    rs.getString("agenda_date"),
                    rs.getString("title"),
                    rs.getString("category"),
                    rs.getString("info"),
                    rs.getString("color")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
