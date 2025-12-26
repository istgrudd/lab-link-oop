/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Rudi Firdaus
 */
public class LabEvent implements IReportable {
    private String eventID;
    private String eventName;
    private String eventDate; // Format: YYYY-MM-DD
    private String picID;
    private String picName;   // Helper untuk menampilkan nama PIC langsung
    
    private List<String> committeeNames = new ArrayList<>();

    public LabEvent(String id, String name, String date, String picID, String picName) {
        this.eventID = id;
        this.eventName = name;
        this.eventDate = date;
        this.picID = picID;
        this.picName = picName;
    }

    @Override
    public String generateReportString() {
        return "Kegiatan: " + eventName + " (" + eventDate + ") - PIC: " + picName;
    }

    // Getter Setter
    public String getEventID() { return eventID; }
    public String getEventName() { return eventName; }
    public String getEventDate() { return eventDate; }
    public String getPicID() { return picID; }
    public String getPicName() { return picName; }
    
    public List<String> getCommitteeNames() { return committeeNames; }
}
