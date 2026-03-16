package com.eventapp.servlet;

import com.eventapp.model.Event;
import com.eventapp.model.PopularEventStat;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;
import com.eventapp.service.StatisticsService;
import com.eventapp.service.TicketService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/organizer/stats")
public class OrganizerStatsServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @EJB
    private TicketService ticketService;

    @EJB
    private StatisticsService statisticsService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null) {
            return;
        }

        List<Event> organizerEvents = eventService.getEventsByOrganizer(organizer.getId());
        Map<String, Long> soldByEvent = new LinkedHashMap<>();
        for (Event event : organizerEvents) {
            soldByEvent.put(event.getTitle(), ticketService.countSoldTicketsByEvent(event.getId()));
        }

        List<PopularEventStat> popularEvents = statisticsService.getMostPopularEvents(10, organizer.getId());

        request.setAttribute("soldByEvent", soldByEvent);
        request.setAttribute("popularEvents", popularEvents);
        forward(request, response, "organizer/stats.jsp");
    }
}
