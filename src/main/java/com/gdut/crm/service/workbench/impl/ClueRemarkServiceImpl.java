package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.commons.util.PrimaryUtil;
import com.gdut.crm.mapper.workbench.ClueRemarkMapper;
import com.gdut.crm.pojo.workbench.ClueRemark;
import com.gdut.crm.pojo.workbench.ContactsRemark;
import com.gdut.crm.pojo.workbench.CustomerRemark;
import com.gdut.crm.service.workbench.ClueRemarkService;
import com.gdut.crm.service.workbench.ContactsRemarkService;
import com.gdut.crm.service.workbench.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ContactsRemarkService contactsRemarkService;

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @Override
    public List<ClueRemark> queryRemarkById(String id) {
        return clueRemarkMapper.selectByClueKey(id);
    }

    @Override
    public int deleteRemark(String id) {
        return clueRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insertRemark(ClueRemark remark) {
        return clueRemarkMapper.insert(remark);
    }

    @Override
    public int updateRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateByPrimaryKey(clueRemark);
    }

    @Override
    @Transactional()
    public void transferClueRemark(Map<String, String> map) {
        String clueId = map.get("clueId");
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkToTransfer(clueId);
        if(clueRemarks.size()==0){
            return;
        }
        List<ContactsRemark> contactsRemarks = new ArrayList<>();
        List<CustomerRemark> customerRemarks = new ArrayList<>();
        clueRemarks.forEach(clueRemark->{
            ContactsRemark contactsRemark = new ContactsRemark();
            CustomerRemark customerRemark = new CustomerRemark();

            contactsRemark.setId(PrimaryUtil.getUUID());
            contactsRemark.setNoteContent(clueRemark.getNoteContent());
            contactsRemark.setCreateBy(clueRemark.getCreateBy());
            contactsRemark.setCreateTime(clueRemark.getCreateTime());
            contactsRemark.setEditBy(clueRemark.getEditBy());
            contactsRemark.setEditTime(clueRemark.getEditTime());
            contactsRemark.setEditFlag(clueRemark.getEditFlag());
            contactsRemark.setContactsId(map.get("contactsId"));

            customerRemark.setId(PrimaryUtil.getUUID());
            customerRemark.setNoteContent(clueRemark.getNoteContent());
            customerRemark.setCreateBy(clueRemark.getCreateBy());
            customerRemark.setCreateTime(clueRemark.getCreateTime());
            customerRemark.setEditBy(clueRemark.getEditBy());
            customerRemark.setEditTime(clueRemark.getEditTime());
            customerRemark.setEditFlag(clueRemark.getEditFlag());
            customerRemark.setCustomerId(map.get("customerId"));

            contactsRemarks.add(contactsRemark);
            customerRemarks.add(customerRemark);
        });
        //转换
        contactsRemarkService.insertContactsRemarkByTransferClueRemark(contactsRemarks);
        customerRemarkService.insertCustomerRemarkByTransferClueRemark(customerRemarks);
    }

    @Override
    public int deleteByClueId(String clueId) {
        return clueRemarkMapper.deleteByClueId(clueId);
    }
}
