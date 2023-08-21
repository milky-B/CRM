package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.ContactsActivityRelation;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactsActivityRelation row);

    ContactsActivityRelation selectByPrimaryKey(String id);

    List<ContactsActivityRelation> selectAll();

    int updateByPrimaryKey(ContactsActivityRelation row);

    int insertRelationByTransfer(@Param("relations") List<ContactsActivityRelation> list);

    /*delete by contactsId*/
    int deleteByContactsId(@Param("ids") List<String> ids);
}