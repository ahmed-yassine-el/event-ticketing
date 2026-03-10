package com.eventapp.service;

import com.eventapp.model.Payment;
import com.eventapp.model.PaymentStatus;
import com.eventapp.model.Ticket;
import com.eventapp.repository.PaymentRepository;
import com.eventapp.repository.TicketRepository;
import com.eventapp.util.ValidationUtil;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Stateless
public class PaymentService {

    @Inject
    private PaymentRepository paymentRepository;

    @Inject
    private TicketRepository ticketRepository;

    /**
     * Processes payment for a ticket.
     *
     * @param ticketId ticket id
     * @param amount amount
     * @param method payment method
     * @return saved payment
     */
    public Payment processPayment(Long ticketId, BigDecimal amount, String method) {
        if (ticketId == null || ticketId <= 0) {
            throw new IllegalArgumentException("Ticket id is required.");
        }
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }
        if (!ValidationUtil.between(method, 2, 50)) {
            throw new IllegalArgumentException("Payment method is invalid.");
        }

        Ticket ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new IllegalArgumentException("Ticket not found."));

        Payment payment = new Payment();
        payment.setTicket(ticket);
        payment.setAmount(amount);
        payment.setMethod(method.trim());
        payment.setStatus(PaymentStatus.COMPLETED);
        payment.setTransactionRef("TXN-" + UUID.randomUUID().toString().replace("-", "").substring(0, 16));

        Payment saved = paymentRepository.save(payment);
        ticket.setPaymentId(saved.getTransactionRef());
        ticketRepository.save(ticket);

        return saved;
    }

    /**
     * Refunds a payment.
     *
     * @param paymentId payment id
     * @return updated payment
     */
    public Payment refundPayment(Long paymentId) {
        if (paymentId == null || paymentId <= 0) {
            throw new IllegalArgumentException("Payment id is required.");
        }

        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new IllegalArgumentException("Payment not found."));

        payment.setStatus(PaymentStatus.REFUNDED);
        return paymentRepository.save(payment);
    }

    /**
     * Gets payments by ticket.
     *
     * @param ticketId ticket id
     * @return payments list
     */
    public List<Payment> getPaymentsByTicket(Long ticketId) {
        if (ticketId == null || ticketId <= 0) {
            throw new IllegalArgumentException("Ticket id is required.");
        }
        return paymentRepository.findByTicket(ticketId);
    }
}
