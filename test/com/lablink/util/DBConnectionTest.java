package com.lablink.util;

import java.sql.Connection;
import java.sql.SQLException;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Ini adalah contoh Test Case untuk kelas DBConnection.
 * Tujuannya adalah untuk memverifikasi apakah aplikasi bisa terhubung ke database.
 */
public class DBConnectionTest {

    @Test
    public void testGetConnection() {
        System.out.println("--- Running test: testGetConnection ---");
        Connection conn = null;
        try {
            // 1. Panggil method yang ingin dites
            conn = DBConnection.getConnection();
            
            // 2. Buat Asersi (Pernyataan)
            // Tes akan GAGAL jika koneksi yang dikembalikan adalah null.
            assertNotNull("Koneksi database tidak boleh null. Pastikan database aktif dan konfigurasi di DBConnection.java sudah benar.", conn);
            
            // Tes akan GAGAL jika koneksi ternyata sudah tertutup.
            assertFalse("Koneksi database seharusnya dalam keadaan terbuka.", conn.isClosed());
            
            System.out.println(">>> Hasil: Koneksi database BERHASIL dibuat dan terbuka.");
            
        } catch (SQLException e) {
            // Jika ada error SQL, paksa tes untuk GAGAL dan tampilkan pesan.
            fail("Terjadi SQLException saat mencoba konek ke database: " + e.getMessage());
        } finally {
            // 3. Cleanup
            // Selalu tutup koneksi setelah tes selesai untuk melepas sumber daya.
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("Koneksi database berhasil ditutup.");
                } catch (SQLException e) {
                    // Di dalam tes, kita bisa abaikan error saat menutup koneksi.
                }
            }
        }
        System.out.println("--- Test finished: testGetConnection ---");
    }
}
