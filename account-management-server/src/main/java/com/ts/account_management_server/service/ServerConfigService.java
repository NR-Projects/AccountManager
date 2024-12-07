package com.ts.account_management_server.service;

import com.ts.account_management_server.model.database.ServerConfig;
import com.ts.account_management_server.repository.ServerConfigRepository;
import com.ts.account_management_server.util.RandomStringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ServerConfigService {

    @Autowired
    private ServerConfigRepository serverConfigRepository;

    public void initializeServerConfiguration() {
        if (serverConfigRepository.count() == 0) {
            ServerConfig defaultConfig = new ServerConfig();
            defaultConfig.setMasterPassword("default-master-password");
            defaultConfig.setGuestRequestState(true);
            defaultConfig.setLastUpdated(LocalDateTime.now());
            defaultConfig.setDeviceRegisterSecrets(List.of("123456790"));

            serverConfigRepository.save(defaultConfig);
        }
    }

    public void addRegisterSecret() {

        // Generate random string
        String registerSecret = RandomStringUtil.generateRandomString(20);

        // Save it on database
        ServerConfig serverConfig = serverConfigRepository.findTopByOrderById().get();
        serverConfig.getDeviceRegisterSecrets().add(registerSecret);
        serverConfigRepository.save(serverConfig);

    }

    public ServerConfig getServerConfig() {
        return serverConfigRepository.findTopByOrderById().get();
    }

    public void changeGuestRequestState(boolean newState) {
        ServerConfig serverConfig = serverConfigRepository.findTopByOrderById().get();
        serverConfig.setGuestRequestState(newState);
        serverConfigRepository.save(serverConfig);
    }

    public void changeMasterPassword(String newMasterPassword) {
        ServerConfig serverConfig = serverConfigRepository.findTopByOrderById().get();
        serverConfig.setMasterPassword(newMasterPassword);
        serverConfigRepository.save(serverConfig);
    }
}
