package com.ts.account_management_server.repository;

import com.ts.account_management_server.model.database.Site;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SiteRepository extends MongoRepository<Site, String> {
}
