package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.Contacts;

import java.util.List;

public interface ContactsService {
    int insert(Contacts contacts);
    List<Contacts> selectByCustomerId(String id);
    List<String> selectIdByCustomerId(String[] ids);
    void deleteByCustomerId(String[] ids);
}
