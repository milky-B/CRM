package com.gdut.crm.controller.workbeanch;

import com.gdut.crm.commons.constants.ConstantsMessage;
import com.gdut.crm.commons.pojo.ReturnMessage;
import com.gdut.crm.mapper.OperateLogMapper;
import com.gdut.crm.pojo.OperateLog;
import com.gdut.crm.pojo.User;
import com.gdut.crm.pojo.settings.DicValue;
import com.gdut.crm.pojo.workbench.*;
import com.gdut.crm.service.settings.DicValueService;
import com.gdut.crm.service.user.impl.UserService;
import com.gdut.crm.service.workbench.ActivityService;
import com.gdut.crm.service.workbench.ContactsService;
import com.gdut.crm.service.workbench.TransactionHistoryService;
import com.gdut.crm.service.workbench.TransactionService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.*;
import java.util.stream.Collectors;

import static com.gdut.crm.commons.constants.ConstantsMessage.Return_Object_Code_Fail;
import static com.gdut.crm.commons.constants.ConstantsMessage.Return_Object_Code_Success;

@Controller
@RequestMapping("/workbench")
public class TransactionController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;
    @Autowired
    private OperateLogMapper operateLogMapper;
    @RequestMapping("/transaction/index.do")
    public String index(HttpServletRequest request){
        List<DicValue> stageList = dicValueService.selectByType("stage");
        List<DicValue> tranTypeList = dicValueService.selectByType("transactionType");
        List<DicValue> clueStateList = dicValueService.selectByType("clueState");
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("clueStateList",clueStateList);
        return "/workbench/transaction/index";
    }
    @RequestMapping("/transaction/save.do")
    public String save(String back,HttpServletRequest request){
        List<User> users = userService.querySurvival();
        List<DicValue> stageList = dicValueService.selectByType("stage");
        List<DicValue> tranTypeList = dicValueService.selectByType("transactionType");
        List<DicValue> clueStateList = dicValueService.selectByType("clueState");
        List<Activity> activities = activityService.queryAll();
        List<Contacts> contactsList = contactsService.selectAll();

        request.setAttribute("users",users);
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("activityList",activities);
        request.setAttribute("contactsList",contactsList);
        switch (back){
            case "0" ->back="workbench/contacts/index.do";
            case "1" ->back="workbench/customer/index.do";
            case "2" ->back="workbench/transaction/index.do";
        }
        request.setAttribute("back",back);
        return "workbench/transaction/save";
    }
    @ResponseBody
    @RequestMapping("/transaction/queryPossibility.do")
    public Object queryPossible(String id){
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        DicValue dicValue = dicValueService.selectOne(id);
        String string = resourceBundle.getString(dicValue.getValue());
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Fail);
        returnMessage.setMessage("未配置相应阶段");
        if(string!=null && string!=""){
            returnMessage.setCode(Return_Object_Code_Success);
            String str = string+"%";
            returnMessage.setMessage(str);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/transaction/searchActivityByName.do")
    public Object queryActivityByName(String name){
        List<Activity> activities = activityService.selectActivityByName(name);
        return activities;
    }
    @ResponseBody
    @RequestMapping("/transaction/searchContactByName.do")
    public Object queryContactByName(String fullname){
        List<Contacts> contacts = contactsService.selectByName(fullname);
        contacts.forEach(contact->{
            if(contact.getAppellation()==null){
                contact.setAppellation("");
            }
        });
        return contacts;
    }
    @ResponseBody
    @RequestMapping("/transaction/createTransaction.do")
    public Object createTran(Transaction transaction, HttpServletRequest request){
        String user =((User)request.getSession().getAttribute("user")).getId();
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if(!transactionService.createTransaction(transaction,user)){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        User u = (User)((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest().getSession().getAttribute(ConstantsMessage.Session_User);
        operateLogMapper.insert(new OperateLog(u.getId(), "创建交易",u.getName(), transaction.getId()));
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/transaction/queryTransaction.do")
    public Object queryTran(String owner,String name,String customerName,String stage,String type,String source,String contactsId,int page,int count){
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsId",contactsId);
        map.put("count",count);
        map.put("startRow",(page-1)*count);
        List<Transaction> transactions = transactionService.selectTransactionsByConditions(map);
        int amount = transactionService.countTransactionByConditons(map);
        Map<String,Object> returnMap = new HashMap<>();
        returnMap.put("amount",amount);
        returnMap.put("transactions",transactions);
        return returnMap;
    }
    @ResponseBody
    @RequestMapping("/transaction/deleteTran.do")
    public Object deleteTran(String[] id){
        int i = transactionService.deleteTranBatch(id);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if(i<1){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        User u = (User)((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest().getSession().getAttribute(ConstantsMessage.Session_User);
        operateLogMapper.insert(new OperateLog(u.getId(), "删除交易",u.getName(), Arrays.stream(id).collect(Collectors.joining(","))));
        return returnMessage;
    }

    @RequestMapping("/transaction/edit.do")
    public String edit(String id,HttpServletRequest request){
        List<User> users = userService.querySurvival();
        request.setAttribute("users",users);
        List<DicValue> stageList = dicValueService.selectByType("stage");
        List<DicValue> tranTypeList = dicValueService.selectByType("transactionType");
        List<DicValue> clueStateList = dicValueService.selectByType("clueState");
        request.setAttribute("stageList",stageList);
        request.setAttribute("tranTypeList",tranTypeList);
        request.setAttribute("clueStateList",clueStateList);
        Transaction transaction = transactionService.selectTranByPrimaryKey(id);
        request.setAttribute("transaction",transaction);
        String s = activityService.selectNameById(transaction.getActivityId());
        request.setAttribute("transactionActivityName",s);
        Contacts contacts = contactsService.selectByPrimaryKey(transaction.getContactsId());
        if(contacts!=null){
            request.setAttribute("transactionContactsName",contacts.getFullname());
        }
        return "workbench/transaction/edit";
    }
    @ResponseBody
    @RequestMapping("/transaction/editTransaction.do")
    public Object editTransaction(Transaction transaction,HttpServletRequest request){
        String user =((User)request.getSession().getAttribute("user")).getId();
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if(!transactionService.updateTransaction(transaction,user)){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        User u = (User)((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest().getSession().getAttribute(ConstantsMessage.Session_User);
        operateLogMapper.insert(new OperateLog(u.getId(), "修改交易",u.getName(), transaction.getId()));
        return returnMessage;
    }
    @RequestMapping("/transaction/detail.do")
    public String detail(String id,HttpServletRequest request){
        Transaction transaction = transactionService.selectTransactionByPrimaryKey(id);
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        try{
        String string = resourceBundle.getString(transaction.getStage());
        transaction.setPossibility(string+"%");
        }catch (Exception e){
            transaction.setPossibility("未配置该属性对应可能性");
        }
        request.setAttribute("transaction",transaction);
        List<TransactionHistory> transactionHistories = transactionHistoryService.selectHistoryByPrimaryKey(id);
        request.setAttribute("transactionHistories",transactionHistories);
        List<DicValue> dicValues = dicValueService.selectByType("stage");
        request.setAttribute("dicValues",dicValues);
        return "workbench/transaction/detail";
    }
    @ResponseBody
    @RequestMapping("/transaction/funnel.do")
    public Object funnel(){
        List<Funnel> funnels = transactionService.selectFunnelByStage();
        return funnels;
    }
}
