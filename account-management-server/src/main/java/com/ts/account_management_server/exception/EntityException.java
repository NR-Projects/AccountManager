package com.ts.account_management_server.exception;

public class EntityException extends BaseException {
    public EntityException(String exceptionMessage) {
        super(exceptionMessage);
    }

    public static EntityException NotFound(String customMessage) {
        EntityException entityException = new EntityException(customMessage);
        entityException.setExceptionType("Not Found");
        entityException.setStatusCode(404);
        return entityException;
    }
}
