package com.bjpowernode.crm.controller.workbeanch;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.pojo.ReturnMessage;
import com.bjpowernode.crm.commons.pojo.ReturnWithActivity;
import com.bjpowernode.crm.commons.pojo.ReturnWithRemarks;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.HSSFCellValue;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.pojo.workbench.Activity;
import com.bjpowernode.crm.pojo.workbench.ActivityRemark;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.service.workbench.ActivityRemarkService;
import com.bjpowernode.crm.service.workbench.ActivityService;
import com.bjpowernode.crm.service.user.UserService;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.*;

import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Fail;
import static com.bjpowernode.crm.commons.constants.ConstantsMessage.Return_Object_Code_Success;


@Controller
@RequestMapping("/workbench")
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/activity/index.do")
    public String index(HttpServletRequest request) {
        List<User> users = userService.querySurvival();
        request.setAttribute("users", users);
        return "workbench/activity/index";
    }

    @ResponseBody
    @RequestMapping("/activity/save.do")
    public Object save(Activity activity, HttpServletRequest request) {
        activity.setId(PrimaryUtil.getUUID());
        User user = (User) request.getSession().getAttribute(ConstantsMessage.Session_User);
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateUtil.formatDateTime(new Date()));
        int i = activityService.saveActivity(activity);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setMessage(Return_Object_Code_Success);
        if (i != 1) {
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
            returnMessage.setMessage("服务繁忙，请稍后再试");
        }
        return returnMessage;
    }

    @ResponseBody
    @RequestMapping("/activity/query.do")
    public Object query(String name, String owner, String startDate, String endDate, int count, int page) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("count", count);
        int startRow = (page - 1) * count;
        map.put("startRow", startRow);
        List<Activity> activities = activityService.selectAllByConditions(map);
        int i = activityService.countAllByConditions(map);
        System.out.println(i);
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        returnWithActivity.setActivity(activities);
        returnWithActivity.setAmount(i);
        return returnWithActivity;
    }

    @ResponseBody
    @RequestMapping("/activity/delete.do")
    public Object delete(String[] ids) {
        int i = activityService.deleteByIds(ids);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if (i < 1) {
            returnMessage.setMessage("删除失败");
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }

    @ResponseBody
    @RequestMapping("/activity/queryByKey.do")
    public Object queryByKey(String id) {
        Activity activity = activityService.queryByKey(id);
        return activity;
    }

    @ResponseBody
    @RequestMapping("/activity/update.do")
    public Object update(Activity activity, HttpServletRequest request) {
        activity.setEditBy(((User) request.getSession().getAttribute(ConstantsMessage.Session_User)).getId());
        activity.setEditTime(DateUtil.formatDateTime(new Date()));
        int i = activityService.updateActivity(activity);
        ReturnMessage returnMessage = new ReturnMessage();
        returnMessage.setCode(Return_Object_Code_Success);
        if (i != 1) {
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
            returnMessage.setMessage("更新失败");
        }
        return returnMessage;
    }

    @RequestMapping("/activity/download.do")
    public void download(String[] ids, HttpServletResponse response) {
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=allActivityList.xls");
        if (ids != null) {
            response.setHeader("Content-Disposition", "attachment; filename=activityListByConditions.xls");
        }
        //select出所有的活动 a.id, u.id as owner, a.name, start_date, end_date, cost, description, a.create_time, a.create_by,a.edit_time, a.edit_by
        List<Activity> activities = activityService.selectAllForDownload(ids);
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("sheet1");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("owner");
        cell = row.createCell(2);
        cell.setCellValue("name");
        cell = row.createCell(3);
        cell.setCellValue("startDate");
        cell = row.createCell(4);
        cell.setCellValue("endDate");
        cell = row.createCell(5);
        cell.setCellValue("cost");
        cell = row.createCell(6);
        cell.setCellValue("description");
        cell = row.createCell(7);
        cell.setCellValue("createTime");
        cell = row.createCell(8);
        cell.setCellValue("createBy");
        cell = row.createCell(9);
        cell.setCellValue("editTime");
        cell = row.createCell(10);
        cell.setCellValue("editBy");
        for (int i = 0; i < activities.size(); i++) {
            row = sheet.createRow(i + 1);
            cell = row.createCell(0);
            cell.setCellValue(activities.get(i).getId());
            cell = row.createCell(1);
            cell.setCellValue(activities.get(i).getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activities.get(i).getName());
            cell = row.createCell(3);
            cell.setCellValue(activities.get(i).getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activities.get(i).getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activities.get(i).getCost());
            cell = row.createCell(6);
            cell.setCellValue(activities.get(i).getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activities.get(i).getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activities.get(i).getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activities.get(i).getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activities.get(i).getEditBy());
        }
        try (ServletOutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*
        @ResponseBody
        @RequestMapping("/activity/upload.do")
        public Object uploadTest(MultipartFile file) throws IOException {
            System.out.println(file.getName());//file
            System.out.println(file.getOriginalFilename());
            File file1 = new File("E:\\EdgeDownload\\uploadTest",file.getOriginalFilename());
            file.transferTo(file1);

            FileInputStream fileInputStream = new FileInputStream("E:\\EdgeDownload\\uploadTest\\" + file.getOriginalFilename());
            *//*byte[] buff = new byte[32];
        int len=0;
        while((len=fileInputStream.read(buff))!=-1){
            System.out.print(new String(buff,0,len));
        }*//*
        HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);
        HSSFSheet sheet = workbook.getSheet("sheet1");

        sheet.forEach(row->{
            row.forEach(cell -> {
                switch (cell.getCellType()){
                    case HSSFCell.CELL_TYPE_STRING -> System.out.println(cell.getStringCellValue());
                    case HSSFCell.CELL_TYPE_NUMERIC -> System.out.println(cell.getNumericCellValue());
                    case HSSFCell.CELL_TYPE_BOOLEAN -> System.out.println(cell.getBooleanCellValue());
                }
            });
        });
        return null;
    }*/
    @ResponseBody
    @RequestMapping("/activity/upload.do")
    public Object uploadTest(HttpServletRequest request,MultipartFile file) {
        //读取文件
        //保存至本地
        //poi取出，封装成类
        //插入
        //queryAll
        ReturnMessage returnMessage = new ReturnMessage();
        try (InputStream inputStream = file.getInputStream();
        HSSFWorkbook workbook = new HSSFWorkbook(inputStream);){
            HSSFSheet sheet = workbook.getSheetAt(0);
            //a.id, u.id as owner, a.name, start_date, end_date, cost, description, a.create_time, a.create_by,a.edit_time, a.edit_by
            HSSFRow row = sheet.getRow(0);
            List<String> list = new ArrayList<>();
            row.forEach(cell -> {
                list.add(cell.getStringCellValue());
            });
            List<Activity> activities = new ArrayList<>();
            Activity activity;
            HSSFCell cell;
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                row = sheet.getRow(i);
                activity = new Activity();
                activity.setId(PrimaryUtil.getUUID());
                activity.setCreateTime(DateUtil.formatDateTime(new Date()));
                activity.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
                for (int t = 0; t < row.getLastCellNum(); t++) {
                    cell = row.getCell(t);
                    String value = HSSFCellValue.getStr(cell);
                    switch (list.get(t)) {
                        case "owner" ->{activity.setOwner(value);}
                        case "name" -> activity.setName(value);
                        case "startDate" -> activity.setStartDate(value);
                        case "endDate" -> activity.setEndDate(value);
                        case "cost" -> activity.setCost(value);
                        case "description" -> activity.setDescription(value);
                    }
                }
                String owner = activity.getOwner();
                String regex = "^[0-9a-z]{32}$";
                if(owner==""||owner==null || owner.length()!=32 && regex.matches(owner)){
                    activity.setOwner(((User)request.getSession().getAttribute("user")).getId());
                }
                activities.add(activity);
            }
            int i = activityService.insertActivities(activities);
            returnMessage.setCode(Return_Object_Code_Success);
            returnMessage.setMessage("成功插入数据" + i + "条");
        }catch (Exception e) {
            returnMessage.setCode(Return_Object_Code_Fail);
            returnMessage.setMessage("插入失败，请检查");
            e.printStackTrace();
        }
            return returnMessage;
    }

    @RequestMapping("/activity/detail.do")
    public String detail(String id,HttpServletRequest request){
        Activity activity = activityService.queryActivityById(id);
        System.out.println(activity);
        List<ActivityRemark> list = activityRemarkService.queryRemarkByActivityId(id);
        list.forEach(a->{
            if("0".equals(a.getEditFlag())){
                a.setEditTime(a.getCreateTime());
                a.setEditBy(a.getCreateBy());
            }
        });
        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",list);
        return "workbench/activity/detail";
    }
    @ResponseBody
    @RequestMapping("/activity/saveRemark.do")
    public Object saveRemark(String id,String remark,HttpServletRequest request){
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setActivityId(id);
        activityRemark.setNoteContent(remark);
        activityRemark.setCreateBy(((User)request.getSession().getAttribute("user")).getId());
        activityRemark.setCreateTime(DateUtil.formatDateTime(new Date()));
        activityRemark.setId(PrimaryUtil.getUUID());
        activityRemark.setEditFlag("0");
        ReturnWithRemarks returnWithRemarks = new ReturnWithRemarks();
        try {
            int i = activityRemarkService.saveActivityRemark(activityRemark);
            returnWithRemarks.setCode(Return_Object_Code_Success);
            if (i != 1) {
                throw new Exception("插入失败");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnWithRemarks.setCode(Return_Object_Code_Fail);
        }
        activityRemark.setEditBy(activityRemark.getCreateBy());
        activityRemark.setEditTime(activityRemark.getCreateTime());
        returnWithRemarks.setActivityRemark(activityRemark);
        return returnWithRemarks;
    }
    @ResponseBody
    @RequestMapping("/activity/deleteRemark.do")
    public Object deleteRemark(String id){
        ReturnMessage returnMessage = new ReturnMessage();
        int i = activityRemarkService.deleteActivityRemark(id);
        returnMessage.setCode(Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/activity/editRemark.do")
    public Object editRemark(String id,String noteContent,HttpServletRequest request){
        ReturnMessage returnMessage = new ReturnMessage();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setId(id);
        activityRemark.setNoteContent(noteContent);
        activityRemark.setEditBy(((User)request.getSession().getAttribute("user")).getId());
        activityRemark.setEditTime(DateUtil.formatDateTime(new Date()));
        activityRemark.setEditFlag("1");
        try {
            int i = activityRemarkService.updateActivityRemark(activityRemark);
            returnMessage.setCode(Return_Object_Code_Success);
            returnMessage.setMessage(activityRemark.getEditTime());
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