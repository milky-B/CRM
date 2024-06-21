package com.gdut.crm.service.test;

import com.gdut.crm.service.workbench.ActivityService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml","classpath:applicationContext-service.xml"})
public class ActivityServiceTest {
    @Autowired
    ActivityService activityService;
    @Test
    public void demo(){
        activityService.deleteByIds(new String[]{"1"});
    }
}
