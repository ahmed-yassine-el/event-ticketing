package com.eventapp.model;

import java.math.BigDecimal;

public class StatsSummary {
    private Long totalUsers;
    private Long totalEvents;
    private Long totalTickets;
    private BigDecimal totalRevenue;

    public StatsSummary() {
    }

    public StatsSummary(Long totalUsers, Long totalEvents, Long totalTickets, BigDecimal totalRevenue) {
        this.totalUsers = totalUsers;
        this.totalEvents = totalEvents;
        this.totalTickets = totalTickets;
        this.totalRevenue = totalRevenue;
    }

    public Long getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(Long totalUsers) {
        this.totalUsers = totalUsers;
    }

    public Long getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(Long totalEvents) {
        this.totalEvents = totalEvents;
    }

    public Long getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(Long totalTickets) {
        this.totalTickets = totalTickets;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
