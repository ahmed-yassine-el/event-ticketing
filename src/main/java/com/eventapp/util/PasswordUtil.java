package com.eventapp.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility for secure password hashing and verification using BCrypt.
 */
public final class PasswordUtil {

    private static final int BCRYPT_ROUNDS = 12;

    private PasswordUtil() {
        // Utility class
    }

    /**
     * Hashes a plain-text password using BCrypt.
     *
     * @param plainPassword plain-text password
     * @return BCrypt hash
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            throw new IllegalArgumentException("Password cannot be blank.");
        }
        if (plainPassword.length() < 8 || plainPassword.length() > 128) {
            throw new IllegalArgumentException("Password must be between 8 and 128 characters.");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /**
     * Verifies a plain-text password against a BCrypt hash.
     *
     * @param plainPassword plain-text password
     * @param hashedPassword stored BCrypt hash
     * @return true if password matches hash, otherwise false
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || plainPassword.isBlank()) {
            return false;
        }
        if (hashedPassword == null || hashedPassword.isBlank()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException ex) {
            return false;
        }
    }
}