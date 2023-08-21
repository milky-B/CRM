package com.bjpowernode.crm.service.test;

import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.service.user.UserService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml",
        "classpath:applicationContext-service.xml"})
public class UserServiceTest {
    @Autowired
    UserService userService;
    @Test
    public void test01(){
        User user = userService.queryUserByUsernameAndPassword("ls", "yf123");
        System.out.println(user);
    }
    @Test
    public void test02(){
    }
}
