package com.ts.account_management_server.mapper;

import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.model.dto.UserDeviceDTO;
import com.ts.account_management_server.model.enums.UserDeviceRole;

public class UserDeviceMapper {

    public static UserDeviceDTO toDTO(UserDevice userDevice) {
        return UserDeviceDTO
                .builder()
                .id(userDevice.getId())
                .role(userDevice.getRole().name())
                .label(userDevice.getLabel())
                .metadata(userDevice.getMetadata())
                .allowedTokenRequestCount(userDevice.getAllowedTokenRequestCount())
                .build();
    }

    public static UserDevice toEntity(UserDeviceDTO userDeviceDTO) {
        UserDevice userDevice = new UserDevice();
        userDevice.setId(userDeviceDTO.getId());
        userDevice.setRole(UserDeviceRole.valueOf(userDeviceDTO.getRole()));
        userDevice.setLabel(userDeviceDTO.getLabel());
        userDevice.setMetadata(userDeviceDTO.getMetadata());
        userDevice.setAllowedTokenRequestCount(userDeviceDTO.getAllowedTokenRequestCount());
        return userDevice;
    }
}
