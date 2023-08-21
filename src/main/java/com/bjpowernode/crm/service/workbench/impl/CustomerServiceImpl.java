package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.CustomerMapper;
import com.bjpowernode.crm.pojo.workbench.Customer;
import com.bjpowernode.crm.service.workbench.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public int insert(Customer customer) {
        return customerMapper.insert(customer);
    }

    @Override
    public List<Customer> queryCustomerByConditions(Map<String, Object> conditions) {
        return customerMapper.selectCustomerByConditions(conditions);
    }

    @Override
    public int countAllByConditions(Map<String,Object> condition) {
        return customerMapper.countAllByConditions(condition);
    }

    @Override
    public Customer selectByPrimary(String id) {
        return customerMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimary(Customer customer) {
        return customerMapper.updateByPrimaryKey(customer);
    }

    @Override
    public int deleteByKeys(String[] list) {
        return customerMapper.deleteByKeys(list);
    }

    @Override
    public Customer selectOneById(String id) {
        return customerMapper.selectOneById(id);
    }
}
