package com.eventapp.service;

import com.eventapp.model.PopularEventStat;
import com.eventapp.model.StatsSummary;
import com.eventapp.model.User;
import com.eventapp.model.UserRegistrationStat;
import com.eventapp.repository.EventRepository;
import com.eventapp.repository.PaymentRepository;
import com.eventapp.repository.TicketRepository;
import com.eventapp.repository.UserRepository;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Stateless
public class StatisticsService {

    @Inject
    private PaymentRepository paymentRepository;

    @Inject
    private EventRepository eventRepository;

    @Inject
    private TicketRepository ticketRepository;

    @Inject
    private UserRepository userRepository;

    @PersistenceContext(unitName = "eventPU")
    private EntityManager entityManager;

    /**
     * Returns total completed revenue.
     *
     * @return revenue amount
     */
    public BigDecimal getTotalRevenue() {
        return paymentRepository.sumCompletedRevenue();
    }

    /**
     * Returns most popular events by sold ticket count.
     *
     * @param limit max rows
     * @return list of popular event stats
     */
    public List<PopularEventStat> getMostPopularEvents(int limit) {
        int maxRows = limit <= 0 ? 5 : limit;

        List<Object[]> rows = entityManager.createQuery(
                        "SELECT e.id, e.title, COUNT(t.id) " +
                                "FROM Ticket t JOIN t.event e " +
                                "WHERE t.status <> com.eventapp.model.TicketStatus.CANCELLED " +
                                "GROUP BY e.id, e.title " +
                                "ORDER BY COUNT(t.id) DESC",
                        Object[].class)
                .setMaxResults(maxRows)
                .getResultList();

        List<PopularEventStat> stats = new ArrayList<>();
        for (Object[] row : rows) {
            stats.add(new PopularEventStat((Long) row[0], (String) row[1], (Long) row[2]));
        }
        return stats;
    }

    /**
     * Returns sold tickets count for one event.
     *
     * @param eventId event id
     * @return sold tickets count
     */
    public long getTotalTicketsSoldByEvent(Long eventId) {
        if (eventId == null || eventId <= 0) {
            throw new IllegalArgumentException("Event id is required.");
        }
        return ticketRepository.countSoldByEvent(eventId);
    }

    /**
     * Returns user registration stats grouped by date.
     *
     * @return date/count list
     */
    public List<UserRegistrationStat> getUserRegistrationStats() {
        List<Object[]> rows = entityManager.createQuery(
                        "SELECT FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d'), COUNT(u.id) " +
                                "FROM User u " +
                                "GROUP BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d') " +
                                "ORDER BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d') ASC",
                        Object[].class)
                .getResultList();

        List<UserRegistrationStat> stats = new ArrayList<>();
        for (Object[] row : rows) {
            stats.add(new UserRegistrationStat(String.valueOf(row[0]), (Long) row[1]));
        }
        return stats;
    }

    /**
     * Returns a global dashboard summary.
     *
     * @return summary DTO
     */
    public StatsSummary getSummary() {
        return new StatsSummary(
                userRepository.countAll(),
                eventRepository.countAll(),
                ticketRepository.countAll(),
                getTotalRevenue()
        );
    }

    /**
     * Loads users with their key relationships for admin dashboard rendering.
     *
     * @return users with pre-fetched relationships
     */
    public List<User> getUsersWithRelationships() {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u ORDER BY u.createdAt DESC", User.class)
                .getResultList();

        if (users.isEmpty()) {
            return users;
        }

        List<Long> ids = users.stream().map(User::getId).collect(Collectors.toList());

        entityManager.createQuery(
                        "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.organizedEvents WHERE u.id IN :ids",
                        User.class)
                .setParameter("ids", ids)
                .getResultList();

        entityManager.createQuery(
                        "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.participantTickets WHERE u.id IN :ids",
                        User.class)
                .setParameter("ids", ids)
                .getResultList();

        return users;
    }
}
