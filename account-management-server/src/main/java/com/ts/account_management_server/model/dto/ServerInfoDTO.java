package com.ts.account_management_server.model.dto;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ServerInfoDTO {
    private String id;
    private boolean userDeviceAccessState;
    private List<String> deviceRegisterSecrets;
    private LocalDateTime lastModifiedDate;
}
