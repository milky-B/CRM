package com.gdut.crm.controller.welcome;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WelcomeAction {
    @RequestMapping({"/index.do","/index","/"})
    public String welcome(){
        return "index";
    }
    /*@RequestMapping({"/"})
    public String welcome1(){
        System.out.println("aaaaaaaaaaaaaaaaaaa");
        return "index";
    }*/
    @RequestMapping("/test")
    public String test(){
        return "test";
    }
}
