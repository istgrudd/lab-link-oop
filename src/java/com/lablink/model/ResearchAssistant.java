/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.lablink.model;

/**
 *
 * @author Rudi Firdaus
 */
public class ResearchAssistant extends LabMember {
    private String expertDivision; // Misal: Big Data
    private String department;     // Misal: Internal
    private String roleTitle;      // Misal: Head of Division

    public ResearchAssistant(String id, String name, String division, String dept, String role) {
        super(id, name);
        this.expertDivision = division;
        this.department = dept;
        this.roleTitle = role;
    }

    // Implementasi Polymorphism [cite: 82]
    @Override
    public int calculateWorkload() {
        // Logika sederhana: workload dasar 10 jam + bonus jika punya jabatan
        int baseLoad = 10;
        if (!roleTitle.equalsIgnoreCase("Staff")) {
            baseLoad += 5;
        }
        return baseLoad;
    }

    // Getter Setter
    public String getExpertDivision() { return expertDivision; }
    public String getDepartment() { return department; }
    public String getRoleTitle() { return roleTitle; }
}
