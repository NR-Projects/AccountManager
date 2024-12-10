package com.ts.account_management_server.controller;

import com.ts.account_management_server.exception.AuthException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.mapper.UserDeviceMapper;
import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.model.dto.LoginRequestDTO;
import com.ts.account_management_server.model.dto.LoginResponseDTO;
import com.ts.account_management_server.service.AuthService;
import com.ts.account_management_server.service.UserDeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserDeviceService userDeviceService;

    @PostMapping("/login")
    public LoginResponseDTO login(
            @RequestBody LoginRequestDTO loginRequestDTO
    ) throws AuthException, EntityException {

        // Get UserDevice
        Optional<UserDevice> optUserDevice = userDeviceService.getUserDeviceBySecretKey(loginRequestDTO.getSecretKey());
        if(optUserDevice.isEmpty()) throw EntityException.NotFound("UserDevice not found!");
        UserDevice userDevice = optUserDevice.get();

        // Check credentials
        String jwtToken = authService.login(
                userDevice,
                loginRequestDTO.getMasterPassword(),
                loginRequestDTO.getDeviceMetadata()
        );
        if (jwtToken == null) throw AuthException.Authentication();

        // Generate token
        return LoginResponseDTO
                .builder()
                .jwtToken(jwtToken)
                .userDeviceDTO(UserDeviceMapper.toDTO(userDevice))
                .build();
    }
}
