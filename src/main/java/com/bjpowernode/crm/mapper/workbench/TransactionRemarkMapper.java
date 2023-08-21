package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.TransactionRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TransactionRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionRemark row);

    TransactionRemark selectByPrimaryKey(String id);

    List<TransactionRemark> selectAll();

    int updateByPrimaryKey(TransactionRemark row);

    int insertRemarks(@Param("remarks")List<TransactionRemark> transactionRemarks);
}