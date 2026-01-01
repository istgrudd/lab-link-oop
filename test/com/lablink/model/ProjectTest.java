package com.lablink.model;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Test Case untuk kelas model Project.
 * Tujuannya untuk memverifikasi integritas data setelah objek dibuat.
 */
public class ProjectTest {

    @Test
    public void testProjectCreationAndGetters() {
        System.out.println("--- Running test: testProjectCreationAndGetters ---");

        // 1. Setup: Siapkan data dummy
        String id = "P001";
        String name = "Sistem Rekomendasi AI";
        String desc = "Deskripsi proyek AI.";
        String status = "Ongoing";
        String type = "Riset";
        String division = "AI & Machine Learning";
        String leaderID = "M001";
        String leaderName = "Dr. Budi";
        String startDate = "2024-01-01";
        String endDate = "2024-12-31";

        // 2. Action: Buat objek yang akan dites
        Project project = new Project(id, name, desc, status, type, division, leaderID, leaderName, startDate, endDate);

        // 3. Assertion: Verifikasi semua data sesuai
        assertNotNull("Objek project seharusnya tidak null", project);
        
        // Gunakan assertEquals(pesan, nilai_ekspektasi, nilai_aktual)
        assertEquals("ID Proyek tidak sesuai", id, project.getProjectID());
        assertEquals("Nama Proyek tidak sesuai", name, project.getProjectName());
        assertEquals("Deskripsi tidak sesuai", desc, project.getDescription());
        assertEquals("Status tidak sesuai", status, project.getStatus());
        assertEquals("Tipe Aktivitas tidak sesuai", type, project.getActivityType());
        assertEquals("Divisi tidak sesuai", division, project.getDivision());
        assertEquals("ID Leader tidak sesuai", leaderID, project.getLeaderID());
        assertEquals("Nama Leader tidak sesuai", leaderName, project.getLeaderName());
        assertEquals("Tanggal Mulai tidak sesuai", startDate, project.getStartDate());
        assertEquals("Tanggal Selesai tidak sesuai", endDate, project.getEndDate());
        
        System.out.println(">>> Hasil: Semua getter pada kelas Project mengembalikan nilai yang benar.");
        
        // Tes juga method dari interface IReportable
        String expectedReport = "Proyek: Sistem Rekomendasi AI (Lead: Dr. Budi)";
        assertEquals("Format string laporan tidak sesuai", expectedReport, project.generateReportString());
        
        System.out.println(">>> Hasil: Metode generateReportString() juga berfungsi dengan benar.");
        System.out.println("--- Test finished: testProjectCreationAndGetters ---");
    }
}
