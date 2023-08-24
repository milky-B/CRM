package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.Funnel;
import com.bjpowernode.crm.pojo.workbench.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    int insertFormTransfer(Transaction transaction);
    List<Transaction> selectOneByCustomerId(String id);
    boolean createTransaction(Transaction transaction,String user);
    boolean deleteTransactionAndBelongById(String id);
    List<Transaction> selectByContactsId(String id);
    int deleteTransactionById(String id);
    List<Transaction> selectTransactionsByConditions(Map<String,Object> map);
    int countTransactionByConditons(Map<String,Object> map);
    int deleteTranBatch(String[] ids);
    Transaction selectTranByPrimaryKey(String id);
    boolean updateTransaction(Transaction transaction,String user);
    Transaction selectTransactionByPrimaryKey(String id);
    List<Funnel> selectFunnelByStage();
}
