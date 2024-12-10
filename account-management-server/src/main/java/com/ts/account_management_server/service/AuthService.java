package com.ts.account_management_server.service;

import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.repository.ServerInfoRepository;
import com.ts.account_management_server.repository.UserDeviceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private UserDeviceRepository userDeviceRepository;

    @Autowired
    private ServerInfoRepository serverInfoRepository;

    @Autowired
    private JwtService jwtService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public String login(
            UserDevice userDevice,
            String masterPassword,
            Map<String, String> deviceMetadata
    ) {
        // Check if masterPassword is correct
        boolean masterPasswordFlag = passwordEncoder.matches(
                masterPassword,
                serverInfoRepository
                        .findTopByOrderById()
                        .get()
                        .getMasterPassword()
        );

        // Check if same device
        boolean deviceMetadataFlag = userDevice
                .getMetadata()
                .equals(deviceMetadata);

        // Converge result into one flag
        boolean loginFlag = masterPasswordFlag && deviceMetadataFlag;
        if (!loginFlag) return null;

        // Generate Jwt Token
        String token = jwtService.generateToken(userDevice.getId());
        userDevice.setCurrentToken(token);
        userDeviceRepository.save(userDevice);

        return token;
    }
}
