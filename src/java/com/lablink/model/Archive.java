package com.lablink.model;

public class Archive {
    private String archiveID;
    private String projectID;
    private String projectName; // Helper for display
    private String title;
    private String type;        // Publication / IPR
    private String publishLocation; // Journal Name / IPR
    private String referenceNumber; // DOI / Reg No
    private String publishDate;
    
    // We take the Leader from the Project as the Main Author
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
