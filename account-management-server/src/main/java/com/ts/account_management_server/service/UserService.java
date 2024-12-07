package com.ts.account_management_server.service;

import com.ts.account_management_server.exceptions.NotFoundException;
import com.ts.account_management_server.model.database.Device;
import com.ts.account_management_server.model.database.ServerConfig;
import com.ts.account_management_server.model.database.User;
import com.ts.account_management_server.model.database.UserRole;
import com.ts.account_management_server.repository.ServerConfigRepository;
import com.ts.account_management_server.repository.UserRepository;
import com.ts.account_management_server.util.RandomStringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private ServerConfigRepository serverConfigRepository;

    @Autowired
    private UserRepository userRepository;

    public boolean consumeRegisterSecret(String registerSecret) {
        ServerConfig serverConfig = serverConfigRepository.findTopByOrderById().get();
        boolean isSecretPresent = serverConfig.getDeviceRegisterSecrets().remove(registerSecret);
        serverConfigRepository.save(serverConfig);

        return isSecretPresent;
    }

    public User selfDeviceRegistration(
            Map<String, String> deviceMetadata
    ) {
        // Generate Secret Key
        String secretKey = RandomStringUtil.generateRandomString(200);

        // Create new User
        User user = new User();
        user.setCurrentToken("");
        Device device = new Device();
        device.setMetadata(deviceMetadata);
        device.setSecretKey(secretKey);
        device.setAllowedTokenRequestCount(0);

        user.setDevice(device);
        user.setRole(UserRole.PENDING);

        User savedUser = userRepository.save(user);

        // Use generated id to set label
        savedUser.getDevice().setLabel(
                String.format(
                        "DeviceLabel_%s",
                        savedUser.getId()
                )
        );

        return userRepository.save(savedUser);
    }

    public User getUserById(String id) {
        return userRepository.findById(id).get();
    }

    public List<User> getUsers() {
        return userRepository.findAll();
    }

    public void updateUser(User newUser) throws NotFoundException {
        Optional<User> optUser = userRepository.findById(newUser.getId());

        if (optUser.isEmpty()) throw new NotFoundException();

        User oldUser = optUser.get();

        // Do not allow overwrite token
        newUser.setCurrentToken(oldUser.getCurrentToken());

        // Do not allow overwrite secret key
        newUser.getDevice().setSecretKey(oldUser.getDevice().getSecretKey());

        userRepository.save(newUser);
    }

    public void deleteUser(String id) {
        userRepository.deleteById(id);
    }
}
