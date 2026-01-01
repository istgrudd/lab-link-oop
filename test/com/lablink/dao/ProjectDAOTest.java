package com.lablink.dao;

import com.lablink.model.Project;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Integration Test untuk ProjectDAO.
 * Tes ini akan berinteraksi langsung dengan database.
 * Pastikan database aktif dan konfigurasi koneksi sudah benar.
 */
public class ProjectDAOTest {

    private ProjectDAO projectDAO;
    private Project testProject;
    private final String TEST_PROJECT_ID = "TEST_PROJ_999";

    /**
     * Method ini berjalan SEBELUM setiap @Test dijalankan.
     * Digunakan untuk setup objek yang dibutuhkan.
     */
    @Before
    public void setUp() {
        System.out.println("--- Running @Before: Setting up test data ---");
        projectDAO = new ProjectDAO();
        testProject = new Project(
            TEST_PROJECT_ID,
            "Proyek Uji Coba",
            "Ini adalah proyek untuk pengujian.",
            "Ongoing",
            "Riset",
            "Testing Division",
            null, // Leader ID bisa null jika diizinkan DB, atau gunakan ID yang valid
            "Test Leader",
            "2024-01-01",
            "2024-12-31"
        );
        // Pastikan tidak ada sisa data tes sebelumnya
        // Ini untuk keamanan jika @After pernah gagal berjalan
        projectDAO.deleteProject(TEST_PROJECT_ID);
    }

    /**
     * Method ini berjalan SETELAH setiap @Test selesai.
     * Digunakan untuk membersihkan data agar tidak mengotori database.
     */
    @After
    public void tearDown() {
        System.out.println("--- Running @After: Tearing down test data ---");
        // Hapus data tes yang mungkin dibuat selama tes berjalan.
        // Dibungkus try-catch agar tidak error jika data sudah terhapus.
        try {
            projectDAO.deleteProject(TEST_PROJECT_ID);
            System.out.println(">>> Hasil: Data tes '" + TEST_PROJECT_ID + "' berhasil dibersihkan.");
        } catch (Exception e) {
            System.err.println("Error during teardown: " + e.getMessage());
        }
    }

    /**
     * Tes ini menguji seluruh siklus hidup (CRUD) dari sebuah proyek.
     */
    @Test
    public void testFullProjectLifecycle() {
        System.out.println("--- Running @Test: testFullProjectLifecycle ---");

        // 1. CREATE
        System.out.println("1. Testing CREATE (addProject)...");
        // Kita gunakan 'null' untuk team members agar tes ini tidak bergantung pada tabel 'tb_member'
        boolean addResult = projectDAO.addProject(testProject, null);
        assertTrue("Gagal menambahkan proyek tes ke database.", addResult);
        System.out.println(">>> CREATE success.");

        // 2. READ
        System.out.println("\n2. Testing READ (getProjectById)...");
        Project retrievedProject = projectDAO.getProjectById(TEST_PROJECT_ID);
        assertNotNull("Proyek yang baru ditambahkan tidak dapat ditemukan.", retrievedProject);
        assertEquals("Nama proyek yang diambil dari DB tidak sesuai.", testProject.getProjectName(), retrievedProject.getProjectName());
        assertEquals("Deskripsi proyek yang diambil dari DB tidak sesuai.", testProject.getDescription(), retrievedProject.getDescription());
        System.out.println(">>> READ success.");

        // 3. UPDATE
        System.out.println("\n3. Testing UPDATE (updateProject)...");
        String updatedName = "Proyek Uji Coba (UPDATED)";
        // Buat objek baru dengan nama yang sudah diupdate untuk dikirim ke DAO
        Project projectToUpdate = new Project(retrievedProject.getProjectID(), updatedName, retrievedProject.getDescription(), retrievedProject.getStatus(), retrievedProject.getActivityType(), retrievedProject.getDivision(), retrievedProject.getLeaderID(), retrievedProject.getLeaderName(), retrievedProject.getStartDate(), retrievedProject.getEndDate());
        boolean updateResult = projectDAO.updateProject(projectToUpdate, null);
        assertTrue("Gagal mengupdate proyek tes.", updateResult);
        System.out.println(">>> UPDATE success.");

        // 4. VERIFY UPDATE
        System.out.println("\n4. Verifying UPDATE...");
        Project updatedProject = projectDAO.getProjectById(TEST_PROJECT_ID);
        assertNotNull("Proyek yang diupdate tidak dapat ditemukan.", updatedProject);
        assertEquals("Nama proyek tidak terupdate di database.", updatedName, updatedProject.getProjectName());
        System.out.println(">>> VERIFY UPDATE success.");

        // 5. DELETE
        System.out.println("\n5. Testing DELETE (deleteProject)...");
        boolean deleteResult = projectDAO.deleteProject(TEST_PROJECT_ID);
        assertTrue("Gagal menghapus proyek tes.", deleteResult);
        System.out.println(">>> DELETE success.");
        
        // 6. VERIFY DELETE
        System.out.println("\n6. Verifying DELETE...");
        Project deletedProject = projectDAO.getProjectById(TEST_PROJECT_ID);
        assertNull("Proyek seharusnya sudah terhapus dari database.", deletedProject);
        System.out.println(">>> VERIFY DELETE success.");
        
        System.out.println("--- Test finished: testFullProjectLifecycle ---");
    }
}
