package com.ts.account_management_server.model.dto;

import lombok.Data;

@Data
public class AccountRequestDTO {
    private String id;
    private String accountType;
    private String label;
    private String notes;
    private String username;
    private String password;
    private String linkedAccountId;
}
