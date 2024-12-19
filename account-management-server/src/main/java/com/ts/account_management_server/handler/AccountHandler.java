package com.ts.account_management_server.handler;

import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public abstract class AccountHandler {

    @Autowired
    protected AccountRepository accountRepository;

    public abstract void createAccount(Account account) throws Exception;
    public abstract void updateAccount(Account account) throws Exception;
    public abstract String getPassword(Account account) throws Exception;
    public abstract Account getFullAccount(Account accountFromRepository) throws Exception;
}
