package com.bjpowernode.crm.service.user;


import com.bjpowernode.crm.pojo.User;

import java.util.List;

public interface UserService {
    User queryUserByUsernameAndPassword(String username, String password);
    List<User> querySurvival();
}
