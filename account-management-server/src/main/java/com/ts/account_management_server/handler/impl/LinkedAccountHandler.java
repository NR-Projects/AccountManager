package com.ts.account_management_server.handler.impl;

import com.ts.account_management_server.exception.LinkException;
import com.ts.account_management_server.handler.AccountHandler;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import org.springframework.stereotype.Component;

import java.util.HashSet;

@Component
public class LinkedAccountHandler extends AccountHandler {

    @Override
    public void createAccount(Account account) {
        LinkedAccount linkedAccount = (LinkedAccount) account;
        accountRepository.save(linkedAccount);
    }

    @Override
    public void updateAccount(Account account) throws LinkException {
        LinkedAccount linkedAccount = (LinkedAccount) account;
        checkForSelfReference(linkedAccount.getId(), linkedAccount.getLinkedAccount().getId());
        checkForCircularReference(linkedAccount.getId(), linkedAccount.getLinkedAccount());
        accountRepository.save(linkedAccount);
    }

    @Override
    public String getPassword(Account account) throws Exception {
        return null;
    }

    @Override
    public Account getFullAccount(Account accountFromRepository) {
        return accountFromRepository;
    }

    private void checkForSelfReference(String accountId, String accountLinkedId) throws LinkException {
        if (accountId.equals(accountLinkedId)) {
            throw new LinkException("Linked account cannot reference itself");
        }
    }

    private void checkForCircularReference(String accountId, Account accountLinked) throws LinkException {
        // Using a HashSet to track visited accounts (IDs)
        HashSet<String> visited = new HashSet<>();
        visited.add(accountId);
        Account current = accountLinked;

        // Traverse the linked accounts to check for circular reference
        while (current != null) {
            // If we've already visited this account, it's a circular reference
            if (!visited.add(current.getId())) {
                throw new LinkException("Circular reference detected in linked accounts");
            }

            // Cast current to LinkedAccount to access its linkedAccount field
            if (current instanceof LinkedAccount) {
                current = ((LinkedAccount) current).getLinkedAccount();
            } else {
                break;  // If it's not a LinkedAccount, break out of the loop
            }
        }
    }
}
