package com.eventapp.repository;

import com.eventapp.model.Payment;
import com.eventapp.model.PaymentStatus;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class PaymentRepository {

    @PersistenceContext(unitName = "eventPU")
    private EntityManager entityManager;

    public Payment save(Payment payment) {
        if (payment.getId() == null) {
            entityManager.persist(payment);
            return payment;
        }
        return entityManager.merge(payment);
    }

    public Optional<Payment> findById(Long id) {
        return Optional.ofNullable(entityManager.find(Payment.class, id));
    }

    public List<Payment> findByTicket(Long ticketId) {
        return entityManager.createQuery(
                        "SELECT p FROM Payment p WHERE p.ticket.id = :ticketId ORDER BY p.paymentDate DESC",
                        Payment.class)
                .setParameter("ticketId", ticketId)
                .getResultList();
    }

    public BigDecimal sumCompletedRevenue() {
        BigDecimal total = entityManager.createQuery(
                        "SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = :status",
                        BigDecimal.class)
                .setParameter("status", PaymentStatus.COMPLETED)
                .getSingleResult();
        return total == null ? BigDecimal.ZERO : total;
    }
}
