package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.ActivityMapper;
import com.bjpowernode.crm.pojo.workbench.Activity;
import com.bjpowernode.crm.service.workbench.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public List<Activity> queryAll() {
        return activityMapper.selectAll();
    }
    @Override
    @Transactional
    public int saveActivity(Activity activity){

        return activityMapper.insert(activity);
    }

    @Override
    public List<Activity> selectAllByConditions(Map<String, Object> map) {
        return activityMapper.selectAllByConditions(map);
    }

    @Override
    public int countAllByConditions(Map<String,Object> map) {
        return activityMapper.countAllByConditions(map);
    }

    @Override
    @Transactional
    public int deleteByIds(String[] ids) {
        return activityMapper.deleteByKeys(ids);
    }

    @Override
    public Activity queryByKey(String key) {
        return activityMapper.selectByPrimaryKey(key);
    }

    @Override
    public int updateActivity(Activity activity) {
        return activityMapper.updateByPrimaryKey(activity);
    }

    @Override
    @Transactional
    public int insertActivities(List<Activity> activities) {
        return activityMapper.insertActivities(activities);
    }

    @Override
    public List<Activity> selectAllForDownload(String[] ids) {
        return activityMapper.selectAllForDownload(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public List<Activity> queryActivityAssociateClue(String id) {
        return activityMapper.selectActivityAssociateClue(id);
    }

    @Transactional
    @Override
    public int deleteRelation(String id) {
        return activityMapper.deleteRelation(id);
    }

    @Override
    public List<Activity> selectForClue(String id,String name) {
        return activityMapper.selectForClue(id,name);
    }

    @Override
    public List<Activity> selectActivityByNameAndClueId(String name,String id) {
        return activityMapper.selectActivityByNameAndClueId(name,id);
    }

    @Override
    public List<Activity> selectActivityByName(String name) {
        return activityMapper.selectActivityByName(name);
    }

    @Override
    public List<Activity> selectByContactsId(String id) {
        return activityMapper.selectByContactsId(id);
    }

    @Override
    public List<Activity> selectNotByContactsId(String id) {
        return activityMapper.selectNotInContactsId(id);
    }

    @Override
    public String selectNameById(String id) {
        return activityMapper.selectActivityNameById(id);
    }
}
