package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark row);

    ActivityRemark selectByPrimaryKey(String id);

    List<ActivityRemark> selectAll();

    int updateByPrimaryKey(ActivityRemark row);

    List<ActivityRemark> selectByActivityKey(String id);
}