package com.gdut.crm.service.workbench;

import com.gdut.crm.pojo.workbench.Clue;
import com.gdut.crm.pojo.workbench.Funnel;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<Clue> selectAll();
    int insertClue(Clue clue);
    List<Clue> queryCluesByConditionsAndCount(Map<String,Object> conditions);
    int countClueByConditions(Map<String,Object> map);
    int deleteClueByKeys(String[] ids);
    Clue queryOneForDetail(String id);
    int updateClue(Clue clue);
    Clue queryByKey(String id);
    int associateActivity(List<Map<String,String>> list);
    Clue queryClueForTransfer(String id);
    boolean transfer(Map<String,String> map);

    List<Funnel> selectFunnel();
}
