package com.ts.account_management_server.advice;

import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.model.ErrorResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class ControllerException {
    @ExceptionHandler(value = BaseException.class)
    public ResponseEntity<ErrorResponse> handleDefinedExceptions(
            BaseException ex
    ) {
        System.out.println(ex.getMessage());
        return ResponseEntity
                .status(ex.getStatusCode())
                .body(
                        ErrorResponse
                                .builder()
                                .errorSource(ex.getExceptionType())
                                .errorMessage(ex.getMessage())
                                .build()
                );
    }
    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<ErrorResponse> handleRemainingExceptions(
            Exception ex
    ) {
        System.out.println(ex.getMessage());
        return ResponseEntity
                .status(500)
                .body(
                        ErrorResponse
                                .builder()
                                .errorSource(ex.getClass().getSimpleName())
                                .errorMessage(ex.getMessage())
                                .build()
                );
    }
}
