package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.ContactsRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsRemarkMapper {
    int deleteByPrimaryKey(String id);
    /**/
    int insert(ContactsRemark row);

    /**/
    ContactsRemark selectByPrimaryKey(String id);

    List<ContactsRemark> selectAll();


    int updateByPrimaryKey(ContactsRemark row);

    int insertContactsRemarkByTransferClueRemark(@Param("remarks") List<ContactsRemark> contactsRemarks);
    /*删除id对应的备注*/
    int deleteByContactsIds(@Param("ids")List<String> ids);
    /*选取联系人对应的备注*/
    List<ContactsRemark> selectRemarkByContactsId(String id);

    /**
    * @program: id
    * @return: r.id, note_content,u.name as create_by, c.create_time,u.name as edit_by, c.edit_time, edit_flag, contacts_id
    * @description:
    **/
    ContactsRemark selectRemarkById(String id);
    int updateRemarkByPrimaryKey(ContactsRemark contactsRemark);

    /*
    * 通过联系人id删除*/
    int deleteByContactsId(@Param("ids") String[] ids);
}