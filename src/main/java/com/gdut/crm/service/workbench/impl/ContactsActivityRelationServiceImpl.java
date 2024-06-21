package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.commons.util.PrimaryUtil;
import com.gdut.crm.mapper.workbench.ClueActivityRelationMapper;
import com.gdut.crm.mapper.workbench.ContactsActivityRelationMapper;
import com.gdut.crm.pojo.workbench.ContactsActivityRelation;
import com.gdut.crm.service.workbench.ContactsActivityRelationService;
import com.gdut.crm.service.workbench.ContactsService;
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

    @Override
    public int insertRelations(List<ContactsActivityRelation> list) {
        return contactsActivityRelationMapper.insertContacts(list);
    }

    @Override
    public int deleteRelation(String id) {
        return contactsActivityRelationMapper.deleteByActivityId(id);
    }
}
