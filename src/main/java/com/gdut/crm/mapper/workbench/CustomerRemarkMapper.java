package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.CustomerRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark row);

    /**/
    CustomerRemark selectByPrimaryKey(String id);

    List<CustomerRemark> selectAll();

    /**/
    int updateByPrimaryKey(CustomerRemark row);

    int insertCustomerRemarkByTransferClueRemark(@Param("remarks") List<CustomerRemark> customerRemarks);

    /*customer-detail*/
    List<CustomerRemark> selectByCustomerId(String id);
    /*customer-delete*/
    int deleteByCustomerIds(@Param("ids")String[] ids);
}