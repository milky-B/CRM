package com.gdut.crm.service.workbench;

import com.gdut.crm.pojo.workbench.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    int insert(Contacts contacts);
    List<Contacts> selectByCustomerId(String id);
    List<String> selectIdByCustomerId(String[] ids);
    void deleteByCustomerId(String[] ids);
    Contacts selectByPrimaryKey(String id);
    int deleteByPrimaryKey(String id);
    List<Contacts> selectAll();
    List<Contacts> selectByName(String name);
    List<Contacts> selectContactsByConditions(Map<String,Object> map);
    int countByConditions(Map<String,Object> map);
    int deleteByKeys(String[] ids);
    boolean createContact(Contacts contacts,String uer);
    Contacts selectContactByPrimaryId(String id);
    boolean updateByPrimaryKey(Contacts contacts,String editBy);
    Contacts selectContactForDetail(String id);

}
