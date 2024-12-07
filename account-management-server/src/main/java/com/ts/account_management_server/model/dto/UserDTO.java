package com.ts.account_management_server.model.dto;

import com.ts.account_management_server.model.database.Device;
import com.ts.account_management_server.model.database.User;
import com.ts.account_management_server.model.database.UserRole;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDTO {
    private String id;

    private Device device;
    private String role;

    public static UserDTO fromUser(User user) {
        return UserDTO.builder()
                .id(user.getId())
                .device(user.getDevice())
                .role(user.getRole().name())
                .build();
    }

    public static User toUser(UserDTO userDTO) {
        User user = new User();
        user.setId(userDTO.getId());
        user.setRole(UserRole.valueOf(userDTO.getRole()));
        user.setDevice(userDTO.getDevice());
        return user;
    }
}
