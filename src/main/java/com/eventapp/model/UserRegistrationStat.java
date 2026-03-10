package com.eventapp.model;

public class UserRegistrationStat {
    private String date;
    private Long registrations;

    public UserRegistrationStat() {
    }

    public UserRegistrationStat(String date, Long registrations) {
        this.date = date;
        this.registrations = registrations;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Long getRegistrations() {
        return registrations;
    }

    public void setRegistrations(Long registrations) {
        this.registrations = registrations;
    }
}
