package com.ts.account_management_server.model.database;

import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Data
@Document(collection = "accounts")
public class LinkedAccount extends AbstractAccount {
    @DBRef
    public AbstractAccount account;
}
