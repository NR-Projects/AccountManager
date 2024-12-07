package com.ts.account_management_server.model.dto;

import com.ts.account_management_server.model.database.Device;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.mongodb.core.index.Indexed;

import java.util.Map;

@Data
@Builder
public class DeviceDTO {
    private String label;
    private Map<String, String> metadata;
    private int allowedTokenRequestCount;

    public static DeviceDTO fromDevice(Device device) {
        return DeviceDTO.builder()
                .label(device.getLabel())
                .metadata(device.getMetadata())
                .allowedTokenRequestCount(device.getAllowedTokenRequestCount())
                .build();
    }

    public static Device toDevice(DeviceDTO deviceDTO) {
        Device device = new Device();
        device.setLabel(deviceDTO.getLabel());
        device.setMetadata(deviceDTO.getMetadata());
        device.setAllowedTokenRequestCount(deviceDTO.getAllowedTokenRequestCount());
        return device;
    }
}
