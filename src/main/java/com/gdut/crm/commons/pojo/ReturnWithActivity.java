package com.gdut.crm.commons.pojo;

import java.util.List;

public class ReturnWithActivity<T> {
    private List<T> activities;
    private int amount;

    @Override
    public String toString() {
        return "ReturnActivity{" +
                "activity=" + activities +
                ", amount=" + amount +
                '}';
    }

    public List<T> getActivity() {
        return activities;
    }

    public void setActivity(List<T> activity) {
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
