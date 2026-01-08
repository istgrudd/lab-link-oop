package com.lablink.model;
import java.util.ArrayList;
import java.util.List;

public class LabEvent implements IReportable {
    private String eventID;
    private String eventName;
    private String eventDate; // Format: YYYY-MM-DD
    private String picID;
    private String picName;   // Helper to display the PIC name directly
    private String description;
    
    private List<String> committeeNames = new ArrayList<>();

    public LabEvent(String id, String name, String date, String picID, String picName, String description) {
        this.eventID = id;
        this.eventName = name;
        this.eventDate = date;
        this.picID = picID;
        this.picName = picName;
        this.description = description;
    }

    @Override
    public String generateReportString() {
        return "Kegiatan: " + eventName + " (" + eventDate + ") - PIC: " + picName;
    }

    // Getter and Setter
    public String getEventID() { return eventID; }
    public String getEventName() { return eventName; }
    public String getEventDate() { return eventDate; }
    public String getPicID() { return picID; }
    public String getPicName() { return picName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public List<String> getCommitteeNames() { return committeeNames; }
}
