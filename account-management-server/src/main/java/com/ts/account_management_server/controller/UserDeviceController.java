package com.ts.account_management_server.controller;

import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.RequestException;
import com.ts.account_management_server.mapper.UserDeviceMapper;
import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.model.dto.RegisterRequestDTO;
import com.ts.account_management_server.model.dto.RegisterResponseDTO;
import com.ts.account_management_server.model.dto.UserDeviceDTO;
import com.ts.account_management_server.service.UserDeviceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user-device")
public class UserDeviceController {
    @Autowired
    private UserDeviceService userDeviceService;

    @PostMapping("/register")
    public RegisterResponseDTO registerUserDevice(
            @RequestBody RegisterRequestDTO registerRequestDTO
    ) throws RequestException {
        // Check if register secret is valid
        // If valid, consume the register secret
        boolean isSecretValid = userDeviceService.consumeRegisterSecret(registerRequestDTO.getRegisterSecret());
        if (!isSecretValid) throw new RequestException("Secret is invalid!");

        // Return Secret Key for the Device
        return RegisterResponseDTO
                .builder()
                .secretKey(
                        userDeviceService.register(
                                registerRequestDTO.getDeviceMetadata()
                        ).getSecretKey()
                )
                .build();
    }

    @GetMapping("/all")
    public List<UserDeviceDTO> allUsers() {
        return userDeviceService
                .getUsers()
                .stream()
                .map(UserDeviceMapper::toDTO)
                .toList();
    }

    @PutMapping("")
    public void updateUser(
            @RequestBody UserDeviceDTO userDeviceDTO
    ) throws EntityException {
        userDeviceService.updateUserDevice(
                UserDeviceMapper.toEntity(userDeviceDTO)
        );
    }

    @DeleteMapping("/{userId}")
    public void deleteUser(@PathVariable String userId) {
        userDeviceService.deleteUser(userId);
    }
}
