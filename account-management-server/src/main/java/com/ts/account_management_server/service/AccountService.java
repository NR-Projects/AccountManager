package com.ts.account_management_server.service;

import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.factory.AccountHandlerFactory;
import com.ts.account_management_server.handler.AccountHandler;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AccountService {

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private AccountHandlerFactory accountHandlerFactory;

    public void createAccount(Account account) throws Exception {
        account.setId(null);

        AccountHandler accountHandler = accountHandlerFactory.getAccountHandlerFromAccountType(account.getType());
        accountHandler.createAccount(account);
    }

    public List<Account> getAccounts() {
        return accountRepository.findAll();
    }

    public Account getFullAccount(String accountId) throws Exception {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account not found!");
        Account account = optionalAccount.get();

        AccountHandler accountHandler = accountHandlerFactory.getAccountHandlerFromAccountType(account.getType());
        return accountHandler.getFullAccount(account);
    }

    public String getPassword(Account account) throws Exception {
        AccountHandler accountHandler = accountHandlerFactory.getAccountHandlerFromAccountType(account.getType());
        return accountHandler.getPassword(account);
    }

    public void updateAccount(Account account) throws Exception {
        AccountHandler accountHandler = accountHandlerFactory.getAccountHandlerFromAccountType(account.getType());
        accountHandler.updateAccount(account);
    }

    public void deleteAccount(String accountId) throws BaseException {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account with accountId not found");

        if (accountRepository.isUsedByOtherAccounts(accountId)) {
            throw new LinkException("Account is linked to other accounts, remove links first before deleting!");
        }
        accountRepository.deleteById(accountId);
    }
}
