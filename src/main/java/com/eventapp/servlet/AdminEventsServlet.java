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

        final int pageSize = 10;
        int currentPage = 1;
        Long pageParam = parseLong(request.getParameter("page"));
        if (pageParam != null && pageParam > 0 && pageParam <= Integer.MAX_VALUE) {
            currentPage = pageParam.intValue();
        }

        String statusFilter = request.getParameter("status");
        long totalEvents = eventService.countEventsForAdmin(statusFilter);
        int totalPages = (int) Math.ceil((double) totalEvents / pageSize);
        if (totalPages <= 0) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        request.setAttribute("events", eventService.getEventsForAdmin(statusFilter, currentPage - 1, pageSize));
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalEvents", totalEvents);
        forward(request, response, "admin/events.jsp");
    }
}
