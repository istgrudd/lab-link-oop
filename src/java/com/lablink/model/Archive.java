/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public class Archive {
    private String archiveID;
    private String projectID;
    private String projectName; // Helper untuk display
    private String title;
    private String type;        // Publikasi / HKI
    private String publishLocation; // Nama Jurnal / HKI
    private String referenceNumber; // DOI / No Reg
    private String publishDate;
    
    // Kita ambil Leader dari Project sebagai Penulis Utama
    private String authorName; 

    public Archive(String archiveID, String projectID, String projectName, String title, 
                   String type, String location, String refNum, String date, String authorName) {
        this.archiveID = archiveID;
        this.projectID = projectID;
        this.projectName = projectName;
        this.title = title;
        this.type = type;
        this.publishLocation = location;
        this.referenceNumber = refNum;
        this.publishDate = date;
        this.authorName = authorName;
    }

    // Getter
    public String getArchiveID() { return archiveID; }
    public String getProjectID() { return projectID; }
    public String getProjectName() { return projectName; }
    public String getTitle() { return title; }
    public String getType() { return type; }
    public String getPublishLocation() { return publishLocation; }
    public String getReferenceNumber() { return referenceNumber; }
    public String getPublishDate() { return publishDate; }
    public String getAuthorName() { return authorName; }
}
