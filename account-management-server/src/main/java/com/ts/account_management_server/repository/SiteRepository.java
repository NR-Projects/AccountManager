package com.ts.account_management_server.repository;

import com.ts.account_management_server.model.database.Site;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SiteRepository extends MongoRepository<Site, String> {

    @Query("{ name : ?0 }")
    Optional<Site> getSiteByName(String name);
}
