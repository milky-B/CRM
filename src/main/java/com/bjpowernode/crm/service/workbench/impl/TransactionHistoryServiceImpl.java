package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.TransactionHistoryMapper;
import com.bjpowernode.crm.pojo.workbench.TransactionHistory;
import com.bjpowernode.crm.service.workbench.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    @Transactional
    public int deleteByTransactionId(String id) {
        return transactionHistoryMapper.deleteByTransactionId(id);
    }

    @Override
    public int insertTransactionHistory(TransactionHistory transactionHistory) {
        return transactionHistoryMapper.insert(transactionHistory);
    }

    @Override
    public List<TransactionHistory> selectHistoryByPrimaryKey(String id) {
        return transactionHistoryMapper.selectTransactionHistoryByPrimaryKey(id);
    }
}
