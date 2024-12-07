package com.ts.account_management_server;

import com.ts.account_management_server.service.ServerConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class Initializer implements CommandLineRunner {

    @Autowired
    private ServerConfigService serverConfigService;

    @Override
    public void run(String... args) throws Exception {
        serverConfigService.initializeServerConfiguration();
    }
}
