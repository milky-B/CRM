package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.ClueActivityRelationMapper;
import com.bjpowernode.crm.mapper.workbench.ContactsActivityRelationMapper;
import com.bjpowernode.crm.pojo.workbench.ContactsActivityRelation;
import com.bjpowernode.crm.service.workbench.ContactsActivityRelationService;
import com.bjpowernode.crm.service.workbench.ContactsRemarkService;
import com.bjpowernode.crm.service.workbench.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {

    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsService contactsService;
    @Override
    @Transactional
    public int insertRelationByTransfer(String clueId, String contactsId) {
        List<String> list = clueActivityRelationMapper.selectByPrimaryKey(clueId);
        if(list.size()==0){
            return 0;
        }
        List<ContactsActivityRelation> relationList = new ArrayList<>();
        list.forEach(activityId->{
            ContactsActivityRelation relation = new ContactsActivityRelation();
            relation.setId(PrimaryUtil.getUUID());
            relation.setContactsId(contactsId);
            relation.setActivityId(activityId);
            relationList.add(relation);
        });
        return contactsActivityRelationMapper.insertRelationByTransfer(relationList);
    }

    @Override
    public void deleteByCustomerId(String[] ids) {
        List<String> list = contactsService.selectIdByCustomerId(ids);
        if(list.size()==0){
            return;
        }
        contactsActivityRelationMapper.deleteByContactsId(list);
    }
}
