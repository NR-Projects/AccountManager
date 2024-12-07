package com.ts.account_management_server.repository;

import com.ts.account_management_server.model.database.ServerConfig;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ServerConfigRepository extends MongoRepository<ServerConfig, String> {
    Optional<ServerConfig> findTopByOrderById();  // Fetches the single configuration

}
