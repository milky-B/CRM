package com.bjpowernode.crm.mapper.workbench;


import java.util.List;

public interface ClueActivityRelationMapper {

    /*获取clueId对应的所有市场活动id*/
    List<String> selectByPrimaryKey(String id);
    int deleteByClueId(String id);
}