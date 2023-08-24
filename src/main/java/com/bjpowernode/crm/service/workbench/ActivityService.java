package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<Activity> queryAll();

    int saveActivity(Activity activity);

    List<Activity> selectAllByConditions(Map<String, Object> map);

    int countAllByConditions(Map<String,Object> map);

    int deleteByIds(String[] ids);

    Activity queryByKey(String key);

    int updateActivity(Activity activity);

    List<Activity> selectAllForDownload(String[] ids);

    int insertActivities(List<Activity> activities);

    Activity queryActivityById(String id);

    List<Activity> queryActivityAssociateClue(String id);

    int deleteRelation(String id);

    List<Activity> selectForClue(String id,String name);

    List<Activity> selectActivityByNameAndClueId(String name,String id);

    List<Activity> selectActivityByName(String name);

    List<Activity> selectByContactsId(String id);
    List<Activity> selectNotByContactsId(String id);
    String selectNameById(String id);
}
