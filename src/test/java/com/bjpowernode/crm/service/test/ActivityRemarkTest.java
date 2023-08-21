package com.bjpowernode.crm.service.test;

import com.bjpowernode.crm.pojo.workbench.ActivityRemark;
import com.bjpowernode.crm.service.workbench.ActivityRemarkService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml","classpath:applicationContext-service.xml"})
public class ActivityRemarkTest {
    @Autowired
    ActivityRemarkService activityRemarkService;
    @Test
    public void test(){
        List<ActivityRemark> list = activityRemarkService.queryRemarkByActivityId("aaaaa");
        System.out.println(list);
    }
}
