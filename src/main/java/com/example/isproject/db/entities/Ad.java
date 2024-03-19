package com.example.isproject.db.entities;


import javax.persistence.*;
import java.io.File;
import java.util.Date;

@Entity
@Table(name = "ads")
public class Ad {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ad_id")
    private Long adId;
    private String title;

    private String address;
    @Column(columnDefinition = "TEXT")
    private String descrip;
    private Long pay;

    @Temporal(TemporalType.TIMESTAMP)
    private Date created;

    @Temporal(TemporalType.TIMESTAMP)
    private Date modified;

    @Temporal(TemporalType.DATE)
    private Date avail;


    @Column(columnDefinition = "bytea")
    private byte[] image;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;


    public Ad(
            String title, String address, String descrip, Date created,Date modified, Date avail, Long pay, byte[] image, User user
    ) {
        this.title = title;
        this.address = address;
        this.descrip = descrip;
        this.created = created;
        this.modified = modified;
        this.avail = avail;
        this.pay = pay;
        this.image = image;
        this.user = user;
    }

    public Ad() {

    }

    public Long getAd_id() {
        return adId;
    }

    public void setAd_id(Long adId) {
        this.adId = adId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescrip() {
        return descrip;
    }

    public void setDescrip(String discription) {
        this.descrip = discription;
    }

    public Long getPay() {
        return pay;
    }

    public void setPay(Long spay) {
        this.pay = pay;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getModified() {
        return modified;
    }

    public void setModified(Date modified) {
        this.modified = modified;
    }

    public Date getAvailability() {
        return avail;
    }

    public void setAvailability(Date avail) {
        this.avail = avail;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
