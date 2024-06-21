package com.gdut.crm.commons.pojo;

import com.gdut.crm.pojo.workbench.Customer;

import java.util.List;

public class ReturnWithCustomers {
    private int amount;
    private List<Customer> customerList;

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public List<Customer> getCustomerList() {
        return customerList;
    }

    public void setCustomerList(List<Customer> customerList) {
        this.customerList = customerList;
    }
}
