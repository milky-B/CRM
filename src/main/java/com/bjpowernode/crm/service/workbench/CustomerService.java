package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    int insert(Customer customer);
    List<Customer> queryCustomerByConditions(Map<String, Object> conditions);
    int countAllByConditions(Map<String,Object> conditions);
    Customer selectByPrimary(String id);
    int updateByPrimary(Customer customer);
    int deleteByKeys(String[] list);
    Customer selectOneById(String id);
}

