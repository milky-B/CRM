package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int insertRelationByTransfer(String clueId,String contactsId);
    void deleteByCustomerId(String[] ids);
    int insertRelations(List<ContactsActivityRelation> list);
    int deleteRelation(String id);
}
