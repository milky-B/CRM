package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.mapper.workbench.ContactsRemarkMapper;
import com.gdut.crm.pojo.workbench.ContactsRemark;
import com.gdut.crm.service.workbench.ContactsRemarkService;
import com.gdut.crm.service.workbench.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    @Lazy
    private ContactsService contactsService;
    @Override
    public int insertContactsRemarkByTransferClueRemark(List<ContactsRemark> contactsRemarks) {
        return contactsRemarkMapper.insertContactsRemarkByTransferClueRemark(contactsRemarks);
    }

    @Override
    public void deleteRemarkByCustomerIds(String[] ids) {
        List<String> list = contactsService.selectIdByCustomerId(ids);
        if(list.size()==0){
            return;
        }
        contactsRemarkMapper.deleteByContactsIds(list);
    }

    @Override
    public List<ContactsRemark> selectRemarkByContactsId(String id) {
        return contactsRemarkMapper.selectRemarkByContactsId(id);
    }

    @Override
    public int insertRemark(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.insert(contactsRemark);
    }

    @Override
    public ContactsRemark selectRemarkById(String id) {
        return contactsRemarkMapper.selectRemarkById(id);
    }

    @Override
    public int deleteByPrimaryId(String id) {
        return contactsRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int updateRemarkByPrimaryKey(ContactsRemark contactsRemark) {
        return contactsRemarkMapper.updateRemarkByPrimaryKey(contactsRemark);
    }

    @Override
    @Transactional
    public int deleteByContactsId(String[] ids) {
        return contactsRemarkMapper.deleteByContactsId(ids);
    }
}
