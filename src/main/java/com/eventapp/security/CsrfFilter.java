package com.eventapp.security;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Set;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    public static final String CSRF_TOKEN_ATTR = "csrfToken";
    private static final Set<String> SAFE_METHODS = Set.of("GET", "HEAD", "OPTIONS", "TRACE");
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    @Override
    public void init(FilterConfig filterConfig) {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(true);
        String csrfToken = (String) session.getAttribute(CSRF_TOKEN_ATTR);

        if (csrfToken == null || csrfToken.isBlank()) {
            csrfToken = generateToken();
            session.setAttribute(CSRF_TOKEN_ATTR, csrfToken);
        }

        req.setAttribute(CSRF_TOKEN_ATTR, csrfToken);

        String path = req.getRequestURI().substring(req.getContextPath().length());
        boolean csrfCheckRequired = !SAFE_METHODS.contains(req.getMethod()) && !path.startsWith("/api/");

        if (csrfCheckRequired) {
            String providedToken = req.getParameter(CSRF_TOKEN_ATTR);
            if (providedToken == null || providedToken.isBlank()) {
                providedToken = req.getHeader("X-CSRF-Token");
            }

            if (!csrfToken.equals(providedToken)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }

    private String generateToken() {
        byte[] randomBytes = new byte[32];
        SECURE_RANDOM.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }
}
