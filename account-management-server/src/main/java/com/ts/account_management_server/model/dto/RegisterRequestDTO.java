package com.ts.account_management_server.model.dto;

import lombok.Data;

import java.util.Map;

@Data
public class RegisterRequestDTO {
    private String registerSecret;
    private Map<String, String> deviceMetadata;
}
