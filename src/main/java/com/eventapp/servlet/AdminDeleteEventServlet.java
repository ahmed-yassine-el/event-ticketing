package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.EventService;
import com.eventapp.util.FlashUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/delete-event")
public class AdminDeleteEventServlet extends BaseServlet {

    @EJB
    private EventService eventService;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null || !validateCsrf(request, response)) {
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        String status = request.getParameter("status");
        String page = request.getParameter("page");
        try {
            eventService.deleteEvent(id);
            FlashUtil.setSuccess(request.getSession(), "Event deleted.");
        } catch (Exception ex) {
            FlashUtil.setError(request.getSession(), ex.getMessage());
        }

        StringBuilder redirect = new StringBuilder(request.getContextPath()).append("/admin/events");
        boolean hasQuery = false;
        if (status != null && !status.isBlank()) {
            redirect.append("?status=").append(status.trim());
            hasQuery = true;
        }
        if (page != null && !page.isBlank()) {
            redirect.append(hasQuery ? "&" : "?").append("page=").append(page.trim());
        }
        response.sendRedirect(redirect.toString());
    }
}
