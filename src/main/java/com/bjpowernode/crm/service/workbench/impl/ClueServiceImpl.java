package com.bjpowernode.crm.service.workbench.impl;

import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.mapper.workbench.ClueActivityRelationMapper;
import com.bjpowernode.crm.mapper.workbench.ClueMapper;
import com.bjpowernode.crm.pojo.workbench.*;
import com.bjpowernode.crm.service.workbench.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.unit.DataUnit;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private TransactionRemarkService transactionRemarkService;

    @Override
    public List<Clue> selectAll() {
        return clueMapper.selectAll();
    }

    @Override
    public int insertClue(Clue clue) {
        return clueMapper.insert(clue);
    }

    @Override
    public List<Clue> queryCluesByConditionsAndCount(Map<String,Object> conditions) {
        return clueMapper.selectClueByConditionsAndCount(conditions);
    }

    @Override
    public int countClueByConditions(Map<String, Object> map) {
        return clueMapper.countClueByConditions(map);
    }

    @Override
    public int deleteClueByKeys(String[] ids) {
        return clueMapper.deleteByKeys(ids);
    }

    @Override
    public Clue queryOneForDetail(String id) {
        return clueMapper.selectOneForDetail(id);
    }

    @Override
    public int updateClue(Clue clue) {
        return clueMapper.updateByPrimaryKey(clue);
    }

    @Override
    public Clue queryByKey(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int associateActivity(List<Map<String, String>> list) {
        return clueMapper.insertRelateActivity(list);
    }

    @Override
    public Clue queryClueForTransfer(String id) {
        return clueMapper.selectClueForTransfer(id);
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public boolean transfer(Map<String, String> map) {
        String clueId = map.get("clueId");
        System.out.println(clueId);
        Clue clue = clueMapper.selectByPrimaryKey(clueId);
        //转换为客户表
        Customer customer = new Customer();
        customer.setId(PrimaryUtil.getUUID());
        customer.setOwner(clue.getOwner());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(map.get("createBy"));
        customer.setCreateTime(map.get("createTime"));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customerService.insert(customer);
        //转换为联系人
        Contacts contacts = new Contacts();
        contacts.setId(PrimaryUtil.getUUID());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(map.get("createBy"));
        contacts.setCreateTime(map.get("createTime"));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsService.insert(contacts);
        //将clueId对应的备注信息转换为客户和联系人的备注信息
        Map<String,String> clueRemarkTransferMap = new HashMap<>();
        clueRemarkTransferMap.put("clueId",clueId);
        clueRemarkTransferMap.put("customerId",customer.getId());
        clueRemarkTransferMap.put("contactsId",contacts.getId());
        clueRemarkService.transferClueRemark(clueRemarkTransferMap);
        //转换与市场的关联关系
        contactsActivityRelationService.insertRelationByTransfer(clueId, contacts.getId());
        //判断是否创建交易
        if("true".equals(map.get("tradeCheck"))){
            Transaction transaction = new Transaction();
            transaction.setId(PrimaryUtil.getUUID());
            transaction.setOwner(map.get("createBy"));
            transaction.setMoney(map.get("money"));
            transaction.setName(map.get("tradeName"));
            transaction.setExpectedDate(map.get("expectDate"));
            transaction.setCustomerId(customer.getId());
            transaction.setStage(map.get("stage"));
            transaction.setActivityId(map.get("activityId"));
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(map.get("createBy"));
            transaction.setCreateTime(map.get("createTime"));
            transactionService.insertFormTransfer(transaction);
            transactionRemarkService.insertRemarkByTransferClueRemark(clueId,transaction.getId());
        }
        //删除该线索，备注，关联
        clueMapper.deleteByPrimaryKey(clueId);
        clueRemarkService.deleteByClueId(clueId);
        clueActivityRelationMapper.deleteByClueId(clueId);
        return true;
    }
/*    private static Transaction createTrade(Map<String, String> map,Clue clue,String customerId,String contactsId){
            Transaction transaction = new Transaction();
            transaction.setId(PrimaryUtil.getUUID());
            transaction.setOwner(map.get("createBy"));
            transaction.setMoney(map.get("money"));
            transaction.setName(map.get("tradeName"));
            transaction.setExpectedDate(map.get("expectDate"));
            transaction.setCustomerId(customerId);
            transaction.setStage(map.get("stage"));
            transaction.setActivityId(map.get("activityId"));
            transaction.setContactsId(contactsId);
            transaction.setCreateBy(map.get("createBy"));
            transaction.setCreateTime(map.get("createTime"));
            return transaction;
    }*/
}
