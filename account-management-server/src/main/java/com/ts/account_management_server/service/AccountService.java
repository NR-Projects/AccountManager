package com.ts.account_management_server.service;


import com.ts.account_management_server.exception.BaseException;
import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.model.database.account_impl.PasswordOnlyAccount;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.model.enums.AccountType;
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
    private EncryptionService encryptionService;

    public void createAccount(Account account) throws Exception {
        account.setId(null);
        Account encryptedAccount = encryptImportantDetails(account);
        accountRepository.save(encryptedAccount);
    }

    public List<Account> getAccounts() {
        return accountRepository.findAll();
    }

    public Account getFullAccount(String accountId) throws Exception {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account not found!");
        Account account = optionalAccount.get();

        return switch (account.getType()) {
            case USERNAME_PASSWORD -> {
                UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
                String decryptedPassword = encryptionService.decrypt(usernamePasswordAccount.getPassword());
                usernamePasswordAccount.setPassword(decryptedPassword);
                yield usernamePasswordAccount;
            }
            case PASSWORD_ONLY -> {
                PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
                String decryptedPassword = encryptionService.decrypt(passwordOnlyAccount.getPassword());
                passwordOnlyAccount.setPassword(decryptedPassword);
                yield passwordOnlyAccount;
            }
            default -> account;
        };
    }

    public String getPassword(Account account) throws Exception {
        String password;

        switch (account.getType()) {
            case USERNAME_PASSWORD -> {
                UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
                password = encryptionService.decrypt(usernamePasswordAccount.getPassword());
            }
            case PASSWORD_ONLY -> {
                PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
                password = encryptionService.decrypt(passwordOnlyAccount.getPassword());
            }
            default -> {
                password = "";
            }
        }

        return password;
    }

    public void updateAccount(Account account) throws Exception {
        Account encryptedAccount = encryptImportantDetails(account);
        accountRepository.save(encryptedAccount);
    }

    public void deleteAccount(String accountId) throws BaseException {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account with accountId not found");

        if (accountRepository.isUsedByOtherAccounts(accountId)) {
            throw new LinkException("Account is linked to other accounts, remove links first before deleting!");
        }
        accountRepository.deleteById(accountId);
    }

    private Account encryptImportantDetails(Account account) throws Exception {
        return switch (account.getType()) {
            case USERNAME_PASSWORD -> {
                UsernamePasswordAccount usernamePasswordAccount = (UsernamePasswordAccount) account;
                usernamePasswordAccount.setPassword(
                        encryptionService.encrypt(usernamePasswordAccount.getPassword())
                );
                yield usernamePasswordAccount;
            }
            case LINKED -> account;
            case PASSWORD_ONLY -> {
                PasswordOnlyAccount passwordOnlyAccount = (PasswordOnlyAccount) account;
                passwordOnlyAccount.setPassword(
                        encryptionService.encrypt(passwordOnlyAccount.getPassword())
                );
                yield passwordOnlyAccount;
            }
        };
    }
}
