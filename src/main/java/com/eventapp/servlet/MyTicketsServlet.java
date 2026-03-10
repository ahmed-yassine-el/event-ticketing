package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.TicketService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/my-tickets")
public class MyTicketsServlet extends BaseServlet {

    @EJB
    private TicketService ticketService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = requireRole(request, response, UserRole.PARTICIPANT);
        if (user == null) {
            return;
        }

        request.setAttribute("tickets", ticketService.getTicketsByParticipant(user.getId()));
        forward(request, response, "participant/my-tickets.jsp");
    }
}
