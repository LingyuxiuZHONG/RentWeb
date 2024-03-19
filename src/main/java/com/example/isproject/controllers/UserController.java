package com.example.isproject.controllers;

import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.Comment;
import com.example.isproject.db.entities.User;
import com.example.isproject.db.entities.UserRole;
import com.example.isproject.internals.AdsService;
import com.example.isproject.internals.CommentsService;
import com.example.isproject.internals.UsersService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.util.UriComponentsBuilder;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("")
public class UserController {

    private final AdsService adsService;
    private final UsersService usersService;
    private final CommentsService commentsService;


    public UserController(AdsService adsService, UsersService usersService,CommentsService commentsService){
        this.adsService = adsService;
        this.usersService = usersService;
        this.commentsService = commentsService;
    }



    @GetMapping(value = "/index")
    public ModelAndView getAds(@RequestParam(defaultValue = "1") int page,@RequestParam(required = false) String searchContent,
                               @RequestParam(required = false) Long minPrice,@RequestParam(required = false) Long maxPrice,
                               @RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-MM-dd") Date availFrom,@RequestParam(required = false)@DateTimeFormat(pattern = "yyyy-MM-dd") Date availTo, HttpSession session) {
        List<Ad> pageItems;
        ModelAndView modelAndView = new ModelAndView("browse");

        pageItems = adsService.findAdsByParamsInPage(page-1,searchContent,minPrice,maxPrice,availFrom,availTo);
        List<Integer> pageNumbers = adsService.pagination(pageItems == null ? 0 : pageItems.size());
        modelAndView.addObject("minPrice",minPrice);
        modelAndView.addObject("maxPrice",maxPrice);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        if(availFrom != null){
            modelAndView.addObject("availFrom", dateFormat.format(availFrom));
        }
        if(availTo != null){
            modelAndView.addObject("availTo", dateFormat.format(availTo));
        }
        modelAndView.addObject("searchContent",searchContent);
        modelAndView.addObject("pageItems", pageItems);
        modelAndView.addObject("pageNumbers",pageNumbers);
        modelAndView.addObject("currentPage", page);
        modelAndView.addObject("user",session.getAttribute("id") == null ? null : usersService.getUser((Long) session.getAttribute("id")));
        return modelAndView;
    }

    @GetMapping(value = "/ads/{ad_id}",params = {"action=detail"})
    public ModelAndView adsDetail(@PathVariable Long ad_id,HttpSession session){
        Optional<Ad> ad = adsService.findByAdId(ad_id);
        ModelAndView modelAndView = new ModelAndView("adDetail");
        if(ad.isPresent()){
            List<Comment> Items = commentsService.findComments(ad_id);

            modelAndView.addObject("house",ad.get());
            modelAndView.addObject("pageItems", Items);
            modelAndView.addObject("user",session.getAttribute("id") == null ? null : usersService.getUser((Long) session.getAttribute("id")));
            return modelAndView;
        }else{
            return null;
        }
    }



    @GetMapping(value = "/register")
    public ModelAndView register() {

        return new ModelAndView("register");
    }

    @PostMapping(value = "/register")
    public RedirectView register(@RequestParam String name, @RequestParam String password, @RequestParam String pwd_confirm,
                                 @RequestParam String email, @RequestParam String phone, @RequestParam String role, HttpSession session) {
        UserRole userRole;
        if (role.equalsIgnoreCase("landlord")) {
            userRole = UserRole.LANDLORD;
        } else {
            userRole = UserRole.TENANT;
        }
        User user = usersService.createUser(name,password,email,phone,userRole);
        session.setAttribute("id",user.getUserId());
        RedirectView redirectView = new RedirectView();

        if(user.getRole() == UserRole.LANDLORD){
            redirectView.setUrl("/house-manage?page=1");

        }else{
            redirectView.setUrl("/index?page=1");
        }

        return redirectView;

    }

    @GetMapping(value = "/login")
    public ModelAndView login() {

        return new ModelAndView("login");
    }

    @PostMapping(value = "/login")
    public RedirectView register(@RequestParam String log_email, @RequestParam String log_password,
                                 @RequestParam(required = false) String redirect,@RequestParam(required = false) String ad_id, HttpSession session) {
        User user = usersService.findUserByEmail(log_email);
        session.setAttribute("id", user.getUserId());
        RedirectView redirectView = new RedirectView();
        if(log_password.equals(user.getPassword())){
            if(user.getRole().equals(UserRole.LANDLORD)){
                redirectView.setUrl("/house-manage?page=1");
            }else if(user.getRole().equals(UserRole.TENANT)){
                if(redirect != null && redirect.equals("adDetail")){
                    redirectView.setUrl("/ads/" + ad_id + "?action=detail");
                }else{
                    redirectView.setUrl("/index?page=1");
                }
            }else{
                redirectView.setUrl("/admins?page=1");
            }
        }


        return redirectView;

    }

    @GetMapping("/logout")
    public RedirectView logout(HttpSession session){
        session.removeAttribute("id");
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl("/login");
        return redirectView;
    }


    @PostMapping("/search")
    public RedirectView search(@RequestParam String searchContent){
        String targetUrl = UriComponentsBuilder.fromUriString("/index")
                .queryParam("page", 1)
                .queryParam("searchContent", searchContent)
                .toUriString();

        return new RedirectView(targetUrl);
    }



    @PostMapping("/create-comment")
    public RedirectView createComment(@RequestParam Long ad_id, @RequestParam String comment, @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date created, HttpSession session){
        Optional<User> user = usersService.getUser((Long)session.getAttribute("id"));
        Optional<Ad> ad = adsService.findByAdId(ad_id);
        if(user.isPresent() && ad.isPresent()){
            commentsService.createComment(created,comment,user.get(),ad.get());
        }
        return new RedirectView("/ads/" + ad_id + "?action=detail");
    }





}
