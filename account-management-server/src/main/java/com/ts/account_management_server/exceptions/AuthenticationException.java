package com.ts.account_management_server.exceptions;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class AuthenticationException extends BaseException {
    public AuthenticationException() {
        super("Incorrect or Insufficient Credentials for Authentication");
        this.setExceptionType("Authentication");
        this.setStatusCode(401);
    }
}
