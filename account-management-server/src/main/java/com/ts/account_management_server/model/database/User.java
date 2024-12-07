package com.ts.account_management_server.model.database;

import java.util.Collection;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "user_devices")
public class User implements UserDetails {

    @Id
    private String id;

    private Device device;
    private UserRole role;

    // Jwt token given to the user
    private String currentToken;


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // Assign authorities based on the role
        return List.of(new SimpleGrantedAuthority(role.toString()));
    }

    @Override
    public String getUsername() {
        return device.getLabel();
    }

    @Override
    public String getPassword() {
        return device.getSecretKey();
    }

    @Override
    public boolean isEnabled() {
        // Ensure the device's status controls user access
        return device.getAllowedTokenRequestCount() > 0;
    }
}