package com.gdut.crm.service.workbench;


public interface TransactionRemarkService {
    void insertRemarkByTransferClueRemark(String clueId,String transactionId);
    int deleteRemarkByTransactionId(String id);
}
