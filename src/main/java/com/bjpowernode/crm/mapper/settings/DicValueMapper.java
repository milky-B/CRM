package com.bjpowernode.crm.mapper.settings;



import com.bjpowernode.crm.pojo.settings.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue row);

    DicValue selectByPrimaryKey(String id);

    List<DicValue> selectAll();

    int updateByPrimaryKey(DicValue row);

    int deleteByKeys(@Param("ids")String[] ids);

    List<DicValue> selectByType(String type);
}