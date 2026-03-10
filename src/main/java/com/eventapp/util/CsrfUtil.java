package com.eventapp.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;

public final class CsrfUtil {

    public static final String CSRF_SESSION_KEY = "csrfToken";

    private CsrfUtil() {
    }

    public static String ensureToken(HttpSession session) {
        Object existing = session.getAttribute(CSRF_SESSION_KEY);
        if (existing instanceof String token && !token.isBlank()) {
            return token;
        }
        byte[] random = new byte[24];
        new SecureRandom().nextBytes(random);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(random);
        session.setAttribute(CSRF_SESSION_KEY, token);
        return token;
    }

    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Object expected = session.getAttribute(CSRF_SESSION_KEY);
        String actual = request.getParameter("csrfToken");
        return expected instanceof String && expected.equals(actual);
    }
}
