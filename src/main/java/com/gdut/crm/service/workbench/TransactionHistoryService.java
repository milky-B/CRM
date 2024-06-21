package com.gdut.crm.service.workbench;


import com.gdut.crm.pojo.workbench.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    int deleteByTransactionId(String id);
    int insertTransactionHistory(TransactionHistory transactionHistory);
    List<TransactionHistory> selectHistoryByPrimaryKey(String id);
}
