package com.eventapp.repository;

import com.eventapp.model.Event;
import com.eventapp.model.EventStatus;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class EventRepository {

    @PersistenceContext(unitName = "eventPU")
    private EntityManager entityManager;

    public Event save(Event event) {
        if (event.getId() == null) {
            entityManager.persist(event);
            return event;
        }
        return entityManager.merge(event);
    }

    public Optional<Event> findById(Long id) {
        return Optional.ofNullable(entityManager.find(Event.class, id));
    }

    public void delete(Event event) {
        Event managed = entityManager.contains(event) ? event : entityManager.merge(event);
        entityManager.remove(managed);
    }

    public List<Event> findAllApproved() {
        return entityManager.createQuery(
                        "SELECT e FROM Event e WHERE e.status = :status ORDER BY e.eventDate ASC", Event.class)
                .setParameter("status", EventStatus.APPROVED)
                .getResultList();
    }

    public List<Event> findApproved(int page, int size) {
        return entityManager.createQuery(
                        "SELECT e FROM Event e WHERE e.status = :status ORDER BY e.eventDate ASC", Event.class)
                .setParameter("status", EventStatus.APPROVED)
                .setFirstResult(page * size)
                .setMaxResults(size)
                .getResultList();
    }

    public List<Event> findByOrganizer(Long organizerId) {
        return entityManager.createQuery(
                        "SELECT e FROM Event e WHERE e.organizer.id = :organizerId ORDER BY e.createdAt DESC", Event.class)
                .setParameter("organizerId", organizerId)
                .getResultList();
    }

    public List<Event> findPending() {
        return entityManager.createQuery(
                        "SELECT DISTINCT e FROM Event e " +
                                "LEFT JOIN FETCH e.organizer " +
                                "WHERE e.status = :status ORDER BY e.createdAt ASC", Event.class)
                .setParameter("status", EventStatus.PENDING)
                .getResultList();
    }

    public List<Event> findForAdmin(EventStatus status, int page, int size) {
        StringBuilder jpql = new StringBuilder(
                "SELECT DISTINCT e FROM Event e LEFT JOIN FETCH e.organizer");
        if (status != null) {
            jpql.append(" WHERE e.status = :status");
        }
        jpql.append(" ORDER BY e.createdAt DESC");

        var query = entityManager.createQuery(jpql.toString(), Event.class)
                .setFirstResult(Math.max(0, page) * Math.max(1, size))
                .setMaxResults(Math.max(1, size));
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getResultList();
    }

    public long countForAdmin(EventStatus status) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(e) FROM Event e");
        if (status != null) {
            jpql.append(" WHERE e.status = :status");
        }

        var query = entityManager.createQuery(jpql.toString(), Long.class);
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getSingleResult();
    }

    public List<Event> search(String category, String location, LocalDateTime date) {
        StringBuilder jpql = new StringBuilder("SELECT e FROM Event e WHERE e.status = :status");

        if (category != null && !category.isBlank()) {
            jpql.append(" AND lower(e.category) LIKE :category");
        }
        if (location != null && !location.isBlank()) {
            jpql.append(" AND lower(e.location) LIKE :location");
        }
        if (date != null) {
            jpql.append(" AND e.eventDate >= :eventDate");
        }
        jpql.append(" ORDER BY e.eventDate ASC");

        var query = entityManager.createQuery(jpql.toString(), Event.class)
                .setParameter("status", EventStatus.APPROVED);

        if (category != null && !category.isBlank()) {
            query.setParameter("category", "%" + category.toLowerCase() + "%");
        }
        if (location != null && !location.isBlank()) {
            query.setParameter("location", "%" + location.toLowerCase() + "%");
        }
        if (date != null) {
            query.setParameter("eventDate", date);
        }

        return query.getResultList();
    }

    public long countAll() {
        return entityManager.createQuery("SELECT COUNT(e) FROM Event e", Long.class)
                .getSingleResult();
    }
}
