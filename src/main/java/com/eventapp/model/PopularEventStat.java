package com.eventapp.model;

public class PopularEventStat {
    private Long eventId;
    private String title;
    private Long soldTickets;

    public PopularEventStat() {
    }

    public PopularEventStat(Long eventId, String title, Long soldTickets) {
        this.eventId = eventId;
        this.title = title;
        this.soldTickets = soldTickets;
    }

    public Long getEventId() {
        return eventId;
    }

    public void setEventId(Long eventId) {
        this.eventId = eventId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Long getSoldTickets() {
        return soldTickets;
    }

    public void setSoldTickets(Long soldTickets) {
        this.soldTickets = soldTickets;
    }
}
