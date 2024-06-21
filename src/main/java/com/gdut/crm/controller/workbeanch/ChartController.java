package com.gdut.crm.controller.workbeanch;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench")
public class ChartController {
    @RequestMapping("/chart/activity/index.do")
    public String sctivity(){
        return "workbench/chart/activity/index";
    }
    @RequestMapping("/chart/clue/index.do")
    public String clue(){
        return "workbench/chart/clue/index";
    }
    @RequestMapping("/chart/customerAndContacts/index.do")
    public String customerAndContacts(){
        return "workbench/chart/customerAndContacts/index";
    }
    @RequestMapping("/chart/transaction/index.do")
    public String transaction(){
        return "workbench/chart/transaction/index";
    }
}
