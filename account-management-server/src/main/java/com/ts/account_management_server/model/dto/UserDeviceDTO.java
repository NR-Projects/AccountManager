package com.ts.account_management_server.model.dto;

import com.ts.account_management_server.model.enums.UserDeviceRole;
import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Builder
@Data
public class UserDeviceDTO {
    private String id;
    private String label;
    private String role;
    private Map<String, String> metadata;
    private int allowedTokenRequestCount;
}
