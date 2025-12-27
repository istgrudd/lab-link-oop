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
    
    // List untuk menampung nama/anggota tim (Opsional, untuk display di view)
    private List<String> teamMembers = new ArrayList<>();
    // List untuk menampung ID anggota tim (untuk logic edit/checklist)
    private List<String> teamMemberIDs = new ArrayList<>();

    public Project(String id, String name, String desc, String status, String type, String division, String leaderID, String leaderName, String startDate, String endDate) {
        this.projectID = id;
        this.projectName = name;
        this.description = desc; // [BARU]
        this.status = status;
        this.activityType = type;
        this.division = division;
        this.leaderID = leaderID;
        this.leaderName = leaderName;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Implementasi Interface IReportable 
    @Override
    public String generateReportString() {
        return "Proyek: " + projectName + " (Lead: " + leaderName + ")";
    }

    // Getter Setter
    public String getDescription() { return description; } // [BARU]
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
    public List<String> getTeamMemberIDs() { return teamMemberIDs; } // [BARU]
    public void addTeamMember(String name) { this.teamMembers.add(name); }
}
