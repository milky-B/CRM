package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    int insertContactsRemarkByTransferClueRemark(List<ContactsRemark> contactsRemarks);
    void deleteRemarkByCustomerIds(String[] ids);
    List<ContactsRemark> selectRemarkByContactsId(String id);
    int insertRemark(ContactsRemark contactsRemark);
    ContactsRemark selectRemarkById(String id);
    int deleteByPrimaryId(String id);
    int updateRemarkByPrimaryKey(ContactsRemark contactsRemark);
    int deleteByContactsId(String[] ids);
}
