package com.bjpowernode.crm.service.workbench;


import com.bjpowernode.crm.pojo.workbench.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    int deleteByTransactionId(String id);
    int insertTransactionHistory(TransactionHistory transactionHistory);
    List<TransactionHistory> selectHistoryByPrimaryKey(String id);
}
