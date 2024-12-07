package com.ts.account_management_server.controller;

import com.ts.account_management_server.exceptions.AuthenticationException;
import com.ts.account_management_server.model.dto.LoginRequestDTO;
import com.ts.account_management_server.model.dto.LoginResponseDTO;
import com.ts.account_management_server.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public LoginResponseDTO login(
            @RequestBody LoginRequestDTO loginRequestDTO
    ) throws AuthenticationException {
        // Check credentials
        String jwtToken = authService.login(
                loginRequestDTO.getSecretKey(),
                loginRequestDTO.getMasterPassword(),
                loginRequestDTO.getDeviceMetadata()
        );

        if (jwtToken == null) throw new AuthenticationException();

        // Generate token
        return LoginResponseDTO
                .builder()
                .jwtToken(jwtToken)
                .build();
    }
    
}
