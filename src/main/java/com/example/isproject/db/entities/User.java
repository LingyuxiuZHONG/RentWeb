package com.example.isproject.db.entities;


import javax.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy =  GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Long userId;
    private String name;
    private String password;
    private String email;
    private String phone;
    @Enumerated(EnumType.STRING)
    private UserRole role;

    public User(){

    }

    public User(String name,String password,String email,String phone,UserRole role){
        this.name = name;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.role = role;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }
}
