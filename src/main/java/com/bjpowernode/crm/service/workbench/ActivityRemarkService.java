package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryRemarkByActivityId(String id);
    int saveActivityRemark(ActivityRemark activityRemark);
    int deleteActivityRemark(String id);
    int updateActivityRemark(ActivityRemark activityRemark);
}
