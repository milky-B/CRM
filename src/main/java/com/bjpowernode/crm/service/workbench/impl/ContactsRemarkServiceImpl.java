package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.ContactsRemarkMapper;
import com.bjpowernode.crm.pojo.workbench.ContactsRemark;
import com.bjpowernode.crm.service.workbench.ContactsRemarkService;
import com.bjpowernode.crm.service.workbench.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactsRemarkServiceImpl implements ContactsRemarkService {
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
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
}
