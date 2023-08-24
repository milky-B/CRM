package com.bjpowernode.crm.controller.workbeanch;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkbenchController {
    @RequestMapping("/workbench/index.do")
    public String index(){
        return "workbench/index";
    }
    @RequestMapping("workbench/main/index.do")
    public String main(){
        return "workbench/main/index";
    }
}
