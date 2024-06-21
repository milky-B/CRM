package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts row);

    /**/
    Contacts selectByPrimaryKey(String id);

    /**/
    List<Contacts> selectAll();

    int updateByPrimaryKey(Contacts row);

    /*customer-detail*/
    List<Contacts> selectByCustomerId(String CustomerId);

    /*select id by customerId*/
    List<String> selectIdByCustomerId(@Param("ids")String[] ids);

    /*delete by customerId*/
    int deleteByCustomerId(@Param("ids")String[] ids);

    /**/
    List<Contacts> selectByName(String name);

    /**
    * @program: map
    * @return: List<Contacts>
    * @description: contact-index-query
    **/
    List<Contacts> selectContactsByConditions(Map<String,Object> map);
    int countByConditions(Map<String,Object> map);

    int deleteByKeys(@Param("ids")String[] ids);


    /**
    * @program: id
    * @return:  contacts    customer Name as customer_id
    * @description:
    **/

    Contacts selectContactsByPrimaryKey(String id);

    Contacts selectContactForDetail(String id);

}