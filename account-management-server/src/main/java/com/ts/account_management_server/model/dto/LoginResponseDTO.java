package com.ts.account_management_server.model.dto;

import com.ts.account_management_server.model.database.UserDevice;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LoginResponseDTO {
    private String jwtToken;
    private UserDeviceDTO userDeviceDTO;
}
