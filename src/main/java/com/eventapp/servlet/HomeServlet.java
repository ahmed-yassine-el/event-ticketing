package com.eventapp.servlet;

import com.eventapp.service.EventService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/home")
public class HomeServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String category = request.getParameter("category");
        String location = request.getParameter("location");
        String dateParam = request.getParameter("date");

        int page = 0;
        int size = 9;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Math.max(Integer.parseInt(pageParam), 0);
            } catch (NumberFormatException ignored) {
                page = 0;
            }
        }

        LocalDateTime date = parseDateTime(dateParam);
        if (date == null && dateParam != null && !dateParam.isBlank()) {
            try {
                date = LocalDate.parse(dateParam).atStartOfDay();
            } catch (Exception ignored) {
                date = null;
            }
        }

        boolean hasFilter = (category != null && !category.isBlank())
                || (location != null && !location.isBlank())
                || date != null;

        if (hasFilter) {
            request.setAttribute("events", eventService.searchEvents(category, location, date));
        } else {
            request.setAttribute("events", eventService.getApprovedEventsPage(page, size));
        }

        request.setAttribute("page", page);
        forward(request, response, "home.jsp");
    }
}
