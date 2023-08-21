package com.bjpowernode.crm.controller.workbeanch;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.pojo.ReturnMessage;
import com.bjpowernode.crm.commons.pojo.ReturnWithCustomers;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.CustomerRemarkMapper;
import com.bjpowernode.crm.mapper.workbench.TransactionMapper;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.pojo.settings.DicValue;
import com.bjpowernode.crm.pojo.workbench.*;
import com.bjpowernode.crm.service.settings.DicValueService;
import com.bjpowernode.crm.service.user.UserService;
import com.bjpowernode.crm.service.workbench.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.unit.DataUnit;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Fail;
import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Success;

@Controller
@RequestMapping("/workbench")
public class CustomerController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;
    @Autowired
    private DicValueService dicValueService;
    @RequestMapping("/customer/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.querySurvival();
        request.setAttribute("users", users);
        return "workbench/customer/index";
    }
    @ResponseBody
    @RequestMapping("/customer/create.do")
    public Object create(String owner, String name, String phone,String description,
                       String contactSummary,String nextContactTime,String address,String website,HttpServletRequest request){
        Customer customer = new Customer();
        customer.setId(PrimaryUtil.getUUID());
        customer.setOwner(owner);
        customer.setName(name);
        customer.setPhone(phone);
        customer.setDescription(description);
        customer.setContactSummary(contactSummary);
        customer.setNextContactTime(nextContactTime);
        customer.setAddress(address);
        customer.setWebsite(website);
        customer.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        customer.setCreateTime(DateUtil.formatDateTime(new Date()));
        int insert = customerService.insert(customer);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(insert!=1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/customer/query.do")
    public Object query(String name,String owner,String phone,String website,int count, int page){
        Map<String,Object> conditions = new HashMap<>();
        conditions.put("name",name);
        conditions.put("owner",owner);
        conditions.put("phone",phone);
        conditions.put("website",website);
        conditions.put("count",count);
        conditions.put("startRow",(page-1)*count);
        List<Customer> customers = customerService.queryCustomerByConditions(conditions);
        int i = customerService.countAllByConditions(conditions);
        ReturnWithCustomers returnWithCustomers = new ReturnWithCustomers();
        returnWithCustomers.setAmount(i);
        returnWithCustomers.setCustomerList(customers);
        return returnWithCustomers;
    }
    @ResponseBody
    @RequestMapping("/customer/edit.do")
    public Object edit(String id){
        Customer customer = customerService.selectByPrimary(id);
        return customer;
    }
    @ResponseBody
    @RequestMapping("/customer/update.do")
    public Object update(Customer customer,HttpServletRequest request){
        customer.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        customer.setEditTime(DateUtil.formatDateTime(new Date()));
        int i = customerService.updateByPrimary(customer);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
            returnMessage.setMessage("系统忙请稍后再试");
        }
        return  returnMessage;
    }
    @ResponseBody
    @RequestMapping("/customer/delete.do")
    public Object delete(String[] ids){
        //删除客户要删除与其相关的备注，联系人，联系人备注,联系人相关活动
        customerRemarkService.deleteByCustomerIds(ids);
        contactsRemarkService.deleteRemarkByCustomerIds(ids);
        contactsActivityRelationService.deleteByCustomerId(ids);
        contactsService.deleteByCustomerId(ids);
        int i = customerService.deleteByKeys(ids);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(i<1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @RequestMapping("/customer/detail.do")
    public String detail(String id,HttpServletRequest request){
        Customer customer = customerService.selectOneById(id);
        List<Contacts> contactList = contactsService.selectByCustomerId(id);
        List<Transaction> transactionList = transactionService.selectOneByCustomerId(id);
        List<CustomerRemark> remarkList = customerRemarkService.selectByCustomerId(id);
        remarkList.forEach(remark->{
            if("0".equals(remark.getEditFlag())){
                remark.setEditBy(remark.getCreateBy());
                remark.setEditTime(remark.getCreateTime());
            }
        });
        List<User> users = userService.querySurvival();
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
        request.setAttribute("source",source);
        request.setAttribute("users",users);
        request.setAttribute("customer",customer);
        request.setAttribute("contactList",contactList);
        request.setAttribute("transactionList",transactionList);
        request.setAttribute("remarkList",remarkList);
        return "workbench/customer/detail";
    }
    @ResponseBody
    @RequestMapping("/customer/saveRemark.do")
    public Object saveRemark(String customerId,String noteContent,HttpServletRequest request){
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setCustomerId(customerId);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        customerRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        customerRemark.setEditFlag("0");
        customerRemark.setId(PrimaryUtil.getUUID());
        int i = customerRemarkService.insertOne(customerRemark);
        Map<String,Object> map = new HashMap<>();
        map.put("code",ConstantsMessage.Return_Object_Code_Fail);
        if(i==1){
            map.put("code",ConstantsMessage.Return_Object_Code_Success);
            map.put("remark",customerRemarkService.selectByPrimaryKey(customerRemark.getId()));
        }
        return map;
    }
    @ResponseBody
    @RequestMapping("/customer/deleteRemark.do")
    public Object deleteRemark(String id){
        int i = customerRemarkService.deleteByPrimaryId(id);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/customer/editRemark.do")
    public Object editRemark(String id,String noteContent,HttpServletRequest request){
        ReturnMessage returnMessage = new ReturnMessage();
        CustomerRemark customerRemark = new CustomerRemark();
        customerRemark.setId(id);
        customerRemark.setNoteContent(noteContent);
        customerRemark.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        customerRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        customerRemark.setEditFlag("1");
        try {
            int i = customerRemarkService.updateOne(customerRemark);
            returnMessage.setCode(Return_Object_Code_Success);
            returnMessage.setMessage(customerRemark.getEditTime());
            if (i == 0) {
                throw new Exception("更新失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
}
