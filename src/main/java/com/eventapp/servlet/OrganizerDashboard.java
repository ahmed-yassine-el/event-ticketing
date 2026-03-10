package com.eventapp.servlet;

import com.eventapp.model.Event;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;
import com.eventapp.service.TicketService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/organizer/dashboard")
public class OrganizerDashboard extends BaseServlet {

    @EJB
    private EventService eventService;

    @EJB
    private TicketService ticketService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null) {
            return;
        }

        List<Event> events = eventService.getEventsByOrganizer(organizer.getId());
        long totalSold = 0;
        BigDecimal estimatedRevenue = BigDecimal.ZERO;

        for (Event event : events) {
            long sold = ticketService.countSoldTicketsByEvent(event.getId());
            totalSold += sold;
            estimatedRevenue = estimatedRevenue.add(event.getPrice().multiply(BigDecimal.valueOf(sold)));
        }

        request.setAttribute("events", events);
        request.setAttribute("totalEvents", events.size());
        request.setAttribute("totalSold", totalSold);
        request.setAttribute("estimatedRevenue", estimatedRevenue);
        forward(request, response, "organizer/dashboard.jsp");
    }
}
