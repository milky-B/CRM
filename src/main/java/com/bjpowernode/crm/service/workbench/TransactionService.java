package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.Transaction;

import java.util.List;

public interface TransactionService {
    int insertFormTransfer(Transaction transaction);
    List<Transaction> selectOneByCustomerId(String id);
}
