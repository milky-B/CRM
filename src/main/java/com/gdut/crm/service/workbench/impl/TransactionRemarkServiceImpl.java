package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.commons.util.PrimaryUtil;
import com.gdut.crm.mapper.workbench.TransactionRemarkMapper;
import com.gdut.crm.pojo.workbench.ClueRemark;
import com.gdut.crm.pojo.workbench.TransactionRemark;
import com.gdut.crm.service.workbench.ClueRemarkService;
import com.gdut.crm.service.workbench.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Override
    public void insertRemarkByTransferClueRemark(String clueId, String transactionId) {
        List<ClueRemark> clueRemarks = clueRemarkService.queryRemarkById(clueId);
        if(clueRemarks.size()==0){
            return;
        }
        List<TransactionRemark> transactionRemarks = new ArrayList<>();
        clueRemarks.forEach(remark -> {
            TransactionRemark transactionRemark = new TransactionRemark();
            transactionRemark.setId(PrimaryUtil.getUUID());
            transactionRemark.setTranId(transactionId);
            transactionRemark.setCreateBy(remark.getCreateBy());
            transactionRemark.setCreateTime(remark.getCreateTime());
            transactionRemark.setEditBy(remark.getEditBy());
            transactionRemark.setEditFlag(remark.getEditFlag());
            transactionRemark.setEditTime(remark.getEditTime());
            transactionRemark.setNoteContent(remark.getNoteContent());
            transactionRemarks.add(transactionRemark);
        });
        transactionRemarkMapper.insertRemarks(transactionRemarks);
    }

    @Override
    @Transactional
    public int deleteRemarkByTransactionId(String id) {
        return transactionRemarkMapper.deleteByTransactionId(id);
    }
}
