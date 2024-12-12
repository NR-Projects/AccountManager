package com.ts.account_management_server.model.database.account_impl;

import com.ts.account_management_server.model.database.Account;
import com.ts.account_management_server.model.enums.AccountType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "accounts")
public class LinkedAccount extends Account {

    @DBRef
    private Account linkedAccount;

    @Override
    public AccountType getType() {
        return AccountType.LINKED;
    }
}
