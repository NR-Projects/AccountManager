package com.ts.account_management_server.util;

import java.security.SecureRandom;

public class RandomStringUtil {

    private static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    private static final SecureRandom RANDOM = new SecureRandom();

    private RandomStringUtil() {}

    /**
     * Generates a random string of the specified length.
     *
     * @param length The desired length of the random string.
     * @return A randomly generated string.
     */
    public static String generateRandomString(int length) {
        if (length <= 0) {
            throw new IllegalArgumentException("Length must be greater than 0");
        }

        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int randomIndex = RANDOM.nextInt(CHARACTERS.length());
            sb.append(CHARACTERS.charAt(randomIndex));
        }
        return sb.toString();
    }
}

