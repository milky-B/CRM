package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.TransactionMapper;
import com.bjpowernode.crm.pojo.workbench.Customer;
import com.bjpowernode.crm.pojo.workbench.Funnel;
import com.bjpowernode.crm.pojo.workbench.Transaction;
import com.bjpowernode.crm.pojo.workbench.TransactionHistory;
import com.bjpowernode.crm.service.workbench.CustomerService;

import com.bjpowernode.crm.service.workbench.TransactionHistoryService;
import com.bjpowernode.crm.service.workbench.TransactionRemarkService;
import com.bjpowernode.crm.service.workbench.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;

    @Override
    public int insertFormTransfer(Transaction transaction) {
        return transactionMapper.insertFormTransferClue(transaction);
    }

    @Override
    public List<Transaction> selectOneByCustomerId(String id) {
        return transactionMapper.selectByCustomerId(id);
    }

    @Override
    public boolean createTransaction(Transaction transaction, String user) {
        String customerName = transaction.getCustomerId();
        String id = customerService.selectIdByName(customerName);
        if(id==null || id==""){
            //如果客户不存在则新建客户
            Customer customer = new Customer();
            customer.setId(PrimaryUtil.getUUID());
            customer.setOwner(transaction.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(user);
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            customer.setNextContactTime(transaction.getNextContactTime());
            customerService.insert(customer);
            id = customer.getId();
        }
        transaction.setCustomerId(id);
        transaction.setId(PrimaryUtil.getUUID());
        transaction.setCreateBy(user);
        transaction.setCreateTime(DateUtil.formatDateTime(new Date()));
        int insert = transactionMapper.insert(transaction);
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(PrimaryUtil.getUUID());
        transactionHistory.setCreateBy(user);
        transactionHistory.setCreateTime(DateUtil.formatDateTime(new Date()));
        transactionHistory.setTranId(transaction.getId());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setStage(transaction.getStage());
        int i = transactionHistoryService.insertTransactionHistory(transactionHistory);
        if(insert==1 && i==1){
            return true;
        }else {
            throw new RuntimeException();
        }
    }

    @Override
    @Transactional
    public boolean deleteTransactionAndBelongById(String id) {
        transactionRemarkService.deleteRemarkByTransactionId(id);
        transactionHistoryService.deleteByTransactionId(id);
        transactionMapper.deleteByPrimaryKey(id);
        return true;
    }

    @Override
    public List<Transaction> selectByContactsId(String id) {
        return transactionMapper.selectByContactsId(id);
    }

    @Override
    public int deleteTransactionById(String id) {
        return transactionMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<Transaction> selectTransactionsByConditions(Map<String, Object> map) {
        return transactionMapper.selectTransactionsByConditions(map);
    }

    @Override
    public int countTransactionByConditons(Map<String, Object> map) {
        return transactionMapper.countTransactionByConditons(map);
    }

    @Override
    public int deleteTranBatch(String[] ids) {
        return transactionMapper.deleteTranBatch(ids);
    }

    @Override
    public Transaction selectTranByPrimaryKey(String id) {
        return transactionMapper.selectOneByPrimaryKey(id);
    }

    @Override
    @Transactional
    public boolean updateTransaction(Transaction transaction, String user) {

        String customerName = transaction.getCustomerId();
        String id = customerService.selectIdByName(customerName);
        if(id==null || id==""){
            //如果客户不存在则新建客户
            Customer customer = new Customer();
            customer.setId(PrimaryUtil.getUUID());
            customer.setOwner(transaction.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(user);
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            customer.setNextContactTime(transaction.getNextContactTime());
            customerService.insert(customer);
            id = customer.getId();
        }
        transaction.setCustomerId(id);
        transaction.setEditBy(user);
        transaction.setEditTime(DateUtil.formatDateTime(new Date()));
        int insert = transactionMapper.updateByPrimaryKey(transaction);
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(PrimaryUtil.getUUID());
        transactionHistory.setCreateBy(user);
        transactionHistory.setCreateTime(DateUtil.formatDateTime(new Date()));
        transactionHistory.setTranId(transaction.getId());
        transactionHistory.setMoney(transaction.getMoney());
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setStage(transaction.getStage());
        int i = transactionHistoryService.insertTransactionHistory(transactionHistory);
        if(insert==1 && i==1){
            return true;
        }else {
            throw new RuntimeException();
        }
    }

    @Override
    public Transaction selectTransactionByPrimaryKey(String id) {
        return transactionMapper.selectTranByPrimaryKey(id);
    }

    @Override
    public List<Funnel> selectFunnelByStage() {
        return transactionMapper.selectFunnelByStage();
    }
}
