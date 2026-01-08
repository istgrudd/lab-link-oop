package com.lablink.model;

public class AgendaItem {
    // Date (Project Deadline or Event Date)
    private String date;
    // Project Name / Activity
    private String title;
    // "Project" or "Event"
    private String category;
    // Additional Info (e.g., "Deadline" or PIC name)
    private String info;
    // Badge color for display (success/warning)
    private String badgeColor;

    public AgendaItem(String date, String title, String category, String info, String badgeColor) {
        this.date = date;
        this.title = title;
        this.category = category;
        this.info = info;
        this.badgeColor = badgeColor;
    }

    // Getter
    public String getDate() { return date; }
    public String getTitle() { return title; }
    public String getCategory() { return category; }
    public String getInfo() { return info; }
    public String getBadgeColor() { return badgeColor; }
}