package com.ts.account_management_server.controller;

import com.ts.account_management_server.exceptions.NotFoundException;
import com.ts.account_management_server.exceptions.RequestException;
import com.ts.account_management_server.model.database.User;
import com.ts.account_management_server.model.database.UserRole;
import com.ts.account_management_server.model.dto.RegisterRequestDTO;
import com.ts.account_management_server.model.dto.RegisterResponseDTO;
import com.ts.account_management_server.model.dto.UserDTO;
import com.ts.account_management_server.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register-device")
    public RegisterResponseDTO registerUserDevice(
            @RequestBody RegisterRequestDTO registerRequestDTO
    ) throws RequestException {
        // Check if register secret is valid
        // If valid, consume the register secret
        boolean isSecretValid = userService.consumeRegisterSecret(registerRequestDTO.getRegisterSecret());

        if (!isSecretValid) throw new RequestException("Secret is invalid!");

        // Return Secret Key for the Device
        return RegisterResponseDTO
                .builder()
                .secretKey(
                        userService.selfDeviceRegistration(
                                registerRequestDTO.getDeviceMetadata()
                        ).getDevice().getSecretKey()
                )
                .build();
    }

    @GetMapping("/all")
    public List<UserDTO> allUsers() {
        return userService
                .getUsers()
                .stream()
                .map(UserDTO::fromUser)
                .toList();
    }

    @PutMapping("")
    public void updateUser(
            @RequestBody UserDTO userDTO
    ) throws NotFoundException {
        userService.updateUser(
                UserDTO.toUser(userDTO)
        );
    }

    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable String userId) {
        userService.deleteUser(userId);
    }
}
