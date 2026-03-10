package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.util.CsrfUtil;
import com.eventapp.util.FlashUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Arrays;

public abstract class BaseServlet extends HttpServlet {

    protected void prepareView(HttpServletRequest request) {
        HttpSession session = request.getSession(true);
        request.setAttribute("csrfToken", CsrfUtil.ensureToken(session));
        FlashUtil.expose(request);
        request.setAttribute("loggedUser", session.getAttribute("loggedUser"));
    }

    protected void forward(HttpServletRequest request, HttpServletResponse response, String view)
            throws ServletException, IOException {
        prepareView(request);
        request.getRequestDispatcher("/WEB-INF/views/" + view).forward(request, response);
    }

    protected boolean validateCsrf(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!CsrfUtil.isValid(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return false;
        }
        return true;
    }

    protected User requireRole(HttpServletRequest request, HttpServletResponse response, UserRole... roles)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("loggedUser");
        boolean allowed = Arrays.stream(roles).anyMatch(role -> role == user.getRole());
        if (!allowed) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return user;
    }

    protected LocalDateTime parseDateTime(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return LocalDateTime.parse(value, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (DateTimeParseException ex) {
            return null;
        }
    }

    protected Long parseLong(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
