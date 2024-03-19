package com.example.isproject.db.repositories;

import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface CommentsRepository extends JpaRepository<Comment,Long> {

    List<Comment> findByAd(Ad ad);
}
