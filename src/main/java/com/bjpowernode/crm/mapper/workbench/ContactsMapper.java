package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts row);

    Contacts selectByPrimaryKey(String id);

    List<Contacts> selectAll();

    int updateByPrimaryKey(Contacts row);

    /*customer-detail*/
    List<Contacts> selectByCustomerId(String CustomerId);

    /*select id by customerId*/
    List<String> selectIdByCustomerId(@Param("ids")String[] ids);

    /*delete by customerId*/
    int deleteByCustomerId(@Param("ids")String[] ids);
}