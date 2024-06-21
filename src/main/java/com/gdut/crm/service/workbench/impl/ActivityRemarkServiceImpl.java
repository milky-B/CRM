package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.mapper.workbench.ActivityRemarkMapper;
import com.gdut.crm.pojo.workbench.ActivityRemark;
import com.gdut.crm.service.workbench.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("activityRemarkService")
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper remarkMapper;

    @Override
    public int saveActivityRemark(ActivityRemark activityRemark) {
        return remarkMapper.insert(activityRemark);
    }

    @Override
    public List<ActivityRemark> queryRemarkByActivityId(String id) {
        return remarkMapper.selectByActivityKey(id);
    }

    @Override
    public int deleteActivityRemark(String id) {
        return remarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateActivityRemark(ActivityRemark activityRemark) {
        return remarkMapper.updateByPrimaryKey(activityRemark);
    }
}
