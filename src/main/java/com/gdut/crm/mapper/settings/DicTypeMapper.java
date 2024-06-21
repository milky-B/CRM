package com.gdut.crm.mapper.settings;

import com.gdut.crm.pojo.settings.DicType;

import java.util.List;

public interface DicTypeMapper {
    int deleteByPrimaryKey(String code);

    int insert(DicType row);

    DicType selectByPrimaryKey(String code);

    List<DicType> selectAll();

    int updateByPrimaryKey(DicType row);
}