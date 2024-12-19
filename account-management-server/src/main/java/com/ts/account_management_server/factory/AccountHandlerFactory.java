package com.ts.account_management_server.factory;

import com.ts.account_management_server.handler.AccountHandler;
import com.ts.account_management_server.handler.impl.LinkedAccountHandler;
import com.ts.account_management_server.handler.impl.PasswordOnlyAccountHandler;
import com.ts.account_management_server.handler.impl.UsernamePasswordAccountHandler;
import com.ts.account_management_server.model.enums.AccountType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class AccountHandlerFactory {

    private final UsernamePasswordAccountHandler usernamePasswordAccountHandler;
    private final LinkedAccountHandler linkedAccountHandler;
    private final PasswordOnlyAccountHandler passwordOnlyAccountHandler;

    @Autowired
    public AccountHandlerFactory(
            UsernamePasswordAccountHandler usernamePasswordAccountHandler,
            LinkedAccountHandler linkedAccountHandler,
            PasswordOnlyAccountHandler passwordOnlyAccountHandler
    ) {
        this.usernamePasswordAccountHandler = usernamePasswordAccountHandler;
        this.linkedAccountHandler = linkedAccountHandler;
        this.passwordOnlyAccountHandler = passwordOnlyAccountHandler;
    }


    public AccountHandler getAccountHandlerFromAccountType(AccountType accountType) {
        return switch (accountType) {
            case USERNAME_PASSWORD -> usernamePasswordAccountHandler;
            case LINKED -> linkedAccountHandler;
            case PASSWORD_ONLY -> passwordOnlyAccountHandler;
        };
    }
}
