package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.Transaction;

import java.util.List;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction row);

    Transaction selectByPrimaryKey(String id);

    List<Transaction> selectAll();

    int updateByPrimaryKey(Transaction row);

    int insertFormTransferClue(Transaction transaction);

    /*customer-detail*/
    List<Transaction> selectByCustomerId(String id);
}