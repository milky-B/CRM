package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.mapper.workbench.ContactsMapper;
import com.bjpowernode.crm.pojo.workbench.Contacts;
import com.bjpowernode.crm.service.workbench.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public int insert(Contacts contacts) {
        return contactsMapper.insert(contacts);
    }

    @Override
    public List<Contacts> selectByCustomerId(String id) {
        return contactsMapper.selectByCustomerId(id);
    }

    @Override
    public List<String> selectIdByCustomerId(String[] ids) {
        return contactsMapper.selectIdByCustomerId(ids);
    }

    @Override
    public void deleteByCustomerId(String[] ids) {
        contactsMapper.deleteByCustomerId(ids);
    }
}
