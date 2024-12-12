package com.ts.account_management_server.model.database.account_impl;

import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.enums.AccountType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "accounts")
@EqualsAndHashCode(callSuper = true)
public class UsernamePasswordAccount extends Account {

    private String username;
    private String password;

    @Override
    public AccountType getType() {
        return AccountType.USERNAME_PASSWORD;
    }
}
