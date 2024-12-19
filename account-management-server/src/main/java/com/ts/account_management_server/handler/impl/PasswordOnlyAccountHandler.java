package com.ts.account_management_server.handler.impl;

import com.ts.account_management_server.handler.AccountHandler;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.PasswordOnlyAccount;
import com.ts.account_management_server.service.EncryptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PasswordOnlyAccountHandler extends AccountHandler {

    @Autowired
    private EncryptionService encryptionService;

    @Override
    public void createAccount(Account account) throws Exception {
        PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
        passwordOnlyAccount.setPassword(
                encryptionService.encrypt(passwordOnlyAccount.getPassword())
        );
        accountRepository.save(passwordOnlyAccount);
    }

    @Override
    public void updateAccount(Account account) throws Exception {
        PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
        passwordOnlyAccount.setPassword(
                encryptionService.encrypt(passwordOnlyAccount.getPassword())
        );
        accountRepository.save(passwordOnlyAccount);
    }

    @Override
    public String getPassword(Account account) throws Exception {
        PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
        return encryptionService.decrypt(passwordOnlyAccount.getPassword());
    }

    @Override
    public Account getFullAccount(Account accountFromRepository) throws Exception {
        PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) accountFromRepository;
        String decryptedPassword = encryptionService.decrypt(passwordOnlyAccount.getPassword());
        passwordOnlyAccount.setPassword(decryptedPassword);
        return passwordOnlyAccount;
    }
}
