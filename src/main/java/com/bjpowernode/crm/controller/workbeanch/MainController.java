package com.bjpowernode.crm.controller.workbeanch;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
@RequestMapping("/workbench")
public class MainController {
    @RequestMapping("/main/index.do")
    public String demo2(){
        return "workbench/main/index";
    }
}
