package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.CustomerMapper;
import com.bjpowernode.crm.pojo.workbench.Contacts;
import com.bjpowernode.crm.pojo.workbench.Customer;
import com.bjpowernode.crm.service.workbench.ContactsService;
import com.bjpowernode.crm.service.workbench.CustomerRemarkService;
import com.bjpowernode.crm.service.workbench.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public int insert(Customer customer) {
        return customerMapper.insert(customer);
    }

    @Override
    public List<Customer> queryCustomerByConditions(Map<String, Object> conditions) {
        return customerMapper.selectCustomerByConditions(conditions);
    }

    @Override
    public int countAllByConditions(Map<String,Object> condition) {
        return customerMapper.countAllByConditions(condition);
    }

    @Override
    public Customer selectByPrimary(String id) {
        return customerMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimary(Customer customer) {
        return customerMapper.updateByPrimaryKey(customer);
    }

    @Override
    @Transactional
    public int deleteByKeys(String[] list) {
        customerMapper.deleteByKeys(list);
        customerRemarkService.deleteByCustomerIds(list);
        return 1;
    }

    @Override
    public Customer selectOneById(String id) {
        return customerMapper.selectOneById(id);
    }

    @Override
    public List<String> selectByName(String name) {
        return customerMapper.selectByName(name);
    }

    @Override
    public String selectIdByName(String name) {
        return customerMapper.selectIdByCustomerName(name);
    }

    @Override
    @Transactional
    public Contacts customerCreateContact(Contacts contacts, String user) {
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
            customer.setContactSummary(contacts.getContactSummary());
            customer.setNextContactTime(contacts.getNextContactTime());
            customer.setDescription(contacts.getDescription());
            customer.setAddress(contacts.getAddress());
            customerService.insert(customer);
            id = customer.getId();
        }
        contacts.setCustomerId(id);
        contacts.setCreateBy(user);
        contacts.setCreateTime(DateUtil.formatDateTime(new Date()));
        contacts.setId(PrimaryUtil.getUUID());
        contactsService.insert(contacts);
        Contacts contacts1 = contactsService.selectByPrimaryKey(contacts.getId());
        if(contacts1.getAppellation()==null){
            contacts1.setAppellation("");
        }
        return contacts1;
    }

}
