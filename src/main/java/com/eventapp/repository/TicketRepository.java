package com.eventapp.repository;

import com.eventapp.model.Ticket;
import com.eventapp.model.TicketStatus;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class TicketRepository {

    @PersistenceContext(unitName = "eventPU")
    private EntityManager entityManager;

    public Ticket save(Ticket ticket) {
        if (ticket.getId() == null) {
            entityManager.persist(ticket);
            return ticket;
        }
        return entityManager.merge(ticket);
    }

    public Optional<Ticket> findById(Long id) {
        return Optional.ofNullable(entityManager.find(Ticket.class, id));
    }

    public List<Ticket> findByParticipant(Long participantId) {
        return entityManager.createQuery(
                        "SELECT t FROM Ticket t JOIN FETCH t.event WHERE t.participant.id = :participantId ORDER BY t.purchaseDate DESC",
                        Ticket.class)
                .setParameter("participantId", participantId)
                .getResultList();
    }

    public long countAll() {
        return entityManager.createQuery("SELECT COUNT(t) FROM Ticket t", Long.class)
                .getSingleResult();
    }

    public long countSoldByEvent(Long eventId) {
        return entityManager.createQuery(
                        "SELECT COUNT(t) FROM Ticket t WHERE t.event.id = :eventId AND t.status <> :cancelledStatus",
                        Long.class)
                .setParameter("eventId", eventId)
                .setParameter("cancelledStatus", TicketStatus.CANCELLED)
                .getSingleResult();
    }
}
