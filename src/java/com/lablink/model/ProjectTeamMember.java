/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public class ProjectTeamMember {
    private String memberID;
    private String memberName;
    // Saat ini belum ada role spesifik di proyek, jadi cukup ID & Nama

    public ProjectTeamMember(String memberID, String memberName) {
        this.memberID = memberID;
        this.memberName = memberName;
    }

    public String getMemberID() { return memberID; }
    public String getMemberName() { return memberName; }
}
