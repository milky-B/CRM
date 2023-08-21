package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    int insertContactsRemarkByTransferClueRemark(List<ContactsRemark> contactsRemarks);
    void deleteRemarkByCustomerIds(String[] ids);
}
