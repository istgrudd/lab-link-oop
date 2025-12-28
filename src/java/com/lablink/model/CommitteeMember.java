/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public class CommitteeMember {
    private String memberID;
    private String memberName;
    private String roles;

    public CommitteeMember(String memberID, String memberName, String role) {
        this.memberID = memberID;
        this.memberName = memberName;
        this.roles = role;
    }

    public String getMemberID() { return memberID; }
    public String getMemberName() { return memberName; }
    public String getRole() { return roles; }
}
