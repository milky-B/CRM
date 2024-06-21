package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.Clue;
import com.gdut.crm.pojo.workbench.Funnel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue row);

    Clue selectByPrimaryKey(String id);

    List<Clue> selectAll();

    int updateByPrimaryKey(Clue row);

    List<Clue> selectClueByConditionsAndCount(Map<String,Object> conditions);

    int countClueByConditions(Map<String,Object> conditions);

    int deleteByKeys(@Param("ids")String[] String);

    Clue selectOneForDetail(String id);
    int insertRelateActivity(@Param("relations")List<Map<String,String>> relations);

    Clue selectClueForTransfer(String id);

    List<Funnel> selectFunnel();
}
