package com.gdut.crm.settings.service;

import com.gdut.crm.mapper.settings.DicValueMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml", "classpath:applicationContext-service.xml"})

public class DicValueTest {
@Autowired
    DicValueMapper dicValueMapper;
@Test
    public void demo1(){
    dicValueMapper.deleteByKeys(new String[]{"1111"});
}
}
