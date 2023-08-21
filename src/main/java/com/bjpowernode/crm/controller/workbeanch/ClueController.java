package com.bjpowernode.crm.controller.workbeanch;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.pojo.ReturnMessage;
import com.bjpowernode.crm.commons.pojo.ReturnWithActivity;
import com.bjpowernode.crm.commons.pojo.ReturnWithClues;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.pojo.settings.DicValue;
import com.bjpowernode.crm.pojo.workbench.Activity;
import com.bjpowernode.crm.pojo.workbench.Clue;
import com.bjpowernode.crm.pojo.workbench.ClueRemark;
import com.bjpowernode.crm.service.settings.DicValueService;
import com.bjpowernode.crm.service.user.UserService;
import com.bjpowernode.crm.service.workbench.ActivityService;
import com.bjpowernode.crm.service.workbench.ClueRemarkService;
import com.bjpowernode.crm.service.workbench.ClueService;
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
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;

    @RequestMapping("/clue/index.do")
    public String index(HttpServletRequest request){
        List<User> users = userService.querySurvival();
        request.setAttribute("users", users);
        List<DicValue> dicValueList = dicValueService.selectAllDicValue();
        List<DicValue> appellation = new ArrayList<>();
        List<DicValue> clueState = new ArrayList<>();
        List<DicValue> source = new ArrayList<>();
        dicValueList.forEach(dicValue -> {
            switch (dicValue.getTypeCode()){
                case "appellation" -> appellation.add(dicValue);
                case "clueState" -> clueState.add(dicValue);
                case "source" -> source.add(dicValue);
            }
        });
        request.setAttribute("appellation",appellation);
        request.setAttribute("clueState",clueState);
        request.setAttribute("source",source);
        return "workbench/clue/index";
    }
    @ResponseBody
    @RequestMapping("/clue/create.do")
    public Object create(Clue clue,HttpServletRequest request){
        //id,createTime,createBy,
        clue.setId(PrimaryUtil.getUUID());
        clue.setCreateTime(DateUtil.formatDateTime(new Date()));
        clue.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = clueService.insertClue(clue);
            returnMessage.setCode(Return_Object_Code_Success);
            if(i!=1){
                throw new Exception("插入失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
            return returnMessage;
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/clue/queryClueByConditions.do")
    public Object query( String owner, String company,String fullname,String  phone,String mphone,String state,String source,int page,int count){
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("company",company);
        map.put("fullname",fullname);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        int startRow = (page-1)*count;
        map.put("startRow",startRow);
        map.put("count",count);

        List<Clue> list = clueService.queryCluesByConditionsAndCount(map);
        int amount = clueService.countClueByConditions(map);
        ReturnWithClues returnWithClues = new ReturnWithClues();
        returnWithClues.setAmount(amount);
        returnWithClues.setClueList(list);
        return returnWithClues;
    }
    @ResponseBody
    @RequestMapping("/clue/delete.do")
    public Object delete(String[] id){
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = clueService.deleteClueByKeys(id);
            returnMessage.setCode(Return_Object_Code_Success);
            if(i<1){
                throw new Exception("插入失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
            returnMessage.setMessage("系统忙,请稍后再试");
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/clue/queryOne.do")
    public Object query(String id){
        Clue clue = clueService.queryByKey(id);
        return clue;
    }
    @ResponseBody
    @RequestMapping("/clue/update.do")
    public Object update(Clue clue,HttpServletRequest request){
        clue.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        clue.setEditTime(DateUtil.formatDateTime(new Date()));
        ReturnMessage returnMessage = new ReturnMessage();
        try {
            int i = clueService.updateClue(clue);
            returnMessage.setCode(Return_Object_Code_Success);
            if(i<1)
                throw new Exception("插入失败");
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @RequestMapping("/clue/detail.do")
    public String detail(String id,HttpServletRequest request){
        Clue clue = clueService.queryOneForDetail(id);
        request.setAttribute("clue",clue);
        List<ClueRemark> remarkList = clueRemarkService.queryRemarkById(id);
        remarkList.forEach(a->{
            if("0".equals(a.getEditFlag())){
                a.setEditTime(a.getCreateTime());
                a.setEditBy(a.getCreateBy());
            }
        });
        request.setAttribute("remarkList",remarkList);
        List<Activity> activities = activityService.queryActivityAssociateClue(id);
        request.setAttribute("activityList",activities);
        return "workbench/clue/detail";
    }
    @ResponseBody
    @RequestMapping("/clue/saveRemark.do")
    public Object saveRemark(String noteContent,String clueId,HttpServletRequest request){
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setId(PrimaryUtil.getUUID());
        clueRemark.setNoteContent(noteContent);
        clueRemark.setClueId(clueId);
        clueRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        clueRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        clueRemark.setEditFlag("0");
        Map<String,Object> map = new HashMap<>();
        try{
            int i = clueRemarkService.insertRemark(clueRemark);
            if(i!=1){
                throw new Exception();
            }
            map.put("code", Return_Object_Code_Success);
            map.put("clueRemark",clueRemark);
        }catch (Exception e){
            e.printStackTrace();
            map.put("code", Return_Object_Code_Fail);
        }
        return map;
    }
    @ResponseBody
    @RequestMapping("/clue/deleteRemark.do")
    public Object deleteRemark(String id){
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = clueRemarkService.deleteRemark(id);
            if(i!=1){
                throw new Exception("插入异常");
            }
            returnMessage.setCode(Return_Object_Code_Success);
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/clue/editRemark.do")
    public Object editRemark(String id,String noteContent,HttpServletRequest request){
        ClueRemark clueRemark = new ClueRemark();
        clueRemark.setEditFlag("1");
        clueRemark.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        clueRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        clueRemark.setId(id);
        clueRemark.setNoteContent(noteContent);
        int i = clueRemarkService.updateRemark(clueRemark);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        returnMessage.setMessage(clueRemark.getEditTime());
        return  returnMessage;
    }
    @ResponseBody
    @RequestMapping("/clue/deleteActivity.do")
    public Object deleteAct(String id){
        ReturnMessage returnMessage = new ReturnMessage();
        try{
            int i = activityService.deleteRelation(id);
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
    @ResponseBody
    @RequestMapping("/clue/queryActivity.do")
    public Object queryAct(String id,String name){
        List<Activity> activities;
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        try {
            activities = activityService.selectForClue(id,name);
            returnWithActivity.setAmount(1);
            if(activities.size()==0){
                returnWithActivity.setAmount(0);
            }
            returnWithActivity.setActivity(activities);
        }catch (Exception e){
            e.printStackTrace();
            returnWithActivity.setAmount(0);
        }
        return returnWithActivity;
    }
    @ResponseBody
    @RequestMapping("/clue/associate.do")
    public Object associate(String[] id,String clueId){
        List<Activity> activities = new ArrayList<>();
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        try {
            List<Map<String,String>> list = new ArrayList<>();
            Map<String,String> map;
            for (String str:id) {
                map=new HashMap<>();
                map.put("id",PrimaryUtil.getUUID());
                map.put("clueId",clueId);
                map.put("activityId",str);
                list.add(map);
            }
            clueService.associateActivity(list);
            returnWithActivity.setAmount(1);
            if(list.size()<1){
                throw new Exception("添加出错");
            }
            activities = activityService.queryActivityAssociateClue(clueId);
            returnWithActivity.setActivity(activities);
        }catch (Exception e){
            e.printStackTrace();
            returnWithActivity.setAmount(0);
        }
        return returnWithActivity;
    }
    @RequestMapping("/clue/convert.do")
    public String convert(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueForTransfer(id);
        List<DicValue> dicValues = dicValueService.selectByType("stage");
        request.setAttribute("clue",clue);
        request.setAttribute("dicValues",dicValues);
        return "workbench/clue/convert";
    }
    @ResponseBody
    @RequestMapping("/clue/searchActivity.do")
    public Object searchActivity(String id){
        List<Activity> activities = activityService.selectActivityByNameAndClueId(null,id);
        return activities;
    }
    @ResponseBody
    @RequestMapping("/clue/searchByNameAndId.do")
    public Object searchByName(String name,String id){
        List<Activity> activities = activityService.selectActivityByNameAndClueId(name,id);
        return activities;
    }

    /**
    * @program: clueId,formData
    * @description: 通过判断tradeCheck确认是否转换为交易
    * @return:returnWithMessage
    **/

    @ResponseBody
    @RequestMapping("/clue/transfer.do")
    public Object transfer(String clueId,String tradeCheck,String money,String tradeName,String expectDate,String stage,String activityId,HttpServletRequest request){
        Map<String,String> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("tradeCheck",tradeCheck);
        map.put("money",money);
        map.put("tradeName",tradeName);
        map.put("expectDate",expectDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("createBy",((User)request.getSession().getAttribute("user")).getId());
        map.put("createTime",DateUtil.formatDateTime(new Date()));
        boolean transfer = clueService.transfer(map);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        returnMessage.setMessage("成功转换，点击确认后返回线索页面");
        if(!transfer){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
}
