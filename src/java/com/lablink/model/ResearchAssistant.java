package com.lablink.model;

public class ResearchAssistant extends LabMember {
    private String expertDivision; // e.g., Big Data
    private String department;     // e.g., Internal
    private String roleTitle;      // e.g., Head of Division

    public ResearchAssistant(String id, String name, String division, String dept, String role, 
                             String username, String password, String accessRole) {
        // Pass login data to superclass
        super(id, name, username, password, accessRole);
        this.expertDivision = division;
        this.department = dept;
        this.roleTitle = role;
    }

    // Polymorphism Implementation
    @Override
    public int calculateWorkload() {
        // Simple logic: base workload 10 hours + bonus if they have a position
        int baseLoad = 10;
        if (roleTitle != null && !roleTitle.equalsIgnoreCase("Staff")) {
            baseLoad += 5;
        }
        return baseLoad;
    }

    // Getter and Setter
    public String getExpertDivision() { return expertDivision; }
    public String getDepartment() { return department; }
    public String getRoleTitle() { return roleTitle; }
}
