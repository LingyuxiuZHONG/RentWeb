package com.example.isproject.internals;


import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.Comment;
import com.example.isproject.db.entities.User;
import com.example.isproject.db.repositories.AdsRepository;
import com.example.isproject.db.repositories.CommentsRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;


@Service
public class CommentsService {
    private final AdsRepository adsRepository;
    private final CommentsRepository commentsRepository;

    private final int pageSize;

    public CommentsService(CommentsRepository commentsRepository,AdsRepository adsRepository,@Value("${PAGESIZE}") int pageSize){
        this.commentsRepository = commentsRepository;
        this.adsRepository = adsRepository;
        this.pageSize = pageSize;
    }

    public List<Comment> findComments(Long ad_id){
        Optional<Ad> ad = adsRepository.findByAdId(ad_id);
        if(ad.isPresent()){
            return commentsRepository.findByAd(ad.get());
        }else{
            return null;
        }


    }




    public void createComment(Date created, String content,User user,Ad ad ){
        Comment comment = new Comment(created,content,user,ad);
        commentsRepository.save(comment);
    }
}
