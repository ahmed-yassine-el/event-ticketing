package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.StatisticsService;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/stats")
public class AdminStatsServlet extends BaseServlet {

    @EJB
    private StatisticsService statisticsService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null) {
            return;
        }

        request.setAttribute("summary", statisticsService.getSummary());
        request.setAttribute("popularEvents", statisticsService.getMostPopularEvents(10));
        request.setAttribute("registrationStats", statisticsService.getUserRegistrationStats());
        forward(request, response, "admin/stats.jsp");
    }
}
