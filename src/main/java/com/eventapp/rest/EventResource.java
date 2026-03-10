package com.eventapp.rest;

import com.eventapp.model.Event;
import com.eventapp.service.EventService;

import jakarta.ejb.EJB;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/events")
@Produces(MediaType.APPLICATION_JSON)
public class EventResource {

    @EJB
    private EventService eventService;

    @GET
    public List<EventResponse> getApprovedEvents() {
        return eventService.getAllApprovedEvents().stream()
                .map(this::toResponse)
                .toList();
    }

    @GET
    @Path("/{id}")
    public Response getEventById(@PathParam("id") Long id) {
        Event event = eventService.getEventById(id);
        if (event == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("Event not found")
                    .build();
        }
        return Response.ok(toResponse(event)).build();
    }

    @GET
    @Path("/search")
    public List<EventResponse> searchEvents(@QueryParam("q") String q) {
        String query = q == null ? "" : q.trim();
        return eventService.searchEvents(query, query, null).stream()
                .map(this::toResponse)
                .toList();
    }

    private EventResponse toResponse(Event event) {
        EventResponse response = new EventResponse();
        response.setId(event.getId());
        response.setTitle(event.getTitle());
        response.setDescription(event.getDescription());
        response.setCategory(event.getCategory());
        response.setLocation(event.getLocation());
        response.setEventDate(event.getEventDate());
        response.setAvailableTickets(event.getAvailableTickets());
        response.setPrice(event.getPrice());
        response.setStatus(event.getStatus().name());
        response.setOrganizerName(event.getOrganizer().getName());
        return response;
    }
}
