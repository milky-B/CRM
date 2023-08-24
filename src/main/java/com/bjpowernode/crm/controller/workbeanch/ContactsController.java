package com.bjpowernode.crm.controller.workbeanch;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.pojo.ReturnMessage;
import com.bjpowernode.crm.commons.pojo.ReturnWithActivity;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.pojo.settings.DicValue;
import com.bjpowernode.crm.pojo.workbench.*;
import com.bjpowernode.crm.service.settings.DicValueService;
import com.bjpowernode.crm.service.user.UserService;
import com.bjpowernode.crm.service.workbench.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Fail;
import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Success;

@Controller
@RequestMapping("/workbench")
public class ContactsController {
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;
    @RequestMapping("/contacts/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.querySurvival();
        request.setAttribute("users", users);
        List<DicValue> dicValueList = dicValueService.selectAllDicValue();
        List<DicValue> appellation = new ArrayList<>();
        List<DicValue> source = new ArrayList<>();
        dicValueList.forEach(dicValue -> {
            switch (dicValue.getTypeCode()){
                case "appellation" -> appellation.add(dicValue);
                case "source" -> source.add(dicValue);
            }
        });
        request.setAttribute("appellation",appellation);
        request.setAttribute("dicValues",source);
        return "workbench/contacts/index";
    }
    @ResponseBody
    @RequestMapping("/contacts/queryContactsByConditions.do")
    public Object queryContact(String owner, String fullname, String customerName, String source, String job, int page, int count){
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("fullname",fullname);
        map.put("customerName",customerName);
        map.put("source",source);
        map.put("job",job);
        map.put("startRow",(page-1)*count);
        map.put("count",count);
        List<Contacts> contacts = contactsService.selectContactsByConditions(map);
        contacts.forEach(contact->{
            if(contact.getAppellation()==null){
                contact.setAppellation("");
            }
        });
        int amount =contactsService.countByConditions(map);
        Map<String,Object> returnMap = new HashMap<>();
        returnMap.put("amount",amount);
        returnMap.put("contacts",contacts);
        return returnMap;
    }
    @ResponseBody
    @RequestMapping("/contacts/deleteContactByKeys.do")
    public Object deleteContactByKeys(String[] id){
        //要同时删除其对应的备注和市场活动
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = contactsService.deleteByKeys(id);
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
            if(i!=1){
                throw new Exception("删除失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
            returnMessage.setMessage("系统繁忙,请稍后再试");
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/contacts/create.do")
    public Object create(Contacts contacts,HttpServletRequest request){
        String user = ((User)request.getSession().getAttribute("user")).getId();
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(!contactsService.createContact(contacts,user)){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/contacts/queryContactForEdit.do")
    public Object queryContact(String id){
        Contacts contacts = contactsService.selectContactByPrimaryId(id);
        Map<String,Object> map = new HashMap<>();
        map.put("code",ConstantsMessage.Return_Object_Code_Success);
        map.put("contacts",contacts);
        if(contacts==null){
            map.put("code",ConstantsMessage.Return_Object_Code_Fail);
        }
        return map;
    }
    @ResponseBody
    @RequestMapping("/contacts/update.do")
    public Object updateContact(Contacts contacts,HttpServletRequest request){
        String editBy = ((User)request.getSession().getAttribute("user")).getId();
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(!contactsService.updateByPrimaryKey(contacts,editBy)){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @RequestMapping("/contacts/detail.do")
    public String detail(String id,HttpServletRequest request){
        List<User> users = userService.querySurvival();
        request.setAttribute("users", users);
        List<DicValue> dicValueList = dicValueService.selectAllDicValue();
        List<DicValue> appellation = new ArrayList<>();
        List<DicValue> source = new ArrayList<>();
        dicValueList.forEach(dicValue -> {
            switch (dicValue.getTypeCode()){
                case "appellation" -> appellation.add(dicValue);
                case "source" -> source.add(dicValue);
            }
        });
        request.setAttribute("appellation",appellation);
        request.setAttribute("dicValues",source);
        Contacts contacts = contactsService.selectContactForDetail(id);
        request.setAttribute("contacts",contacts);
        List<ContactsRemark> contactsRemarks = contactsRemarkService.selectRemarkByContactsId(id);
        contactsRemarks.forEach(remark->{
            if("0".equals(remark.getEditFlag())){
                remark.setEditBy(remark.getCreateBy());
                remark.setEditTime(remark.getCreateTime());
            }
        });
        request.setAttribute("remarkList",contactsRemarks);

        List<Transaction> transactions = transactionService.selectByContactsId(id);
        //交易的可能性
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        List<Map<String,Object>> transactionList = new ArrayList<>();
        transactions.forEach(transaction -> {
            Map<String, Object> map = new HashMap<>();
            map.put("possibility",resourceBundle.getString(transaction.getStage()));
            map.put("transaction",transaction);
            transactionList.add(map);
        });
        request.setAttribute("transactionList",transactionList);

        List<Activity> activities = activityService.selectByContactsId(id);
        request.setAttribute("activityList",activities);
        return "workbench/contacts/detail";
    }
    @ResponseBody
    @RequestMapping("/contacts/saveRemark.do")
    public Object saveRemark(String contactsId,String noteContent,HttpServletRequest request){
        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setContactsId(contactsId);
        contactsRemark.setNoteContent(noteContent);
        contactsRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        contactsRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        contactsRemark.setEditFlag("0");
        contactsRemark.setId(PrimaryUtil.getUUID());
        int i = contactsRemarkService.insertRemark(contactsRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("code",ConstantsMessage.Return_Object_Code_Fail);
        if(i==1){
            map.put("code",ConstantsMessage.Return_Object_Code_Success);
            map.put("remark",contactsRemarkService.selectRemarkById(contactsRemark.getId()));
        }
        return map;
    }
    @ResponseBody
    @RequestMapping("/contacts/deleteRemark.do")
    public Object deleteRemark(String id){
        int i = contactsRemarkService.deleteByPrimaryId(id);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/contacts/editRemark.do")
    public Object editRemark(String id,String noteContent,HttpServletRequest request){
        ReturnMessage returnMessage = new ReturnMessage();
        ContactsRemark contactsRemark = new ContactsRemark();
        contactsRemark.setId(id);
        contactsRemark.setNoteContent(noteContent);
        contactsRemark.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        contactsRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        contactsRemark.setEditFlag("1");
        try {
            int i = contactsRemarkService.updateRemarkByPrimaryKey(contactsRemark);
            returnMessage.setCode(Return_Object_Code_Success);
            returnMessage.setMessage(contactsRemark.getEditTime());
            if (i == 0) {
                throw new Exception("更新失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/contacts/queryTransaction.do")
    public Object queryTran(String id){
        List<Transaction> transactions = transactionService.selectByContactsId(id);
        //交易的可能性
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        List<Map<String,Object>> transactionList = new ArrayList<>();
        transactions.forEach(transaction -> {
            Map<String, Object> map = new HashMap<>();
            map.put("possibility",resourceBundle.getString(transaction.getStage()));
            map.put("transaction",transaction);
            transactionList.add(map);
        });
        return transactionList;
    }
    @ResponseBody
    @RequestMapping("/contacts/deleteTransaction.do")
    public Object deleteTransaction(String id){
        int i = transactionService.deleteTransactionById(id);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/contacts/queryActivity.do")
    public Object queryActivity(String id){
        List<Activity> activities = activityService.selectNotByContactsId(id);
        int amount = activities.size();
        Map<String,Object> map = new HashMap<>();
        map.put("amount",amount);
        map.put("activity",activities);
        return map;
    }
    @ResponseBody
    @RequestMapping("contacts/associate.do")
    public Object associate(String[] id,String contactsId){
        List<Activity> activities = new ArrayList<>();
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        try {
            List<ContactsActivityRelation> list = new ArrayList<>();
            ContactsActivityRelation contactsActivityRelation;
            for (String str:id) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(PrimaryUtil.getUUID());
                contactsActivityRelation.setContactsId(contactsId);
                contactsActivityRelation.setActivityId(str);
                list.add(contactsActivityRelation);
            }
            //
            contactsActivityRelationService.insertRelations(list);
            returnWithActivity.setAmount(1);
            if(list.size()<1){
                throw new Exception("添加出错");
            }
            activities = activityService.selectByContactsId(contactsId);
            returnWithActivity.setActivity(activities);
        }catch (Exception e){
            e.printStackTrace();
            returnWithActivity.setAmount(0);
        }
        return returnWithActivity;
    }
    @ResponseBody
    @RequestMapping("/contacts/deleteActivity.do")
    public Object deleteActivity(String id){
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = contactsActivityRelationService.deleteRelation(id);
            returnMessage.setCode(Return_Object_Code_Success);
            if(i!=1){
                throw new Exception("删除失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
}
