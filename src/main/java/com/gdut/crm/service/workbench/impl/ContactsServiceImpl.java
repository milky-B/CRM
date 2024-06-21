package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.commons.util.DateUtil;
import com.gdut.crm.commons.util.PrimaryUtil;
import com.gdut.crm.mapper.workbench.ContactsActivityRelationMapper;
import com.gdut.crm.mapper.workbench.ContactsMapper;
import com.gdut.crm.pojo.workbench.Contacts;
import com.gdut.crm.pojo.workbench.Customer;
import com.gdut.crm.service.workbench.ContactsRemarkService;
import com.gdut.crm.service.workbench.ContactsService;
import com.gdut.crm.service.workbench.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    @Lazy
    private CustomerService customerService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
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

    @Override
    public Contacts selectByPrimaryKey(String id) {
        return contactsMapper.selectByPrimaryKey(id);
    }

    @Override
    public int deleteByPrimaryKey(String id) {
        return contactsMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<Contacts> selectAll() {
        return contactsMapper.selectAll();
    }

    @Override
    public List<Contacts> selectByName(String name) {
        return contactsMapper.selectByName(name);
    }

    @Override
    public List<Contacts> selectContactsByConditions(Map<String, Object> map) {
        return contactsMapper.selectContactsByConditions(map);
    }

    @Override
    public int countByConditions(Map<String,Object> map) {
        return contactsMapper.countByConditions(map);
    }

    @Override
    @Transactional
    public int deleteByKeys(String[] ids) {
        contactsRemarkService.deleteByContactsId(ids);
        contactsActivityRelationMapper.deleteByContactsId(Arrays.asList(ids));
        contactsMapper.deleteByKeys(ids);
        return 1;
    }

    @Override
    public boolean createContact(Contacts contacts, String user) {
        String customerName = contacts.getCustomerId();
        String id = customerService.selectIdByName(customerName);
        if(id==null || id==""){
            //如果客户不存在则新建客户
            Customer customer = new Customer();
            customer.setId(PrimaryUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(user);
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            customer.setNextContactTime(contacts.getNextContactTime());
            customerService.insert(customer);
            id = customer.getId();
        }
        contacts.setCustomerId(id);
        contacts.setId(PrimaryUtil.getUUID());
        contacts.setCreateBy(user);
        contacts.setCreateTime(DateUtil.formatDateTime(new Date()));
        int insert = contactsMapper.insert(contacts);
        if(insert==1){
            return true;
        }else {
            throw new RuntimeException();
        }
    }

    @Override
    public Contacts selectContactByPrimaryId(String id) {
        return contactsMapper.selectByPrimaryKey(id);
    }

    @Override
    public boolean updateByPrimaryKey(Contacts contacts,String updateBy) {
        String customerName = contacts.getCustomerId();
        String id = customerService.selectIdByName(customerName);
        if(id==null || id==""){
            //如果客户不存在则新建客户
            Customer customer = new Customer();
            customer.setId(PrimaryUtil.getUUID());
            customer.setOwner(contacts.getOwner());
            customer.setName(customerName);
            customer.setCreateBy(updateBy);
            customer.setCreateTime(DateUtil.formatDateTime(new Date()));
            customer.setNextContactTime(contacts.getNextContactTime());
            customerService.insert(customer);
            id = customer.getId();
        }
        contacts.setCustomerId(id);
        contacts.setEditBy(updateBy);
        contacts.setEditTime(DateUtil.formatDateTime(new Date()));
        int i =contactsMapper.updateByPrimaryKey(contacts);
        if(i==1){
            return true;
        }else {
            throw new RuntimeException();
        }
    }

    @Override
    public Contacts selectContactForDetail(String id) {
        return contactsMapper.selectContactForDetail(id);
    }
}
