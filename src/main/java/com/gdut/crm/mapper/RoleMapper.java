package com.gdut.crm.mapper;

import com.gdut.crm.pojo.Role;
import com.gdut.crm.pojo.UserRole;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface RoleMapper {
    @Select("<script>" +
            "select tr.id,tr.name,tr.union_id,tr.state,tr.description,tr.create_time,tr.modify_time,tr.tenant_id,tr.del_flag,tur.user_id " +
            "from t_role as tr " +
            "join t_user_role as tur on tr.id = tur.role_id " +
            "<foreach collection=\"userIds\" item=\"id\" separator=\",\" open=\"and tur.user_id in (\" close=\")\">\n" +
            "#{id}\n" +
            "</foreach>" +
            "where tr.del_flag = 0 and tur.del_flag = 0" +
            "</script>")
    @Results(id = "map1",value = {
            @Result(property="id",column="id"),
            @Result(property="name",column="name"),
            @Result(property="unionId",column="union_id"),
            @Result(property="state",column="state"),
            @Result(property="description",column="description"),
            @Result(property="createTime",column="create_time"),
            @Result(property="modifyTime",column="modify_time"),
            @Result(property="tenantId",column="tenant_id"),
            @Result(property="delFlag",column="del_flag"),
            @Result(property="userId",column="user_id")
    })
    List<UserRole> selectAll(@Param("userIds")List<String> userIds);
    @Select("<script>" +
            "select tr.id,tr.name,tr.union_id,tr.state,tr.description,tr.create_time,tr.modify_time,tr.tenant_id,tr.del_flag " +
            "from t_role as tr " +
            "where tr.del_flag = 0" +
            "</script>")
    @ResultMap("map2")
    List<Role> select();

    @Select("<script>" +
            "select tr.id,tr.name,tr.union_id,tr.state,tr.description,tr.create_time,tr.modify_time,tr.tenant_id,tr.del_flag " +
            "from t_role as tr " +
            "where tr.del_flag = 0 and tr.id = #{id}" +
            "</script>")
    @Results(id = "map2",value = {
            @Result(property="id",column="id"),
            @Result(property="name",column="name"),
            @Result(property="unionId",column="union_id"),
            @Result(property="state",column="state"),
            @Result(property="description",column="description"),
            @Result(property="createTime",column="create_time"),
            @Result(property="modifyTime",column="modify_time"),
            @Result(property="tenantId",column="tenant_id"),
            @Result(property="delFlag",column="del_flag")
    })
    Role selectByPrimaryKey(Long id);

    @Delete("<script>" +
            "delete from t_user_role " +
            "where user_id = #{id}" +
            "</script>")
    int deleteByUserId(String id);

    @Insert("<script>" +
            "insert into t_user_role(id,role_id,user_id,create_time,modify_time,del_flag) " +
            "values(#{id},#{roleId},#{userId},#{createTime},#{modifyTime},#{delFlag})" +
            "</script>")
    int insertUserRole(UserRole userRole);

    @Select("<script>" +
            "select tr.id,tr.name,tr.union_id,tr.state,tr.description,tr.create_time,tr.modify_time,tr.tenant_id,tr.del_flag " +
            "from t_role as tr " +
            "where tr.del_flag = 0 " +
            "limit #{start},#{pageSize}" +
            "</script>")
    @ResultMap("map2")
    List<Role> selectRole(@Param("start") int start,@Param("pageSize") int pageSize);

    @Select("select count(id) from t_role")
    long count();
}
