package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/events")
public class AdminEventsServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null) {
            return;
        }
        request.setAttribute("pendingEvents", eventService.getPendingEvents());
        forward(request, response, "admin/events.jsp");
    }
}
