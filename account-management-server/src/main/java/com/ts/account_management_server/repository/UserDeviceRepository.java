package com.ts.account_management_server.repository;

import com.ts.account_management_server.model.database.UserDevice;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserDeviceRepository extends MongoRepository<UserDevice, String> {
    @Query("{ 'secretKey' : ?0 }")
    Optional<UserDevice> findBySecretKey(String secretKey);
}
