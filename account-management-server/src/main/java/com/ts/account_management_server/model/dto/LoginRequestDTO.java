package com.ts.account_management_server.model.dto;

import lombok.Data;

import java.util.Map;

@Data
public class LoginRequestDTO {
    private String secretKey;
    private String masterPassword;
    private Map<String, String> deviceMetadata;
}
