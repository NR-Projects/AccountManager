package com.ts.account_management_server.mapper;

import com.ts.account_management_server.model.database.ServerInfo;
import com.ts.account_management_server.model.dto.ServerInfoDTO;

public class ServerInfoMapper {
    public static ServerInfoDTO toDTO(ServerInfo serverInfo) {
        return ServerInfoDTO
                .builder()
                .id(serverInfo.getId())
                .userDeviceAccessState(serverInfo.isUserDeviceAccessState())
                .lastModifiedDate(serverInfo.getLastModifiedDate())
                .deviceRegisterSecrets(serverInfo.getDeviceRegisterSecrets())
                .build();
    }
    public static ServerInfo toEntity(ServerInfoDTO serverInfoDTO) {
        ServerInfo serverInfo = new ServerInfo();
        serverInfo.setId(serverInfoDTO.getId());
        serverInfo.setDeviceRegisterSecrets(serverInfoDTO.getDeviceRegisterSecrets());
        return serverInfo;
    }
}
