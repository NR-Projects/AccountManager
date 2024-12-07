package com.ts.account_management_server.model.database;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Device {

    // Label for easy identification on admin side
    // Device Identifier
    @Indexed(unique = true)
    private String label;
    
    // Generated secret key for the device
    // Secret Key
    @Indexed(unique = true)
    private String secretKey;

    // Device metadata (e.g. Device info, OS version)
    private Map<String, String> metadata;

    // Device access restrictions
    private int allowedTokenRequestCount;
}