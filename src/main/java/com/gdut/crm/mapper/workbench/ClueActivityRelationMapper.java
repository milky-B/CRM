package com.gdut.crm.mapper.workbench;


import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ClueActivityRelationMapper {

    /*获取clueId对应的所有市场活动id*/
    List<String> selectByPrimaryKey(String id);
    int deleteByClueId(String id);
}