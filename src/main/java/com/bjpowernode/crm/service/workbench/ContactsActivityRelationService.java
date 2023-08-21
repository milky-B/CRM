package com.bjpowernode.crm.service.workbench;

public interface ContactsActivityRelationService {
    int insertRelationByTransfer(String clueId,String contactsId);
    void deleteByCustomerId(String[] ids);
}
