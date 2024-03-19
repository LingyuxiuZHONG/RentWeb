package com.example.isproject.controllers;


import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.User;
import com.example.isproject.db.entities.UserRole;
import com.example.isproject.internals.UsersService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.util.List;

@Controller
@RequestMapping("")
public class AdminController {
    UsersService usersService;


    public AdminController(UsersService usersService){
        this.usersService = usersService;
    }

    @GetMapping("/admins/{id}")
    public ModelAndView userManage(@PathVariable Long id, @RequestParam int page){
        List<User> pageItems = usersService.findAllUsers(page-1);
        List<Long> pageNumbers = usersService.pagination();
        ModelAndView modelAndView = new ModelAndView("admin");
        modelAndView.addObject("pageItems", pageItems);
        modelAndView.addObject("pageNumbers",pageNumbers);
        modelAndView.addObject("currentPage", page);
        modelAndView.addObject("id", id);
        modelAndView.addObject("userRoles", UserRole.values());
        return modelAndView;
    }


    @PostMapping("/admins/{id}/changeRole")
    public RedirectView changeRole(@PathVariable Long id, @RequestParam Long user_id,@RequestParam UserRole userRole){
        usersService.changeRole(user_id,userRole);
        RedirectView redirectView = new RedirectView();
        redirectView.setUrl("/admins/{id}?page=1");
        redirectView.addStaticAttribute("id", id);

        return redirectView;

    }
}
