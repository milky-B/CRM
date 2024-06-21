package com.gdut.crm.mapper.workbench;




import com.gdut.crm.pojo.workbench.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionHistory row);

    TransactionHistory selectByPrimaryKey(String id);

    List<TransactionHistory> selectAll();

    int updateByPrimaryKey(TransactionHistory row);


    /**
    * @program: TransactionId
    * @return:  int
    * @description:
    **/
    int deleteByTransactionId(String id);

    List<TransactionHistory> selectTransactionHistoryByPrimaryKey(String tranId);
}