package com.ts.account_management_server.model.database;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "config")
public class ServerInfo {
    @Id
    private String id;

    private boolean userDeviceAccessState;
    private String masterPassword;
    private List<String> deviceRegisterSecrets;

    @LastModifiedDate
    private LocalDateTime lastModifiedDate;
}
