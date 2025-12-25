/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public abstract class LabMember {
    protected String memberID;
    protected String name;

    public LabMember(String memberID, String name) {
        this.memberID = memberID;
        this.name = name;
    }

    // Getter Setter standar
    public String getMemberID() { return memberID; }
    public String getName() { return name; }

    // Abstract method sesuai proposal 
    public abstract int calculateWorkload();
}
