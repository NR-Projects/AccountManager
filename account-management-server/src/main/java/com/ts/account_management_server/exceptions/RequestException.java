package com.ts.account_management_server.exceptions;

import lombok.Data;

public class RequestException extends BaseException {
    public RequestException(String message) {
        super(message);
        this.setExceptionType("Request");
        this.setStatusCode(400);
    }
}
