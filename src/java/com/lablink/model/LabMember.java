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
    // Pastikan 3 atribut ini ada:
    protected String username;
    protected String password;
    protected String accessRole;

    // Pastikan Constructor ini menerima 5 parameter:
    public LabMember(String memberID, String name, String username, String password, String accessRole) {
        this.memberID = memberID;
        this.name = name;
        this.username = username;
        this.password = password;
        this.accessRole = accessRole;
    }

    public String getMemberID() { return memberID; }
    public String getName() { return name; }
    public String getAccessRole() { return accessRole; } // Getter ini penting
    public String getPassword() { return password; } // Tambahkan ini juga untuk validasi ganti password nanti

    public abstract int calculateWorkload();
}
