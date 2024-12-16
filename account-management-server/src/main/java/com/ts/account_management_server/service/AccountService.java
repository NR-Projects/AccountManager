package com.ts.account_management_server.service;


import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.model.database.account_impl.PasswordOnlyAccount;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AccountService {

    @Autowired
    private AccountRepository accountRepository;

    public void createAccount(Account account) {
        account.setId(null);
        accountRepository.save(account);
    }

    public List<Account> getAccounts() {
        return accountRepository.findAll();
    }

    public String getPassword(Account account) {
        String password;

        switch (account.getType()) {
            case USERNAME_PASSWORD -> {
                UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
                password = usernamePasswordAccount.getPassword();
            }
            case PASSWORD_ONLY -> {
                PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
                password = passwordOnlyAccount.getPassword();
            }
            default -> {
                password = "";
            }
        }

        return password;
    }

    public void updateAccount(Account account) {
        accountRepository.save(account);
    }
    public void deleteAccount(String accountId) throws BaseException {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account with accountId not found");

        if (accountRepository.isUsedByOtherAccounts(accountId)) {
            throw new LinkException("Account is linked to other accounts, remove links first before deleting!");
        }
        accountRepository.deleteById(accountId);}
}
