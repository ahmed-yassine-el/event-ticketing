package com.eventapp.servlet;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.service.UserService;
import com.eventapp.util.ValidationUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        forward(request, response, "login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!validateCsrf(request, response)) {
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (!ValidationUtil.isEmail(email) || ValidationUtil.isBlank(password)) {
            request.setAttribute("error", "Please enter valid credentials.");
            forward(request, response, "login.jsp");
            return;
        }

        User user = userService.login(email, password);
        if (user == null) {
            request.setAttribute("error", "Invalid email or password.");
            forward(request, response, "login.jsp");
            return;
        }

        request.getSession(true).setAttribute("loggedUser", user);
        if (user.getRole() == UserRole.ADMIN) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else if (user.getRole() == UserRole.ORGANIZER) {
            response.sendRedirect(request.getContextPath() + "/organizer/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
