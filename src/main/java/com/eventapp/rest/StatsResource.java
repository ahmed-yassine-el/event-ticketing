package com.eventapp.rest;

import com.eventapp.model.StatsSummary;
import com.eventapp.service.StatisticsService;

import jakarta.ejb.EJB;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/stats")
@Produces(MediaType.APPLICATION_JSON)
public class StatsResource {

    @EJB
    private StatisticsService statisticsService;

    @GET
    @Path("/summary")
    public StatsSummary getSummary() {
        return statisticsService.getSummary();
    }
}
