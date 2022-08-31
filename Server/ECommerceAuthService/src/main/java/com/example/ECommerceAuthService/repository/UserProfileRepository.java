package com.example.ECommerceAuthService.repository;

import com.example.ECommerceAuthService.model.UserProfileModel;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserProfileRepository extends CrudRepository<UserProfileModel,Integer> {
    Optional<UserProfileModel> findByUserName(String userName);
}

