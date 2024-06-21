package com.gdut.crm.service.settings.impl;

import com.gdut.crm.mapper.settings.DicValueMapper;
import com.gdut.crm.pojo.settings.DicValue;
import com.gdut.crm.service.settings.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> selectAllDicValue() {
        return dicValueMapper.selectAll();
    }

    @Override
    public int updateClue(DicValue dicValue) {
        return dicValueMapper.updateByPrimaryKey(dicValue);
    }

    @Override
    public DicValue selectOne(String id) {
        return dicValueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int insertDicValue(DicValue dicValue) {
        return dicValueMapper.insert(dicValue);
    }

    @Override
    public int deleteByKeys(String[] ids) {
        return dicValueMapper.deleteByKeys(ids);
    }

    @Override
    public List<DicValue> selectByType(String type) {
        return dicValueMapper.selectByType(type);
    }
}