package com.example.isproject.internals;

import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.Comment;
import com.example.isproject.db.entities.User;
import com.example.isproject.db.repositories.AdsRepository;
import com.example.isproject.db.repositories.CommentsRepository;
import com.example.isproject.db.repositories.UsersRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;


@Service
public class AdsService {
    private final AdsRepository adsRepository;
    private final UsersRepository usersRepository;

    private final int pageSize;
    public AdsService(AdsRepository adsRepository, @Value("${PAGESIZE}") int pageSize,UsersRepository usersRepository){
        this.adsRepository = adsRepository;
        this.pageSize = pageSize;
        this.usersRepository =usersRepository;
    }

    /*
    Read
     */

    public List<Ad> findAllInPage(int page){
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Ad> resultPage = adsRepository.findAll(pageable);

        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }

    public List<Ad> findSearchedInPage(int page, String searchContent) {
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Ad> resultPage = adsRepository.findByAddressContainingIgnoreCase(searchContent,pageable);
        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }

    public List<Ad> priceFilterInPage(int page,long min, long max){
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Ad> resultPage = adsRepository.findByPayBetween(min,max,pageable);
        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }
    public Date findMaxAvailDate(){
        return adsRepository.findMaxAvailDate();
    }
    public List<Ad> findAdsByParamsInPage(int page, String searchContent, Long min, Long max, Date availFrom, Date availTo) {
        Pageable pageable = PageRequest.of(page, pageSize);
        min = min == null ? 0L : min;
        max = max == null ? Long.MAX_VALUE : max;
        availFrom = availFrom == null ? new Date() : availFrom;
        availTo = availTo == null ? adsRepository.findMaxAvailDate() : availTo;

        Page<Ad> resultPage;
        if(searchContent == null){
            resultPage = adsRepository.findByFiltersInPage(min,max,availFrom,availTo,pageable);
        }else{
            resultPage = adsRepository.findByParamsInPage(searchContent,min,max,availFrom,availTo,pageable);
        }
        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }



    public List<Integer> pagination(Integer total){
        List<Integer> pageNumbers = new ArrayList<>();

        if(total < pageSize){
            pageNumbers.add(1);
            return pageNumbers;
        }else{
            int max = total % pageSize == 0 ? total / pageSize : total / pageSize + 1;

            for(int i = 1; i <= max; i++){
                pageNumbers.add(i);
            }
            return pageNumbers;
        }
    }


    public List<Ad> findByIdInPage(Long id, int page){
        Pageable pageable = PageRequest.of(page, pageSize);
        Optional<User> user = usersRepository.findByUserId(id);
        Page<Ad> resultPage = adsRepository.findByUser(user.get(),pageable);
        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }

    /*
    Create
     */
    public void create(String title, String address, String descrip, Date created, Date modified, Date avail, Long pay, byte[] image, User owner
     ){
        Ad ad = new Ad(title, address, descrip, created, modified, avail, pay, image, owner);
        adsRepository.save(ad);
    }

    /*
    Update
     */
    public Optional<Ad> findByAdId(Long id){
        return adsRepository.findByAdId(id);
    }
    public void updateIfExists(Long id, String title, String address, String descrip,Date modified, Date avail, Long pay, byte[] image//, User owner
    ){
        Optional<Ad> oldAd = adsRepository.findByAdId(id);
        if(oldAd.isPresent()){
            Ad ad = oldAd.get();
            if(!title.equals(ad.getTitle())){
                ad.setTitle(title);
            }
            if(!address.equals(ad.getAddress())){
                ad.setAddress(address);
            }
            if(!descrip.equals(ad.getDescrip())){
                ad.setDescrip(descrip);
            }

            if(avail != ad.getAvailability()){
                ad.setAvailability(avail);
            }
            if(!pay.equals(ad.getPay())){
                ad.setPay(pay);
            }
            if(image != null){
                ad.setImage(image);
            }
            ad.setModified(modified);

            adsRepository.save(ad);
        }
    }

    public boolean deleteIfExists(Long id){
        Optional<Ad> ad = adsRepository.findByAdId(id);
        if(ad.isPresent()){
            adsRepository.delete(ad.get());
            return true;
        }else{
            return false;
        }
    }








}
