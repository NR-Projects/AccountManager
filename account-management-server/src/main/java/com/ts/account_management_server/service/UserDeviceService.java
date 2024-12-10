package com.ts.account_management_server.service;

import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.model.database.ServerInfo;
import com.ts.account_management_server.model.database.UserDevice;
import com.ts.account_management_server.model.enums.UserDeviceRole;
import com.ts.account_management_server.repository.ServerInfoRepository;
import com.ts.account_management_server.repository.UserDeviceRepository;
import com.ts.account_management_server.util.RandomStringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserDeviceService {
    @Autowired
    private ServerInfoRepository serverInfoRepository;

    @Autowired
    private UserDeviceRepository userDeviceRepository;

    public boolean consumeRegisterSecret(String registerSecret) {
        ServerInfo serverInfo = serverInfoRepository.findTopByOrderById().get();
        boolean isSecretPresent = serverInfo.getDeviceRegisterSecrets().remove(registerSecret);
        serverInfoRepository.save(serverInfo);
        return isSecretPresent;
    }

    public UserDevice register(
            Map<String, String> deviceMetadata
    ) {
        // Generate Secret Key
        String secretKey = RandomStringUtil.generateRandomString(500);

        // Create new UserDevice
        UserDevice userDevice = new UserDevice();
        userDevice.setRole(UserDeviceRole.PENDING);
        userDevice.setCurrentToken("");
        userDevice.setMetadata(deviceMetadata);
        userDevice.setSecretKey(secretKey);
        userDevice.setAllowedTokenRequestCount(0);

        UserDevice savedUserDevice = userDeviceRepository.save(userDevice);

        // Use generated id to set label
        savedUserDevice.setLabel(
                String.format(
                        "NewDeviceLabel_%s",
                        savedUserDevice.getId()
                )
        );

        userDeviceRepository.save(savedUserDevice);

        return savedUserDevice;
    }

    public UserDevice getUserDeviceById(String id) {
        return userDeviceRepository.findById(id).get();
    }

    public List<UserDevice> getUsers() {
        return userDeviceRepository.findAll();
    }

    public void updateUserDevice(UserDevice updatedUserDevice) throws EntityException {
        Optional<UserDevice> optUserDev = userDeviceRepository.findById(updatedUserDevice.getId());
        if (optUserDev.isEmpty()) throw EntityException.NotFound("User Device does not exist");

        UserDevice oldUserDevice = optUserDev.get();

        // Do not allow overwrite id
        updatedUserDevice.setId(oldUserDevice.getId());

        // Do not allow overwrite token
        updatedUserDevice.setCurrentToken(oldUserDevice.getCurrentToken());

        // Do not allow overwrite secret key
        updatedUserDevice.setSecretKey(oldUserDevice.getSecretKey());

        userDeviceRepository.save(updatedUserDevice);
    }

    public void deleteUser(String id) {
        userDeviceRepository.deleteById(id);
    }
}
