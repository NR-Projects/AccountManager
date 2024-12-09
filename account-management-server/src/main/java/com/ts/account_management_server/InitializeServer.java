package com.ts.account_management_server;

import com.ts.account_management_server.service.ServerInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class InitializeServer implements CommandLineRunner {

    @Autowired
    private ServerInfoService serverInfoService;

    @Override
    public void run(String... args) throws Exception {
        serverInfoService.initializeServer();
    }
}
