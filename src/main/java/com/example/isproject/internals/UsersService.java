package com.example.isproject.internals;

import com.example.isproject.db.entities.Ad;
import com.example.isproject.db.entities.User;
import com.example.isproject.db.entities.UserRole;
import com.example.isproject.db.repositories.UsersRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
public class UsersService {
    private final UsersRepository usersRepository;
    private final int pageSize;

    public UsersService(UsersRepository usersRepository,@Value("${PAGESIZE}") int pageSize){
        this.usersRepository = usersRepository;
        this.pageSize = pageSize;
    }

    public Optional<User> getUser(Long id){
        return usersRepository.findByUserId(id);
    }

    public User createUser(String name, String password, String email, String phone, UserRole role) {
        User user = new User(name,password,email,phone,role);
        usersRepository.save(user);
        return user;
    }

    public User findUserByEmail(String email){
        User user = usersRepository.getUserByEmail(email);
        return user;
    }

    public List<User> findAllUsers(int page){
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<User> resultPage = usersRepository.findAll(pageable);

        if (resultPage.isEmpty()) {
            return null;
        } else {
            return resultPage.getContent();
        }
    }

    public void changeRole(Long id,UserRole role){
        Optional<User> user = usersRepository.findByUserId(id);
        if(user.isPresent()){
            user.get().setRole(role);
            usersRepository.save(user.get());
        }

    }

    public List<Long> pagination(){
        List<Long> pageNumbers = new ArrayList<>();

        long total = usersRepository.count();

        if(total < pageSize){
            pageNumbers.add(1L);
        }else{
            long max = total % pageSize == 0 ? total / pageSize : total / pageSize + 1;

            for(long i = 1; i <= max; i++){
                pageNumbers.add(i);
            }
        }
        return pageNumbers;
    }

}
