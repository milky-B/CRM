package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.TransactionRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TransactionRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionRemark row);

    TransactionRemark selectByPrimaryKey(String id);

    List<TransactionRemark> selectAll();

    int updateByPrimaryKey(TransactionRemark row);

    int insertRemarks(@Param("remarks")List<TransactionRemark> transactionRemarks);

    /*
    * 删除 通过交易id*/
    int deleteByTransactionId(String id);
}