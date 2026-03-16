package com.eventapp.service;

import com.eventapp.model.PaymentStatus;
import com.eventapp.model.PopularEventStat;
import com.eventapp.model.StatsSummary;
import com.eventapp.model.TicketStatus;
import com.eventapp.model.User;
import com.eventapp.model.UserRegistrationStat;
import com.eventapp.model.UserRole;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
        return getMostPopularEvents(limit, null);
    }

    /**
     * Returns most popular events by sold ticket count, optionally scoped to one organizer.
     *
     * @param limit max rows
     * @param organizerId optional organizer id
     * @return list of popular event stats
     */
    public List<PopularEventStat> getMostPopularEvents(int limit, Long organizerId) {
        int maxRows = limit <= 0 ? 5 : limit;

        String soldJpql = "SELECT e.id, e.title, e.category, e.totalTickets, COUNT(t.id) " +
                "FROM Ticket t JOIN t.event e " +
                "WHERE t.status <> :cancelled";
        if (organizerId != null && organizerId > 0) {
            soldJpql += " AND e.organizer.id = :organizerId";
        }
        soldJpql += " GROUP BY e.id, e.title, e.category, e.totalTickets ORDER BY COUNT(t.id) DESC";

        var soldQuery = entityManager.createQuery(soldJpql, Object[].class)
                .setParameter("cancelled", TicketStatus.CANCELLED)
                .setMaxResults(maxRows);
        if (organizerId != null && organizerId > 0) {
            soldQuery.setParameter("organizerId", organizerId);
        }
        List<Object[]> soldRows = soldQuery.getResultList();
        if (soldRows.isEmpty()) {
            return new ArrayList<>();
        }

        String revenueJpql = "SELECT e.id, COALESCE(SUM(p.amount), 0) " +
                "FROM Payment p " +
                "JOIN p.ticket t " +
                "JOIN t.event e " +
                "WHERE p.status = :completed";
        if (organizerId != null && organizerId > 0) {
            revenueJpql += " AND e.organizer.id = :organizerId";
        }
        revenueJpql += " GROUP BY e.id";

        var revenueQuery = entityManager.createQuery(revenueJpql, Object[].class)
                .setParameter("completed", PaymentStatus.COMPLETED);
        if (organizerId != null && organizerId > 0) {
            revenueQuery.setParameter("organizerId", organizerId);
        }
        List<Object[]> revenueRows = revenueQuery.getResultList();

        Map<Long, BigDecimal> revenueByEventId = new HashMap<>();
        for (Object[] row : revenueRows) {
            revenueByEventId.put((Long) row[0], toBigDecimal(row[1]));
        }

        List<PopularEventStat> stats = new ArrayList<>();
        for (Object[] row : soldRows) {
            Long eventId = (Long) row[0];
            String title = (String) row[1];
            String category = (String) row[2];
            Integer totalTickets = (Integer) row[3];
            Long soldTickets = toLong(row[4]);
            BigDecimal revenue = revenueByEventId.getOrDefault(eventId, BigDecimal.ZERO);
            stats.add(new PopularEventStat(eventId, title, category, totalTickets, soldTickets, revenue));
        }
        return stats;
    }

    /**
     * Alias for popular events list used by dashboards.
     *
     * @param limit max rows
     * @return list of popular event stats
     */
    public List<PopularEventStat> getPopularEvents(int limit) {
        return getMostPopularEvents(limit);
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
     * Returns user registration stats grouped by date and role.
     *
     * @return date/role/count list
     */
    public List<UserRegistrationStat> getUserRegistrationStats() {
        List<Object[]> rows = entityManager.createQuery(
                        "SELECT FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d'), u.role, COUNT(u.id) " +
                                "FROM User u " +
                                "GROUP BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d'), u.role " +
                                "ORDER BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m-%d') ASC, u.role ASC",
                        Object[].class)
                .getResultList();

        List<UserRegistrationStat> stats = new ArrayList<>();
        for (Object[] row : rows) {
            String date = String.valueOf(row[0]);
            String role = String.valueOf(row[1]);
            Long registrations = toLong(row[2]);
            stats.add(new UserRegistrationStat(date, role, registrations));
        }
        return stats;
    }

    /**
     * Counts users by role.
     *
     * @param role target role
     * @return user count
     */
    public long countUsersByRole(UserRole role) {
        if (role == null) {
            throw new IllegalArgumentException("Role is required.");
        }
        return userRepository.countByRole(role);
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

    private Long toLong(Object value) {
        if (value == null) {
            return 0L;
        }
        if (value instanceof Number number) {
            return number.longValue();
        }
        return Long.parseLong(String.valueOf(value));
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value == null) {
            return BigDecimal.ZERO;
        }
        if (value instanceof BigDecimal decimal) {
            return decimal;
        }
        if (value instanceof Number number) {
            return BigDecimal.valueOf(number.doubleValue());
        }
        return new BigDecimal(String.valueOf(value));
    }
}
