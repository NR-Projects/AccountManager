package com.ts.account_management_server.exceptions;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class NotFoundException extends BaseException {
    public NotFoundException() {
        super("Entity/Resource is missing");
        this.setExceptionType("NotFound");
        this.setStatusCode(404);
    }
}
