package com.example.isproject.db.repositories;

import com.example.isproject.db.entities.User;
import com.example.isproject.db.entities.UserRole;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UsersRepository extends JpaRepository<User,Long> {

    User getUserByEmail(String email);

    Optional<User> findByUserId(Long id);
}
