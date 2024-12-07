package com.ts.account_management_server.model.database;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Document(collection = "accounts")
public abstract class AbstractAccount {
    @Id
    private String id;

    @DBRef
    private Site site;

    private String label;
    private String notes;
}
