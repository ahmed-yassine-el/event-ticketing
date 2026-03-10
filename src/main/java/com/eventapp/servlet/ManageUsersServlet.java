package com.eventapp.servlet;

import com.eventapp.model.User;
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

@WebServlet("/admin/users")
public class ManageUsersServlet extends BaseServlet {

    @EJB
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null) {
            return;
        }
        request.setAttribute("users", userService.getAllUsers());
        forward(request, response, "admin/users.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        User admin = requireRole(request, response, UserRole.ADMIN);
        if (admin == null || !validateCsrf(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("delete".equalsIgnoreCase(action)) {
                Long id = parseLong(request.getParameter("id"));
                userService.deleteUser(id);
                FlashUtil.setSuccess(request.getSession(), "User deleted successfully.");
            } else if ("create".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                if (!ValidationUtil.between(name, 2, 120) || !ValidationUtil.isEmail(email)
                        || !ValidationUtil.between(password, 8, 128) || ValidationUtil.isBlank(role)) {
                    throw new IllegalArgumentException("Invalid user input for creation.");
                }
                userService.registerUser(name, email, password, UserRole.valueOf(role));
                FlashUtil.setSuccess(request.getSession(), "User created successfully.");
            } else {
                Long id = parseLong(request.getParameter("id"));
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String role = request.getParameter("role");
                boolean active = "true".equalsIgnoreCase(request.getParameter("active"));

                User user = userService.getUserById(id);
                if (user == null) {
                    throw new IllegalArgumentException("User not found");
                }
                user.setName(name);
                user.setEmail(email);
                user.setRole(UserRole.valueOf(role));
                user.setActive(active);
                userService.updateUser(user);
                FlashUtil.setSuccess(request.getSession(), "User updated successfully.");
            }
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            request.setAttribute("users", userService.getAllUsers());
            forward(request, response, "admin/users.jsp");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
