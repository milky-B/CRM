package com.gdut.crm.service.settings.impl;

import com.gdut.crm.mapper.settings.DicTypeMapper;
import com.gdut.crm.pojo.settings.DicType;
import com.gdut.crm.service.settings.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;
    @Override
    public List<DicType> selectAllDicType() {
        return dicTypeMapper.selectAll();
    }
}
