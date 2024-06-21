package com.gdut.crm.mapper;

import com.gdut.crm.pojo.OperateLog;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

@Mapper
public interface OperateLogMapper {

    @Insert("<script> " +
            "insert into t_operate_log(user_id,des,user_name,message_id) " +
            "values(#{userId},#{des},#{userName},#{messageId})" +
            "</script>")
    int insert(OperateLog operateLog);

    @Select("select * from t_operate_log limit #{startRow},#{count}")
    @Results(id="logMap",value = {
            @Result(column = "id",property = "id"),
            @Result(column = "user_id",property = "userId"),
            @Result(column = "des",property = "des"),
            @Result(column = "user_name",property = "userName"),
            @Result(column = "message_id",property = "messageId")
    })
    List<OperateLog> selectAll(Map<String, Object> map);

    @Select("select count(1) from t_operate_log")
    int countAllByConditions(Map<String, Object> map);
}
