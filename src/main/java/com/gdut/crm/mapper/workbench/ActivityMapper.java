package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.Activity;
import com.gdut.crm.pojo.workbench.Funnel;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity row);

    Activity selectByPrimaryKey(String id);

    List<Activity> selectAll();

    int updateByPrimaryKey(Activity row);

    List<Activity> selectAllByConditions(Map<String,Object> map);

    int countAllByConditions(Map<String,Object> map);

    int deleteByKeys(@Param("ids") String[] ids);

    List<Activity> selectAllForDownload(@Param("ids")String[] ids);

    int insertActivities(@Param("activities")List<Activity> activities);

    Activity selectActivityById(String id);

    List<Activity> selectActivityAssociateClue(String id);

    int deleteRelation(String id);

    List<Activity> selectForClue(@Param("id")String id,@Param("name")String name);

    List<Activity> selectActivityByNameAndClueId(@Param("name")String name,@Param("id")String id);

    /*通过名字模糊查询*/
    List<Activity> selectActivityByName(String name);

    /*id
    contacts_activity_relation_id
    查询客户表相关联的活动*/
    List<Activity> selectByContactsId(String id);
    /*查询联系人未关联的活动*/
    List<Activity> selectNotInContactsId(String id);

    String selectActivityNameById(String id);

    List<Funnel> selectFunnel();
}