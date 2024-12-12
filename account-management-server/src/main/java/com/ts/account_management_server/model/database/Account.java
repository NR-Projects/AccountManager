package com.ts.account_management_server.model.database;

import com.ts.account_management_server.model.enums.AccountType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "accounts")
public abstract class Account {
    @Id
    private String id;

    private String label;

    @DBRef
    private Site site;

    private String notes;

    public abstract AccountType getType();
}
