package com.eventapp.servlet;

import com.eventapp.model.Ticket;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.PaymentService;
import com.eventapp.service.TicketService;
import com.eventapp.util.FlashUtil;
import com.eventapp.util.MailUtil;

import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.mail.Session;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/buy-ticket")
public class BuyTicketServlet extends BaseServlet {

    private static final Logger LOGGER = Logger.getLogger(BuyTicketServlet.class.getName());

    @EJB
    private TicketService ticketService;

    @EJB
    private PaymentService paymentService;

    @Resource(lookup = "java:jboss/mail/Default")
    private Session mailSession;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireRole(request, response, UserRole.PARTICIPANT);
        if (user == null || !validateCsrf(request, response)) {
            return;
        }

        Long eventId = parseLong(request.getParameter("eventId"));
        if (eventId == null) {
            FlashUtil.setError(request.getSession(), "Invalid event id.");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.isBlank()) {
            paymentMethod = "CARD";
        }

        try {
            Ticket ticket = ticketService.purchaseTicket(user.getId(), eventId);
            paymentService.processPayment(ticket.getId(), ticket.getEvent().getPrice(), paymentMethod);
            String qr = ticketService.generateQRCode(ticket.getId());

            try {
                MailUtil.sendTicketConfirmation(
                        mailSession,
                        user.getEmail(),
                        ticket.getEvent().getTitle(),
                        MailUtil.formatDate(ticket.getEvent().getEventDate()),
                        ticket.getEvent().getLocation(),
                        ticket.getId(),
                        qr
                );
            } catch (Exception emailEx) {
                LOGGER.log(Level.WARNING,
                        "Ticket purchase succeeded but confirmation email failed for user {0}, ticket {1}: {2}",
                        new Object[]{user.getEmail(), ticket.getId(), emailEx.getMessage()});
            }

            FlashUtil.setSuccess(request.getSession(), "Ticket purchased successfully.");
            response.sendRedirect(request.getContextPath() + "/my-tickets");
        } catch (Exception ex) {
            FlashUtil.setError(request.getSession(), ex.getMessage());
            response.sendRedirect(request.getContextPath() + "/event?id=" + eventId);
        }
    }
}
