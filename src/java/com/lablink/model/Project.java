package com.lablink.model;

import java.util.ArrayList;
import java.util.List;

public class Project implements IReportable {
    private String projectID;
    private String projectName;
    private String description;
    private String status;      // Ongoing, Completed
    private String activityType; // Riset, HKI
    private String division;
    private String leaderID;
    private String leaderName;
    
    private String startDate;
    private String endDate;
    
    // List to hold team member names (Optional, for display in view)
    private List<String> teamMembers = new ArrayList<>();
    // List to hold team member IDs (for edit/checklist logic)
    private List<String> teamMemberIDs = new ArrayList<>();

    public Project(String id, String name, String desc, String status, String type, String division, String leaderID, String leaderName, String startDate, String endDate) {
        this.projectID = id;
        this.projectName = name;
        this.description = desc;
        this.status = status;
        this.activityType = type;
        this.division = division;
        this.leaderID = leaderID;
        this.leaderName = leaderName;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Implementation of IReportable Interface
    @Override
    public String generateReportString() {
        return "Proyek: " + projectName + " (Lead: " + leaderName + ")";
    }

    // Getter and Setter
    public String getDescription() { return description; }
    public String getProjectID() { return projectID; }
    public String getProjectName() { return projectName; }
    public String getStatus() { return status; }
    public String getActivityType() { return activityType; }
    public String getDivision() { return division; }
    public String getLeaderID() { return leaderID; }
    public String getLeaderName() { return leaderName; }
    
    public String getStartDate() { return startDate; }
    public String getEndDate() { return endDate; }
    
    public List<String> getTeamMembers() { return teamMembers; }
    public List<String> getTeamMemberIDs() { return teamMemberIDs; }
    public void addTeamMember(String name) { this.teamMembers.add(name); }
}
