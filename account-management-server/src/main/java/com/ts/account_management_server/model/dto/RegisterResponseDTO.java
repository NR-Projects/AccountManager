package com.ts.account_management_server.model.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class RegisterResponseDTO {
    public String secretKey;
}
