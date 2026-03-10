package com.eventapp.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class FlashUtil {

    private static final String FLASH_SUCCESS = "flashSuccess";
    private static final String FLASH_ERROR = "flashError";

    private FlashUtil() {
    }

    public static void setSuccess(HttpSession session, String message) {
        session.setAttribute(FLASH_SUCCESS, message);
    }

    public static void setError(HttpSession session, String message) {
        session.setAttribute(FLASH_ERROR, message);
    }

    public static void expose(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        Object success = session.getAttribute(FLASH_SUCCESS);
        Object error = session.getAttribute(FLASH_ERROR);
        if (success != null) {
            request.setAttribute("success", success.toString());
            session.removeAttribute(FLASH_SUCCESS);
        }
        if (error != null) {
            request.setAttribute("error", error.toString());
            session.removeAttribute(FLASH_ERROR);
        }
    }
}
