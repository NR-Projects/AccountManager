package com.ts.account_management_server.model.database;

import com.ts.account_management_server.model.enums.UserDeviceRole;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import java.util.Collection;
import java.util.List;
import java.util.Map;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "user-devices")
public class UserDevice {
    @Id
    private String id;

    @Indexed(unique = true)
    private String label;

    private UserDeviceRole role;

    private String currentToken;

    private Map<String, String> metadata;

    @Indexed(unique = true)
    private String secretKey;

    private int allowedTokenRequestCount;

    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }
}
