package com.tap.util;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for generating and validating CSRF tokens
 */
public class CSRFTokenUtil {
    
    private static final SecureRandom secureRandom = new SecureRandom();
    private static final Base64.Encoder base64Encoder = Base64.getUrlEncoder();
    
    /**
     * Generates a secure random token for CSRF protection
     * @return String containing the generated token
     */
    public static String generateToken() {
        byte[] randomBytes = new byte[32];
        secureRandom.nextBytes(randomBytes);
        return base64Encoder.encodeToString(randomBytes);
    }
    
    /**
     * Validates if the provided token matches the expected token
     * @param expectedToken The token stored in session
     * @param actualToken The token received from form submission
     * @return true if tokens match, false otherwise
     */
    public static boolean validateToken(String expectedToken, String actualToken) {
        if (expectedToken == null || actualToken == null) {
            return false;
        }
        return expectedToken.equals(actualToken);
    }
} 