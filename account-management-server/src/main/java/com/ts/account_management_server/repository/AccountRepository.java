package com.ts.account_management_server.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.ts.account_management_server.model.database.AbstractAccount;

@Repository
public interface AccountRepository extends MongoRepository<AbstractAccount, String> {
}
