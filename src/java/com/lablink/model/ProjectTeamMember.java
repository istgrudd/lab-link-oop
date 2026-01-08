package com.lablink.model;

public class ProjectTeamMember {
    private String memberID;
    private String memberName;
    // Currently there is no specific role in the project, so ID & Name are sufficient

    public ProjectTeamMember(String memberID, String memberName) {
        this.memberID = memberID;
        this.memberName = memberName;
    }

    // Getter
    public String getMemberID() { return memberID; }
    public String getMemberName() { return memberName; }
}
