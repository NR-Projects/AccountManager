package com.ts.account_management_server.exception;

public class LinkException extends BaseException {
    public LinkException(String exceptionMessage) {
        super(exceptionMessage);
        this.setExceptionType("Link");
        this.setStatusCode(428);
    }
}
