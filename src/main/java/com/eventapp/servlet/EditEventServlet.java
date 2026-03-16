package com.eventapp.servlet;

import com.eventapp.model.Event;
import com.eventapp.model.EventDTO;
import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;
import com.eventapp.util.FlashUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/organizer/edit-event")
public class EditEventServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null) {
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        Event event = eventService.getEventById(id);
        if (event == null || !event.getOrganizer().getId().equals(organizer.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot edit this event");
            return;
        }

        request.setAttribute("event", event);
        forward(request, response, "organizer/edit-event.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null || !validateCsrf(request, response)) {
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        Event event = eventService.getEventById(id);
        if (event == null || !event.getOrganizer().getId().equals(organizer.getId())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "You cannot edit this event");
            return;
        }

        try {
            EventDTO eventDTO = new EventDTO();
            eventDTO.setTitle(request.getParameter("title"));
            eventDTO.setDescription(request.getParameter("description"));
            eventDTO.setCategory(request.getParameter("category"));
            eventDTO.setLocation(request.getParameter("location"));
            eventDTO.setLatitude(parseCoordinate(request.getParameter("latitude")));
            eventDTO.setLongitude(parseCoordinate(request.getParameter("longitude")));
            eventDTO.setEventDate(parseDateTime(request.getParameter("eventDate")));
            eventDTO.setTotalTickets(Integer.valueOf(request.getParameter("totalTickets")));
            eventDTO.setPrice(new BigDecimal(request.getParameter("price")));

            eventService.updateEvent(id, eventDTO, eventDTO.getLatitude(), eventDTO.getLongitude());
            FlashUtil.setSuccess(request.getSession(), "Event updated successfully.");
            response.sendRedirect(request.getContextPath() + "/organizer/dashboard");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("event", event);
            forward(request, response, "organizer/edit-event.jsp");
        }
    }

    private Double parseCoordinate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Double.parseDouble(value.trim());
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Invalid location coordinates.");
        }
    }
}
