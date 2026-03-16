package com.eventapp.model;

public class UserRegistrationStat {
    private String date;
    private String role;
    private Long registrations;

    public UserRegistrationStat() {
    }

    public UserRegistrationStat(String date, Long registrations) {
        this.date = date;
        this.registrations = registrations;
    }

    public UserRegistrationStat(String date, String role, Long registrations) {
        this.date = date;
        this.role = role;
        this.registrations = registrations;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Long getRegistrations() {
        return registrations;
    }

    public void setRegistrations(Long registrations) {
        this.registrations = registrations;
    }
}
