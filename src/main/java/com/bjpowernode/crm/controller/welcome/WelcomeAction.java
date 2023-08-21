package com.bjpowernode.crm.controller.welcome;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.IOException;
import java.io.PrintWriter;

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
}
