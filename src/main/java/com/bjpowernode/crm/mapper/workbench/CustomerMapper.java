package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer row);

    Customer selectByPrimaryKey(String id);

    List<Customer> selectAll();

    int updateByPrimaryKey(Customer row);

    List<Customer> selectCustomerByConditions(Map<String, Object> condition);

    int countAllByConditions(Map<String,Object> condition);

    int deleteByKeys(@Param("keys")String[] list);

    /*
    * customer-detail*/
    Customer selectOneById(String id);
}