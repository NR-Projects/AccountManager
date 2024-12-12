package com.ts.account_management_server.factory;

import com.ts.account_management_server.exception.EntityException;
import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.database.account_impl.LinkedAccount;
import com.ts.account_management_server.model.database.account_impl.PasswordOnlyAccount;
import com.ts.account_management_server.model.database.account_impl.UsernamePasswordAccount;
import com.ts.account_management_server.model.dto.AccountRequestDTO;
import com.ts.account_management_server.model.enums.AccountType;
import com.ts.account_management_server.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class AccountFactory {

    @Autowired
    private AccountRepository accountRepository;

    public Account getAccountFromDTO(AccountRequestDTO accountRequestDTO) throws EntityException {
        AccountType accountType = AccountType.valueOf(accountRequestDTO.getAccountType());

        Account account = switch (accountType) {
            case USERNAME_PASSWORD -> constructUsernamePassword(
                    accountRequestDTO.getUsername(),
                    accountRequestDTO.getPassword()
            );
            case LINKED -> constructLinked(
                    accountRequestDTO.getLinkedAccountId()
            );
            case PASSWORD_ONLY -> constructPasswordOnly(
                    accountRequestDTO.getPassword()
            );
        };

        account.setId(accountRequestDTO.getId());
        account.setLabel(accountRequestDTO.getLabel());
        account.setNotes(accountRequestDTO.getNotes());

        return account;
    }

    public Account getAccountFromId(String accountId) throws EntityException {
        Optional<Account> optionalAccount = accountRepository.findById(accountId);
        if (optionalAccount.isEmpty()) throw EntityException.NotFound("Account does not exists");
        return optionalAccount.get();
    }

    private Account constructUsernamePassword(String username, String password) {
        return new UsernamePasswordAccount(username, password);
    }

    private Account constructLinked(String linkAccountId) throws EntityException {
        // Search account with linkAccountId
        Optional<Account> accountOptional = accountRepository.findById(linkAccountId);
        if (accountOptional.isEmpty()) throw EntityException.NotFound("Account with given link id was not found");

        return new LinkedAccount(accountOptional.get());
    }

    private Account constructPasswordOnly(String password) {
        return new PasswordOnlyAccount(password);
    }
}
