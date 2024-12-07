package com.ts.account_management_server.model.database;

import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Document(collection = "sites")
public class Site {
    @Id
    private String id;

    private String name;
    private String link;

    @DBRef(lazy = true)
    private List<AbstractAccount> accounts;
}
