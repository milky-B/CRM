package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {
    int insertCustomerRemarkByTransferClueRemark(List<CustomerRemark> customerRemarks);
    List<CustomerRemark> selectByCustomerId(String id);
    void deleteByCustomerIds(String[] ids);
    int insertOne(CustomerRemark customerRemark);
    CustomerRemark selectByPrimaryKey(String id);
    int deleteByPrimaryId(String id);
    int updateOne(CustomerRemark customerRemark);
}
