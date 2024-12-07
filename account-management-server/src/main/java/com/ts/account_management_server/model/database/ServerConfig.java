package com.ts.account_management_server.model.database;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "server_config")
public class ServerConfig {
    @Id
    private String id;  // This will be used to store the only configuration document.

    private String masterPassword;              // Default master password for devices
    private boolean guestRequestState;    // If the server is allowed to send information
    private LocalDateTime lastUpdated;          // Time of the last configuration update

    private List<String> deviceRegisterSecrets;        // List of register secrets for device registration
}