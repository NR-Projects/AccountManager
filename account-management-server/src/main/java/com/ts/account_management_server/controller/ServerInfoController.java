package com.ts.account_management_server.controller;

import com.ts.account_management_server.mapper.ServerInfoMapper;
import com.ts.account_management_server.model.database.ServerInfo;
import com.ts.account_management_server.model.dto.ServerInfoDTO;
import com.ts.account_management_server.service.ServerInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/server-config")
public class ServerInfoController {
    @Autowired
    private ServerInfoService serverInfoService;

    @PostMapping("/add-register-secret")
    public void addRegisterSecret() {
        serverInfoService.addRegisterSecret();
    }

    @PostMapping("/disable-user-requests")
    private void disableUserRequest() {
        serverInfoService.changeUserDeviceAccessState(false);
    }

    @PostMapping("/enable-user-requests")
    private void enableUserRequest() {
        serverInfoService.changeUserDeviceAccessState(true);
    }

    @GetMapping("")
    private ServerInfoDTO getServerConfig() {
        return ServerInfoMapper.toDTO(serverInfoService.getServerInfo());
    }
    @PutMapping("/change-master-password")
    private void changeMasterPassword(@RequestBody String newMasterPassword) {
        serverInfoService.changeMasterPassword(newMasterPassword);
    }
    @DeleteMapping("/clear-data")
    private void clearData() {}
}
