package com.ts.account_management_server.controller;

import com.ts.account_management_server.model.database.ServerConfig;
import com.ts.account_management_server.service.ServerConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/server-config")
public class ServerConfigController {

    @Autowired
    private ServerConfigService serverConfigService;

    @PostMapping("/add-register-secret")
    public void addRegisterSecret() {
        serverConfigService.addRegisterSecret();
    }

    @PostMapping("/disable-guest-requests")
    private void disableGuestRequest() {
        serverConfigService.changeGuestRequestState(false);
    }

    @PostMapping("/enable-guest-requests")
    private void enableGuestRequest() {
        serverConfigService.changeGuestRequestState(true);
    }

    @GetMapping("")
    private ServerConfig getServerConfig() {
        return serverConfigService.getServerConfig();
    }

    @PutMapping("/change-master-password")
    private void changeMasterPassword(@RequestBody String newMasterPassword) {
        serverConfigService.changeMasterPassword(newMasterPassword);
    }

    @DeleteMapping("/clear-data")
    private void clearData() {}
}