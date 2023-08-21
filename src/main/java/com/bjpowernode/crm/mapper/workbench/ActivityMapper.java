package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.Activity;
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
}