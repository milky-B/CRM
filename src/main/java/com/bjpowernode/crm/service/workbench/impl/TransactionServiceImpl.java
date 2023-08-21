package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.TransactionMapper;
import com.bjpowernode.crm.pojo.workbench.Transaction;
import com.bjpowernode.crm.service.workbench.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TransactionMapper transactionMapper;
    @Override
    public int insertFormTransfer(Transaction transaction) {
        return transactionMapper.insertFormTransferClue(transaction);
    }

    @Override
    public List<Transaction> selectOneByCustomerId(String id) {
        return transactionMapper.selectByCustomerId(id);
    }
}
