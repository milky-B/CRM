package com.bjpowernode.crm.commons.pojo;

import com.bjpowernode.crm.pojo.workbench.Activity;

import java.util.List;

public class ReturnWithActivity {
    private List<Activity> activities;
    private int amount;

    @Override
    public String toString() {
        return "ReturnActivity{" +
                "activity=" + activities +
                ", amount=" + amount +
                '}';
    }

    public List<Activity> getActivity() {
        return activities;
    }

    public void setActivity(List<Activity> activity) {
        this.activities = activity;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public ReturnWithActivity() {
    }
}
