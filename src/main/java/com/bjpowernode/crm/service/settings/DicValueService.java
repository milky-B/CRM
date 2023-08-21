package com.bjpowernode.crm.service.settings;

import com.bjpowernode.crm.pojo.settings.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> selectAllDicValue();
    int insertDicValue(DicValue dicValue);
    DicValue selectOne(String id);
    int updateClue(DicValue dicValue);
    int deleteByKeys(String[] ids);
    List<DicValue> selectByType(String type);
}
