package com.ts.account_management_server.model.dto;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class AccountResponseDTO {
    private String id;
    private String siteName;
    private String accountType;
    private String label;
    private String notes;
    private String username;
    private String linkedAccountId;
}
