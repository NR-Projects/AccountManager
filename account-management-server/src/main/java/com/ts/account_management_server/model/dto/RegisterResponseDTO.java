package com.ts.account_management_server.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RegisterResponseDTO {
    private String secretKey;
}
