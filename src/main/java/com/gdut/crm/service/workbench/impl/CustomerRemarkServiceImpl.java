package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.mapper.workbench.CustomerRemarkMapper;
import com.gdut.crm.pojo.workbench.CustomerRemark;
import com.gdut.crm.service.workbench.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public int insertCustomerRemarkByTransferClueRemark(List<CustomerRemark> customerRemarks) {
        return customerRemarkMapper.insertCustomerRemarkByTransferClueRemark(customerRemarks);
    }

    @Override
    public List<CustomerRemark> selectByCustomerId(String id) {
        return customerRemarkMapper.selectByCustomerId(id);
    }

    @Override
    @Transactional
    public void deleteByCustomerIds(String[] ids) {
        customerRemarkMapper.deleteByCustomerIds(ids);
        return;
    }

    @Override
    public int insertOne(CustomerRemark customerRemark) {
        return customerRemarkMapper.insert(customerRemark);
    }

    @Override
    public CustomerRemark selectByPrimaryKey(String id) {
        return customerRemarkMapper.selectByPrimaryKey(id);
    }

    @Override
    public int deleteByPrimaryId(String id) {
        return customerRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateOne(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateByPrimaryKey(customerRemark);
    }
}
