package com.lablink.model;

import java.time.LocalDateTime;

/**
 * Model untuk Activity Log / Audit Trail
 */
public class ActivityLog {
    private String logID;
    private String userID;
    private String userName;
    private String action; // CREATE, UPDATE, DELETE, LOGIN, LOGOUT
    private String targetType; // PROJECT, MEMBER, EVENT, AUTH
    private String targetID;
    private String targetName;
    private String description;
    private String ipAddress;
    private LocalDateTime createdAt;

    public ActivityLog() {
        this.createdAt = LocalDateTime.now();
    }

    public ActivityLog(String logID, String userID, String userName, String action,
            String targetType, String targetID, String targetName, String description) {
        this.logID = logID;
        this.userID = userID;
        this.userName = userName;
        this.action = action;
        this.targetType = targetType;
        this.targetID = targetID;
        this.targetName = targetName;
        this.description = description;
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public String getLogID() {
        return logID;
    }

    public void setLogID(String logID) {
        this.logID = logID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getTargetID() {
        return targetID;
    }

    public void setTargetID(String targetID) {
        this.targetID = targetID;
    }

    public String getTargetName() {
        return targetName;
    }

    public void setTargetName(String targetName) {
        this.targetName = targetName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Helper method untuk format waktu
    public String getFormattedTime() {
        if (createdAt == null)
            return "-";
        return createdAt.getDayOfMonth() + "/" + createdAt.getMonthValue() + "/" + createdAt.getYear()
                + " " + String.format("%02d:%02d", createdAt.getHour(), createdAt.getMinute());
    }

    // Helper method untuk icon aksi
    public String getActionIcon() {
        switch (action) {
            case "CREATE":
                return "fa-plus-circle";
            case "UPDATE":
                return "fa-edit";
            case "DELETE":
                return "fa-trash";
            case "LOGIN":
                return "fa-sign-in-alt";
            case "LOGOUT":
                return "fa-sign-out-alt";
            default:
                return "fa-info-circle";
        }
    }

    // Helper method untuk badge color
    public String getActionBadgeClass() {
        switch (action) {
            case "CREATE":
                return "badge-success";
            case "UPDATE":
                return "badge-warning";
            case "DELETE":
                return "badge-danger";
            case "LOGIN":
                return "badge-info";
            case "LOGOUT":
                return "badge-secondary";
            default:
                return "badge-primary";
        }
    }
}
