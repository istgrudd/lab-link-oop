package com.lablink.model;

public class CommitteeMember {
    private String memberID;
    private String memberName;
    private String roles;

    public CommitteeMember(String memberID, String memberName, String role) {
        this.memberID = memberID;
        this.memberName = memberName;
        this.roles = role;
    }

    // Getter
    public String getMemberID() { return memberID; }
    public String getMemberName() { return memberName; }
    public String getRole() { return roles; }
}
