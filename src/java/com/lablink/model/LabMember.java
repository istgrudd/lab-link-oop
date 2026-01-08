package com.lablink.model;

public abstract class LabMember {
    protected String memberID;
    protected String name;
    // Make sure these 3 attributes exist:
    protected String username;
    protected String password;
    protected String accessRole;

    // Make sure this Constructor accepts 5 parameters:
    public LabMember(String memberID, String name, String username, String password, String accessRole) {
        this.memberID = memberID;
        this.name = name;
        this.username = username;
        this.password = password;
        this.accessRole = accessRole;
    }

    // Getter
    public String getMemberID() { return memberID; }
    public String getName() { return name; }
    public String getAccessRole() { return accessRole; } // This getter is important
    public String getPassword() { return password; } // Add this also for password change validation later

    public abstract int calculateWorkload();
}
