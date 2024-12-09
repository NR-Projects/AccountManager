package com.ts.account_management_server.exception;

public class AuthException extends BaseException {
    public AuthException(String exceptionMessage) {
        super(exceptionMessage);
    }

    public static AuthException Authentication() {
        AuthException authException = new AuthException("Insufficient Credentials");
        authException.setExceptionType("Authentication");
        authException.setStatusCode(401);
        return authException;
    }
}
