package com.gdut.crm.contactsService;

import com.gdut.crm.service.workbench.ContactsService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml","classpath:applicationContext-service.xml"})
public class MapperTest {
    @Autowired
    private ContactsService contactsService;
    @Test
    public void demo(){
        contactsService.selectByName("aaa");
    }
}
