package com.eventapp.servlet;

import com.eventapp.model.Ticket;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.TicketService;
import com.eventapp.util.FlashUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cancel-ticket")
public class CancelTicketServlet extends BaseServlet {

    @EJB
    private TicketService ticketService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = requireRole(request, response, UserRole.PARTICIPANT);
        if (user == null || !validateCsrf(request, response)) {
            return;
        }

        Long ticketId = parseLong(request.getParameter("ticketId"));
        if (ticketId == null) {
            FlashUtil.setError(request.getSession(), "Invalid ticket id.");
            response.sendRedirect(request.getContextPath() + "/my-tickets");
            return;
        }

        try {
            Ticket ticket = ticketService.getTicketById(ticketId);
            if (ticket == null || !ticket.getParticipant().getId().equals(user.getId())) {
                throw new IllegalArgumentException("You cannot cancel this ticket.");
            }
            ticketService.cancelTicket(ticketId);
            FlashUtil.setSuccess(request.getSession(), "Ticket cancelled successfully.");
        } catch (Exception ex) {
            FlashUtil.setError(request.getSession(), ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/my-tickets");
    }
}
