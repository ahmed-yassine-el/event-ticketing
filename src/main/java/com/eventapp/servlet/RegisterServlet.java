package com.eventapp.servlet;

import com.eventapp.model.UserRole;
import com.eventapp.service.UserService;
import com.eventapp.util.FlashUtil;
import com.eventapp.util.ValidationUtil;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        forward(request, response, "register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!validateCsrf(request, response)) {
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleParam = request.getParameter("role");

        if (!ValidationUtil.between(name, 2, 120) || !ValidationUtil.isEmail(email)
                || !ValidationUtil.between(password, 8, 128) || ValidationUtil.isBlank(roleParam)) {
            request.setAttribute("error", "Please provide valid registration data.");
            forward(request, response, "register.jsp");
            return;
        }

        try {
            UserRole role = UserRole.valueOf(roleParam.toUpperCase());
            userService.registerUser(name, email, password, role);
            FlashUtil.setSuccess(request.getSession(), "Registration successful. Please sign in.");
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            forward(request, response, "register.jsp");
        }
    }
}
