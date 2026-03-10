package com.eventapp.rest;

import com.eventapp.model.Ticket;
import com.eventapp.model.TicketPurchaseRequest;
import com.eventapp.service.TicketService;

import jakarta.ejb.EJB;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.List;

@Path("/tickets")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class TicketResource {

    @EJB
    private TicketService ticketService;

    @POST
    @Path("/purchase")
    public Response purchaseTicket(TicketPurchaseRequest request) {
        if (request == null || request.getEventId() == null || request.getParticipantId() == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("eventId and participantId are required").build();
        }

        try {
            Ticket ticket = ticketService.purchaseTicket(request.getParticipantId(), request.getEventId());
            ticketService.generateQRCode(ticket.getId());
            return Response.status(Response.Status.CREATED).entity(toResponse(ticketService.getTicketById(ticket.getId()))).build();
        } catch (Exception ex) {
            return Response.status(Response.Status.BAD_REQUEST).entity(ex.getMessage()).build();
        }
    }

    @GET
    @Path("/{participantId}")
    public List<TicketResponse> getTickets(@PathParam("participantId") Long participantId) {
        return ticketService.getTicketsByParticipant(participantId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @DELETE
    @Path("/{id}")
    public Response cancelTicket(@PathParam("id") Long id) {
        try {
            ticketService.cancelTicket(id);
            return Response.noContent().build();
        } catch (Exception ex) {
            return Response.status(Response.Status.BAD_REQUEST).entity(ex.getMessage()).build();
        }
    }

    private TicketResponse toResponse(Ticket ticket) {
        TicketResponse response = new TicketResponse();
        response.setId(ticket.getId());
        response.setParticipantId(ticket.getParticipant().getId());
        response.setEventId(ticket.getEvent().getId());
        response.setEventTitle(ticket.getEvent().getTitle());
        response.setPurchaseDate(ticket.getPurchaseDate());
        response.setStatus(ticket.getStatus().name());
        response.setQrCode(ticket.getQrCode());
        response.setPaymentId(ticket.getPaymentId());
        return response;
    }
}
