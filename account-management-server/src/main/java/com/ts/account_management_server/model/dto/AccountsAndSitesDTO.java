package com.ts.account_management_server.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class AccountsAndSitesDTO {
    private List<AccountResponseDTO> accountResponseDTOList;
    private List<String> siteNameList;
}
