package com.gdut.crm.controller.workbeanch;

import com.alibaba.fastjson.JSONObject;
import com.gdut.crm.commons.pojo.ReturnWithActivity;
import com.gdut.crm.mapper.OperateLogMapper;
import com.gdut.crm.pojo.MenuVo;
import com.gdut.crm.pojo.OperateLog;
import com.gdut.crm.pojo.workbench.Product;
import com.gdut.crm.service.user.impl.UserService;
import com.gdut.crm.service.workbench.impl.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
public class WorkbenchController {
    @Autowired
    private UserService userService;
    @Autowired
    private ProductService productService;

    @Autowired
    private OperateLogMapper operateLogMapper;

    @RequestMapping("/workbench/index.do")
    public String index(HttpServletRequest request) {
        List<MenuVo> menus = userService.menuList();
        request.setAttribute("menus", menus);
        log.info(JSONObject.toJSONString(menus));
        return "workbench/index";
    }


    @RequestMapping("workbench/main/index.do")
    public String mainIndex() {
        return "workbench/main/index";
    }

    @RequestMapping("workbench/product/index.do")
    public String productIndex(){
        return "workbench/product/index";
    }
    @RequestMapping("workbench/product/list.do")
    @ResponseBody
    public Object getPublicList(int count, int page){
        Map<String, Object> map = new HashMap<>();
        map.put("count", count);
        int startRow = (page - 1) * count;
        map.put("startRow", startRow);
        List<Product> activities = productService.selectAllByConditions(map);
        int i = productService.countAllByConditions(map);
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        returnWithActivity.setActivity(activities);
        returnWithActivity.setAmount(i);
        return returnWithActivity;
    }

    @RequestMapping("workbench/log/operateLog.do")
    public String operateLog(){
        return "workbench/log/operateLog";
    }

    @RequestMapping("workbench/log/list.do")
    @ResponseBody
    public Object logList(int count,int page){
        Map<String, Object> map = new HashMap<>();
        map.put("count", count);
        int startRow = (page - 1) * count;
        map.put("startRow", startRow);
        List<OperateLog> logs = operateLogMapper.selectAll(map);
        int i = operateLogMapper.countAllByConditions(map);
        ReturnWithActivity returnWithActivity = new ReturnWithActivity();
        returnWithActivity.setActivity(logs);
        returnWithActivity.setAmount(i);
        return returnWithActivity;
    }
}
