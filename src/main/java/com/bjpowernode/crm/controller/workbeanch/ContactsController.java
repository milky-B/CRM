package com.bjpowernode.crm.controller.workbeanch;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
@Controller
@RequestMapping("/workbench")
public class ContactsController {
    @RequestMapping("/contacts/index.do")
    public String index(){
        return "workbench/contacts/index";
    }
}
