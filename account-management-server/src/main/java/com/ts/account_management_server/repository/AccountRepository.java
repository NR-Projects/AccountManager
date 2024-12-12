package com.ts.account_management_server.repository;

import com.ts.account_management_server.model.database.Account;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepository extends MongoRepository<Account, String> {

    @Query(value = "{ 'linkedAccount.$id' : ObjectId(?0) }", exists = true)
    boolean isUsedByOtherAccounts(String linkedAccountId);
}
