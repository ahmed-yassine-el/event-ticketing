package com.eventapp.servlet;

import com.eventapp.model.Event;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;
import com.eventapp.util.FlashUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/organizer/delete-event")
public class DeleteEventServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null || !validateCsrf(request, response)) {
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        try {
            Event event = eventService.getEventById(id);
            if (event == null || !event.getOrganizer().getId().equals(organizer.getId())) {
                throw new IllegalArgumentException("You cannot delete this event");
            }
            eventService.deleteEvent(id);
            FlashUtil.setSuccess(request.getSession(), "Event deleted.");
        } catch (Exception ex) {
            FlashUtil.setError(request.getSession(), ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/organizer/dashboard");
    }
}
