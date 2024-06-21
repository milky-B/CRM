package com.gdut.crm.commons.pojo;

import com.gdut.crm.pojo.workbench.ActivityRemark;


public class ReturnWithRemarks {
    private String code;
    private ActivityRemark activityRemark;

    @Override
    public String toString() {
        return "ReturnWithRemarks{" +
                "code='" + code + '\'' +
                ", activityRemark=" + activityRemark +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public ActivityRemark getActivityRemark() {
        return activityRemark;
    }

    public void setActivityRemark(ActivityRemark activityRemark) {
        this.activityRemark = activityRemark;
    }

    public ReturnWithRemarks() {
    }

}