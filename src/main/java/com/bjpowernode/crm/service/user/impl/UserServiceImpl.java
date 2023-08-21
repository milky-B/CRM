package com.bjpowernode.crm.service.user.impl;

import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.mapper.UserMapper;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;
    @Override
    public User queryUserByUsernameAndPassword(String username, String password) {
        return userMapper.selectUserByUsernameAndPassword(username, password);
    }

    @Override
    public List<User> querySurvival() {
        List<User> users = userMapper.selectAll();
        List<User> result = new ArrayList<>();
        //筛选出有效的用户
        users.forEach(user -> {
            if("1".equals(user.getLockState())){
                if(DateUtil.formatDateTime(new Date()).compareTo(user.getExpireTime())<0){
                    result.add(user);
                }
            }
        });
        return result;
    }
}
