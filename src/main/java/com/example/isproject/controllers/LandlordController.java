package com.example.isproject.controllers;


import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.User;
import com.example.isproject.internals.AdsService;
import com.example.isproject.internals.UsersService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("")
public class LandlordController {
    private final AdsService adsService;
    private final UsersService usersService;
    public LandlordController(AdsService adsService,UsersService usersService){
        this.adsService = adsService;
        this.usersService = usersService;
    }
    /*
    Read
    */
    @GetMapping(value = "/house-manage")
    public ModelAndView showHouseManage(@RequestParam int page, HttpSession session) {
        Long id = (Long) session.getAttribute("id");
        List<Ad> pageItems = adsService.findByIdInPage(id,page-1);
        List<Integer> pageNumbers = adsService.pagination(pageItems == null ? 0 : pageItems.size());
        ModelAndView modelAndView = new ModelAndView("houseManage");
        modelAndView.addObject("pageItems", pageItems);
        modelAndView.addObject("pageNumbers",pageNumbers);
        modelAndView.addObject("currentPage", page);
        modelAndView.addObject("user",session.getAttribute("id") == null ? null : usersService.getUser((Long) session.getAttribute("id")));
        return modelAndView;
    }


    /*
    Create
    */

    @GetMapping(value = "/create-house-resource")
    public ModelAndView createHouseResource(){
        return new ModelAndView("create");
    }


    @PostMapping(value = "/create-house-resource")
    public RedirectView createdHouseResource(@RequestParam String title, @RequestParam String address, @RequestParam String descrip,
                                             @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date avail,
                                             @RequestParam long pay, @RequestParam MultipartFile image,
                                             @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") Date created, HttpSession session) throws IOException {
        Long id = (Long) session.getAttribute("id");
        Optional<User> user = usersService.getUser(id);
        if (!image.isEmpty()) {
            byte[] imageBytes = image.getBytes();
            adsService.create(title,address,descrip,created,created,avail,pay, imageBytes,user.get());

        }else{
            adsService.create(title,address,descrip,created,created,avail,pay, null,user.get());

        }
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl("/house-manage?page=1");
        redirectView.addStaticAttribute("id", id);

        return redirectView;
    }

    /*
    Update
     */

    @GetMapping(path = "/ads/{ad_id}", params = { "action=edit", "mode=htmlForm" })
    @ResponseBody
    public ModelAndView editHouseResource(@PathVariable Long ad_id){
        Optional<Ad> ad = adsService.findByAdId(ad_id);
        if (ad.isPresent()) {
            return new ModelAndView("adEdit", "ad", ad.get());
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No such dish with id" + ad_id);
        }
    }

    @PostMapping (path = "/ads/{ad_id}", params = { "action=update"},consumes = "multipart/form-data")
    @ResponseBody
    public RedirectView updateAd(@PathVariable Long ad_id, @RequestParam String title, @RequestParam String address,
                                 @RequestParam String descrip, @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date avail,
                                 @RequestParam Long pay, @RequestParam MultipartFile image,
                                 @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date modified) throws IOException {

        if (!image.isEmpty()) {
            byte[] imageBytes = image.getBytes();
            adsService.updateIfExists(ad_id, title, address, descrip, modified, avail, pay, imageBytes);
        }else{
            adsService.updateIfExists(ad_id, title, address, descrip, modified, avail, pay, null);
        }
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl("/house-manage?page=1");
        return redirectView;
    }

    /*
    Delete
     */
    @GetMapping(path = "/ads/{ad_id}", params = { "action=delete", "mode=htmlForm" })
    @ResponseBody
    public RedirectView DeleteHouseResource(@PathVariable Long ad_id){

        if (adsService.deleteIfExists(ad_id)) {
            RedirectView redirectView = new RedirectView();
            redirectView.setUrl("/house-manage?page=1");
            return redirectView;
        } else {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No such ad with id" + ad_id);}
    }


}
