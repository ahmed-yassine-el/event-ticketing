package com.eventapp.servlet;

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

@WebServlet("/organizer/create-event")
public class CreateEventServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null) {
            return;
        }
        forward(request, response, "organizer/create-event.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User organizer = requireRole(request, response, UserRole.ORGANIZER);
        if (organizer == null || !validateCsrf(request, response)) {
            return;
        }

        try {
            EventDTO eventDTO = buildEventDto(request);
            eventService.createEvent(eventDTO, organizer.getId());
            FlashUtil.setSuccess(request.getSession(), "Event submitted for admin approval.");
            response.sendRedirect(request.getContextPath() + "/organizer/dashboard");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            forward(request, response, "organizer/create-event.jsp");
        }
    }

    private EventDTO buildEventDto(HttpServletRequest request) {
        EventDTO dto = new EventDTO();
        dto.setTitle(request.getParameter("title"));
        dto.setDescription(request.getParameter("description"));
        dto.setCategory(request.getParameter("category"));
        dto.setLocation(request.getParameter("location"));
        dto.setEventDate(parseDateTime(request.getParameter("eventDate")));
        dto.setTotalTickets(Integer.valueOf(request.getParameter("totalTickets")));
        dto.setPrice(new BigDecimal(request.getParameter("price")));
        return dto;
    }
}
