package com.ts.account_management_server.handler.impl;

import com.ts.account_management_server.handler.AccountHandler;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.service.EncryptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class UsernamePasswordAccountHandler extends AccountHandler {

    @Autowired
    private EncryptionService encryptionService;

    @Override
    public void createAccount(Account account) throws Exception {
        UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
        usernamePasswordAccount.setPassword(
                encryptionService.encrypt(usernamePasswordAccount.getPassword())
        );
        accountRepository.save(usernamePasswordAccount);
    }

    @Override
    public void updateAccount(Account account) {
        accountRepository.save(account);
    }

    @Override
    public String getPassword(Account account) throws Exception {
        UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
        return encryptionService.decrypt(usernamePasswordAccount.getPassword());
    }

    @Override
    public Account getFullAccount(Account accountFromRepository) throws Exception {
        UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) accountFromRepository;
        String decryptedPassword = encryptionService.decrypt(usernamePasswordAccount.getPassword());
        usernamePasswordAccount.setPassword(decryptedPassword);
        return usernamePasswordAccount;
    }
}
