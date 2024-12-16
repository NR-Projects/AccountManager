package com.ts.account_management_server.mapper;

import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.model.database.account_impl.PasswordOnlyAccount;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.model.dto.AccountResponseDTO;

public class AccountMapper {
    public static AccountResponseDTO toDTO(Account account) {
        AccountResponseDTO accountResponseDTO = new AccountResponseDTO();
        accountResponseDTO.setId(account.getId());
        accountResponseDTO.setLabel(account.getLabel());
        accountResponseDTO.setAccountType(account.getType().name());
        accountResponseDTO.setNotes(account.getNotes());
        accountResponseDTO.setSiteName(account.getSite().getName());

        mapAccountSpecificFields(account, accountResponseDTO, false);

        return accountResponseDTO;
    }

    public static AccountResponseDTO toDTOwithSensitiveInfo(Account account) {
        AccountResponseDTO accountResponseDTO = new AccountResponseDTO();
        accountResponseDTO.setId(account.getId());
        accountResponseDTO.setLabel(account.getLabel());
        accountResponseDTO.setAccountType(account.getType().name());
        accountResponseDTO.setNotes(account.getNotes());
        accountResponseDTO.setSiteName(account.getSite().getName());

        mapAccountSpecificFields(account, accountResponseDTO, true);

        return accountResponseDTO;
    }

    // Helper method to handle account type-specific logic and update the DTO
    private static void mapAccountSpecificFields(Account account, AccountResponseDTO accountResponseDTO, boolean includeSensitiveInfo) {
        switch (account.getType()) {
            case USERNAME_PASSWORD -> {
                UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
                accountResponseDTO.setUsername(usernamePasswordAccount.getUsername());
                if (includeSensitiveInfo) {
                    accountResponseDTO.setPassword(usernamePasswordAccount.getPassword());
                }
            }
            case LINKED -> {
                LinkedAccount linkedAccount = (LinkedAccount) account;
                accountResponseDTO.setLinkedAccountId(linkedAccount.getLinkedAccount().getId());
            }
            case PASSWORD_ONLY -> {
                PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;

                if (includeSensitiveInfo) {
                    accountResponseDTO.setPassword(passwordOnlyAccount.getPassword());
                }
            }
        }
    }
}
