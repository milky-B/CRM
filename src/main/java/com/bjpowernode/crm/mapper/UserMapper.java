package com.bjpowernode.crm.mapper;

import com.bjpowernode.crm.pojo.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User row);

    User selectByPrimaryKey(String id);

    List<User> selectAll();

    int updateByPrimaryKey(User row);

    User selectUserByUsernameAndPassword(@Param("loginAct")String loginAct,@Param("loginPwd") String loginPwd);

}