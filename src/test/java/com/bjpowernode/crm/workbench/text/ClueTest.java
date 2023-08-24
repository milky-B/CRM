package com.bjpowernode.crm.workbench.text;

import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.ClueMapper;
import com.bjpowernode.crm.mapper.workbench.ClueRemarkMapper;
import com.bjpowernode.crm.mapper.workbench.TransactionMapper;
import com.bjpowernode.crm.pojo.workbench.Clue;
import com.bjpowernode.crm.pojo.workbench.Transaction;
import com.bjpowernode.crm.service.workbench.ClueRemarkService;
import com.bjpowernode.crm.service.workbench.ClueService;
import com.bjpowernode.crm.service.workbench.ContactsActivityRelationService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:applicationContext-mapper.xml", "classpath:applicationContext-service.xml"})
public class ClueTest {
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;
    @Test
    public void demo1(){
        clueService.selectAll();
    }
    @Test
    public void demo2(){
        Map<String,Object> map = new HashMap<>();
        map.put("startRow",0);
        map.put("count",10);
        List<Clue> list = clueService.queryCluesByConditionsAndCount(map);
        list.forEach(System.out::println);
    }
    @Test
    public void demo3(){
        clueRemarkMapper.selectByClueKey("aaa");
    }
    @Test
    public void demo4(){
        List<Map<String,String>> list = new ArrayList<>();
        Map<String,String> map = new HashMap<>();
        map.put("id", PrimaryUtil.getUUID());
        map.put("clueId","111111111111111111111111111");
        map.put("activityId","111111111111111111111111111");
        list.add(map);
        clueMapper.insertRelateActivity(list);
    }
    @Test
    public void testTransfer1(){
        Map<String,String> map = new HashMap<>();
        map.put("clueId","3bd3d84622d6406daecd2c1a2a51c5f8");
        boolean transfer = clueService.transfer(map);

        if(transfer==true){
            System.out.println("转换成功");
        }
    }
    @Test
    public void testRemarkTransfer(){
        Map<String,String> clueRemarkTransferMap = new HashMap<>();
        clueRemarkTransferMap.put("clueId","3bd3d84622d6406daecd2c1a2a51c5f8");
        clueRemarkTransferMap.put("customerId","e937f676a0fa47b0876b3594002c87d8");
        clueRemarkTransferMap.put("contactsId","ce9967d202d6436bb8dabece3eaad2aa");
        clueRemarkService.transferClueRemark(clueRemarkTransferMap);
    }
    @Test
    public void testRelationTransfer(){
        contactsActivityRelationService.insertRelationByTransfer("3bd3d84622d6406daecd2c1a2a51c5f8", "ce9967d202d6436bb8dabece3eaad2aa");
    }
    @Test
    public void testTransactionMapper(){
        Transaction transaction = new Transaction();
        transaction.setId("111111111111111111111111111");
        transactionMapper.insertFormTransferClue(transaction);
    }
    @Test
    public void testStringCompareMap_String(){
        Map<String,String> map = new HashMap<>();
        map.put("str","aaa");
        if("aaa"==map.get("str")){
            System.out.println("============");
        }
        if("aaa".equals(map.get("str"))){
            System.out.println("equals");
        }
    }
    @Test
    public void testObject(){
        String str = "aaa";
        Object o = str;
        System.out.println(o);
        int b = 3;
        o=b;
        System.out.println(o);
    }
    @Test
    public void testSelectTransactionsByConditions(){

    }
    @Test
    public void testSelectAll(){
        transactionMapper.selectAll();
    }

}
