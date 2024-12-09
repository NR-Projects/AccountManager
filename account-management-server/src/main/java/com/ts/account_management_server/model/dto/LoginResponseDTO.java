package com.ts.account_management_server.model.dto;

import lombok.Builder;

@Builder
public class LoginResponseDTO {
    private String jwtToken;
}
