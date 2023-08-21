package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.ContactsRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactsRemark row);

    /**/
    ContactsRemark selectByPrimaryKey(String id);

    List<ContactsRemark> selectAll();


    int updateByPrimaryKey(ContactsRemark row);

    int insertContactsRemarkByTransferClueRemark(@Param("remarks") List<ContactsRemark> contactsRemarks);
    /*customer-delete*/
    int deleteByContactsIds(@Param("ids") List<String> ids);
}