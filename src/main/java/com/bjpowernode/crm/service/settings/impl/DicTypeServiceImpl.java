package com.bjpowernode.crm.service.settings.impl;

import com.bjpowernode.crm.mapper.settings.DicTypeMapper;
import com.bjpowernode.crm.pojo.settings.DicType;
import com.bjpowernode.crm.service.settings.DicTypeService;
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
