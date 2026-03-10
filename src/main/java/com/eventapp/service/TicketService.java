package com.eventapp.service;

import com.eventapp.model.Event;
import com.eventapp.model.EventStatus;
import com.eventapp.model.Ticket;
import com.eventapp.model.TicketStatus;
import com.eventapp.model.User;
import com.eventapp.repository.EventRepository;
import com.eventapp.repository.TicketRepository;
import com.eventapp.repository.UserRepository;
import com.eventapp.util.QRCodeUtil;
import com.eventapp.util.ValidationUtil;
import jakarta.ejb.Stateless;
import jakarta.ejb.TransactionAttribute;
import jakarta.ejb.TransactionAttributeType;
import jakarta.inject.Inject;

import java.time.format.DateTimeFormatter;
import java.util.List;

@Stateless
public class TicketService {

    @Inject
    private TicketRepository ticketRepository;

    @Inject
    private UserRepository userRepository;

    @Inject
    private EventRepository eventRepository;

    /**
     * Purchases a ticket for a participant.
     *
     * @param participantId participant id
     * @param eventId event id
     * @return created ticket
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Ticket purchaseTicket(Long participantId, Long eventId) {
        if (participantId == null || participantId <= 0 || eventId == null || eventId <= 0) {
            throw new IllegalArgumentException("Participant id and event id are required.");
        }

        User participant = userRepository.findById(participantId)
                .orElseThrow(() -> new IllegalArgumentException("Participant not found."));
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new IllegalArgumentException("Event not found."));

        if (event.getStatus() != EventStatus.APPROVED) {
            throw new IllegalStateException("Event is not available for purchase.");
        }
        if (event.getAvailableTickets() == null || event.getAvailableTickets() <= 0) {
            throw new IllegalStateException("No tickets available.");
        }

        event.setAvailableTickets(event.getAvailableTickets() - 1);
        eventRepository.save(event);

        Ticket ticket = new Ticket();
        ticket.setParticipant(participant);
        ticket.setEvent(event);
        ticket.setStatus(TicketStatus.ACTIVE);

        return ticketRepository.save(ticket);
    }

    /**
     * Cancels a ticket.
     *
     * @param ticketId ticket id
     * @return updated ticket
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Ticket cancelTicket(Long ticketId) {
        Ticket ticket = getExistingTicket(ticketId);

        if (ticket.getStatus() == TicketStatus.CANCELLED) {
            return ticket;
        }

        ticket.setStatus(TicketStatus.CANCELLED);
        Event event = ticket.getEvent();
        event.setAvailableTickets(event.getAvailableTickets() + 1);

        eventRepository.save(event);
        return ticketRepository.save(ticket);
    }

    /**
     * Transfers a ticket to another participant by email.
     *
     * @param ticketId ticket id
     * @param newParticipantEmail recipient email
     * @return updated ticket
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public Ticket transferTicket(Long ticketId, String newParticipantEmail) {
        Ticket ticket = getExistingTicket(ticketId);

        if (!ValidationUtil.isEmail(newParticipantEmail)) {
            throw new IllegalArgumentException("Valid destination email is required.");
        }

        User newParticipant = userRepository.findByEmail(newParticipantEmail.trim())
                .orElseThrow(() -> new IllegalArgumentException("Destination participant not found."));

        ticket.setParticipant(newParticipant);
        ticket.setStatus(TicketStatus.TRANSFERRED);

        return ticketRepository.save(ticket);
    }

    /**
     * Gets participant ticket history.
     *
     * @param participantId participant id
     * @return tickets list
     */
    public List<Ticket> getTicketsByParticipant(Long participantId) {
        if (participantId == null || participantId <= 0) {
            throw new IllegalArgumentException("Participant id is required.");
        }
        return ticketRepository.findByParticipant(participantId);
    }

    /**
     * Generates and stores QR code (Base64) for ticket.
     *
     * @param ticketId ticket id
     * @return QR code as Base64 string
     */
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public String generateQRCode(Long ticketId) {
        Ticket ticket = getExistingTicket(ticketId);

        String payload = ticket.getId() + "|"
                + ticket.getEvent().getId() + "|"
                + ticket.getParticipant().getId() + "|"
                + ticket.getPurchaseDate().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        String base64 = QRCodeUtil.generateBase64QrCode(payload, 300, 300);
        ticket.setQrCode(base64);
        ticketRepository.save(ticket);

        return base64;
    }

    /**
     * Finds ticket by id.
     *
     * @param ticketId ticket id
     * @return ticket or null
     */
    public Ticket getTicketById(Long ticketId) {
        if (ticketId == null || ticketId <= 0) {
            return null;
        }
        return ticketRepository.findById(ticketId).orElse(null);
    }

    /**
     * Gets sold tickets count by event.
     *
     * @param eventId event id
     * @return sold count
     */
    public long countSoldTicketsByEvent(Long eventId) {
        if (eventId == null || eventId <= 0) {
            throw new IllegalArgumentException("Event id is required.");
        }
        return ticketRepository.countSoldByEvent(eventId);
    }

    /**
     * Counts all tickets.
     *
     * @return total tickets
     */
    public long countTickets() {
        return ticketRepository.countAll();
    }

    private Ticket getExistingTicket(Long ticketId) {
        if (ticketId == null || ticketId <= 0) {
            throw new IllegalArgumentException("Ticket id is required.");
        }
        return ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found."));
    }
}
