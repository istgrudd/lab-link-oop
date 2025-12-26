/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public class AgendaItem {
    private String date;        // Tanggal (Deadline Proyek atau Tanggal Event)
    private String title;       // Nama Proyek / Kegiatan
    private String category;    // "Proyek" atau "Event"
    private String info;        // Info tambahan (Misal: "Deadline" atau nama PIC)
    private String badgeColor;  // Warna badge untuk tampilan (success/warning)

    public AgendaItem(String date, String title, String category, String info, String badgeColor) {
        this.date = date;
        this.title = title;
        this.category = category;
        this.info = info;
        this.badgeColor = badgeColor;
    }

    public String getDate() { return date; }
    public String getTitle() { return title; }
    public String getCategory() { return category; }
    public String getInfo() { return info; }
    public String getBadgeColor() { return badgeColor; }
}