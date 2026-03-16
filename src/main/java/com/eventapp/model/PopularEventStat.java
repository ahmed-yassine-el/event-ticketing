package com.eventapp.model;

import java.math.BigDecimal;

public class PopularEventStat {
    private Long eventId;
    private String title;
    private String category;
    private Integer totalTickets;
    private Long soldTickets;
    private BigDecimal revenue;

    public PopularEventStat() {
    }

    public PopularEventStat(Long eventId, String title, Long soldTickets) {
        this.eventId = eventId;
        this.title = title;
        this.soldTickets = soldTickets;
        this.totalTickets = 0;
        this.revenue = BigDecimal.ZERO;
    }

    public PopularEventStat(Long eventId, String title, String category, Integer totalTickets, Long soldTickets, BigDecimal revenue) {
        this.eventId = eventId;
        this.title = title;
        this.category = category;
        this.totalTickets = totalTickets;
        this.soldTickets = soldTickets;
        this.revenue = revenue;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Integer getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(Integer totalTickets) {
        this.totalTickets = totalTickets;
    }

    public Long getSoldTickets() {
        return soldTickets;
    }

    public void setSoldTickets(Long soldTickets) {
        this.soldTickets = soldTickets;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }
}
