package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.model.Event;
import com.eventapp.service.EventService;
import com.eventapp.service.StatisticsService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboard extends BaseServlet {

    @EJB
    private StatisticsService statisticsService;

    @EJB
    private EventService eventService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null) {
            return;
        }

        List<Event> pendingEvents = eventService.getPendingEvents();
        pendingEvents.forEach(event -> {
            if (event.getOrganizer() != null) {
                event.getOrganizer().getName();
            }
        });

        request.setAttribute("dashboardUsers", statisticsService.getUsersWithRelationships());
        request.setAttribute("summary", statisticsService.getSummary());
        request.setAttribute("pendingEvents", pendingEvents);
        forward(request, response, "admin/dashboard.jsp");
    }
}
