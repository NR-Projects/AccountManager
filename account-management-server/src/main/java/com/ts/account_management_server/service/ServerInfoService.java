package com.ts.account_management_server.service;

import com.ts.account_management_server.model.database.ServerInfo;
import com.ts.account_management_server.repository.ServerInfoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ServerInfoService {

    @Autowired
    private ServerInfoRepository serverInfoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void initializeServer() {
        if (serverInfoRepository.count() == 0) {
            ServerInfo serverInfo = new ServerInfo();
            serverInfo.setMasterPassword(passwordEncoder.encode("12345"));
            serverInfo.setUserDeviceAccessState(true);
            serverInfo.setDeviceRegisterSecrets(List.of("adminDeviceSecret123"));
            serverInfoRepository.save(serverInfo);
        }
    }
}
