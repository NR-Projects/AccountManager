package com.ts.account_management_server.service;

import com.ts.account_management_server.model.database.User;
import com.ts.account_management_server.repository.ServerConfigRepository;
import com.ts.account_management_server.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private ServerConfigRepository serverRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JwtService jwtService;

    public String login(
            String secretKey,
            String masterPassword,
            Map<String, String> deviceMetadata
    ) {
        // Find User by label
        Optional<User> optUser = userRepository.findBySecretKey(secretKey);
        if (optUser.isEmpty()) return null;

        User user = optUser.get();

        // Check if same secretKey
        boolean secretKeyFlag = user
                .getDevice()
                .getSecretKey()
                .equals(secretKey);

        // Check if masterPassword is correct
        boolean masterPasswordFlag = serverRepository
                .findTopByOrderById()
                .get()
                .getMasterPassword()
                .equals(masterPassword);

        // Check if same device
        boolean deviceMetadataFlag = user
                .getDevice()
                .getMetadata()
                .equals(deviceMetadata);

        boolean loginFlag = secretKeyFlag && masterPasswordFlag && deviceMetadataFlag;

        if (!loginFlag) return null;

        // Generate Jwt Token
        String token = jwtService.generateToken(user);
        user.setCurrentToken(token);
        userRepository.save(user);

        return token;
    }
}
