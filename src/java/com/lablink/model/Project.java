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
    private String status;      // Ongoing, Completed
    private String activityType; // Riset, HKI
    private String division;
    private String leaderID;
    private String leaderName;
    
    private String startDate;
    private String endDate;
    
    // List untuk menampung nama/anggota tim (Opsional, untuk display di view)
    private List<String> teamMembers = new ArrayList<>();

    public Project(String id, String name, String status, String type, String division, String leaderID, String leaderName, String startDate, String endDate) {
        this.projectID = id;
        this.projectName = name;
        this.status = status;
        this.activityType = type;
        this.division = division;
        this.leaderID = leaderID;
        this.leaderName = leaderName;
        // [BARU]
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Implementasi Interface IReportable 
    @Override
    public String generateReportString() {
        return "Proyek: " + projectName + " (Lead: " + leaderName + ")";
    }

    // Getter Setter
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
    public void addTeamMember(String name) { this.teamMembers.add(name); }
}
