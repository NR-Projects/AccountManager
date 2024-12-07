package com.ts.account_management_server.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import com.ts.account_management_server.model.database.User;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    
    @Query("{ 'device.label' : ?0 }")
    Optional<User> findByDeviceLabel(String label);

    @Query("{ 'role' : ?0 }")
    List<User> findAllUsersByRole(String role);

    @Query("{ 'device.secretKey' : ?0 }")
    Optional<User> findBySecretKey(String secretKey);
}
