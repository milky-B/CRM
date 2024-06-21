package com.gdut.crm.mapper;

import com.gdut.crm.pojo.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

@Mapper
public interface UserMapper {
    int deleteByPrimaryKey(@Param("ids")List<String> ids);

    int insert(User row);

    User selectByPrimaryKey(String id);

    List<User> selectAll();

    int updateByPrimaryKey(User row);

    User selectUserByUsernameAndPassword(@Param("loginAct")String loginAct,@Param("loginPwd") String loginPwd);

    User selectUserByLoginAct(String loginAct);

    List<User> selectUser(@Param("lockState") String lockState,
                          @Param("roleId") Long roleId,
                          @Param("name") String name,
                          @Param("startTime") Date startTime,
                          @Param("endTime") Date endTime,
                          @Param("pagingData")  boolean pagingData,
                          @Param("startRow") Integer startRow,
                          @Param("pageSize") Integer pageSize);


    int updateSelective(@Param("user")User user);

    String findRoleIdByUserId(String id);

    long count(@Param("lockState") String lockState,
               @Param("roleId") Long roleId,
               @Param("name") String name,
               @Param("startTime") Date startTime,
               @Param("endTime") Date endTime);
}