package com.example.isproject.db.repositories;

import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;
@Repository
public interface AdsRepository extends JpaRepository<Ad,Long> {


    Page<Ad> findByUser(User user, Pageable pageable);

    Optional<Ad> findByAdId(Long id);

    Page<Ad> findByAddressContainingIgnoreCase(String searchContent,Pageable pageable);

    Page<Ad>  findByPayBetween(long min, long max,Pageable pageable);

    @Query("SELECT a FROM Ad a WHERE a.address LIKE %:searchContent% AND a.pay BETWEEN :min AND :max")
    Page<Ad> findSearchedFilteredInPage(@Param("searchContent") String searchContent,
                                        @Param("min") long min,
                                        @Param("max") long max,
                                        Pageable pageable);

    @Query("SELECT a FROM Ad a " +
            "WHERE (:searchContent IS NULL OR LOWER(a.address) LIKE LOWER(CONCAT('%', :searchContent, '%'))) " +
            "AND (a.pay >= :minPrice) " +
            "AND (a.pay <= :maxPrice) " +
            "AND (a.avail >= :availFrom) " +
            "AND (a.avail <= :availTo)")
    Page<Ad> findByParamsInPage(@Nullable @Param("searchContent") String searchContent,
                                   @Nullable @Param("minPrice") Long minPrice,
                                   @Nullable @Param("maxPrice") Long maxPrice,
                                   @Nullable @Param("availFrom") Date availFrom,
                                   @Nullable @Param("availTo") Date availTo,
                                   Pageable pageable);



    @Query("SELECT MAX(a.avail) FROM Ad a")
    Date findMaxAvailDate();


    @Query("SELECT a FROM Ad a WHERE " +
            "(a.pay >= :min) " +
            "AND (a.pay <= :max) " +
            "AND (a.avail >= :availFrom) " +
            "AND (a.avail <= :availTo)")
    Page<Ad> findByFiltersInPage(
            @Param("min") Long min,
            @Param("max") Long max,
            @Param("availFrom") Date availFrom,
            @Param("availTo") Date availTo,
            Pageable pageable);
}
