package com.bjpowernode.crm.controller.settings;

import com.bjpowernode.crm.commons.constants.ConstantsMessage;
import com.bjpowernode.crm.commons.pojo.ReturnMessage;
import com.bjpowernode.crm.commons.util.DateUtil;
import com.bjpowernode.crm.commons.util.PrimaryUtil;
import com.bjpowernode.crm.pojo.User;
import com.bjpowernode.crm.pojo.settings.DicType;
import com.bjpowernode.crm.pojo.settings.DicValue;
import com.bjpowernode.crm.service.settings.DicTypeService;
import com.bjpowernode.crm.service.settings.DicValueService;
import com.bjpowernode.crm.service.user.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings")
public class SettingController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private DicTypeService dicTypeService;

    @RequestMapping({"/qx/user/toLogin.do"})
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/qx/user/login.do")
    @ResponseBody
    public Object login(String username, String password, String check, HttpServletRequest request, HttpServletResponse response){
        User user = userService.queryUserByUsernameAndPassword(username, password);
        ReturnMessage loginMessage = new ReturnMessage();
        loginMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        if(user == null){
            loginMessage.setMessage("用户名或者密码错误");
        }else if(user.getExpireTime().compareTo(DateUtil.formatDateTime(new Date()))<0){
            loginMessage.setMessage("账号过期");
        }else if("0".equals(user.getLockState())){
            loginMessage.setMessage("用户状态被锁定");
        }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
            System.out.println(request.getRemoteAddr());
            loginMessage.setMessage("ip受限");
        }else{
            loginMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
            //登录成功，保留用户名和密码
            request.getSession().setAttribute(ConstantsMessage.Session_User,user);
            //实现10天记住密码
            Cookie cookie1 = new Cookie(ConstantsMessage.Cookie_User_Name, user.getLoginAct());
            Cookie cookie2 = new Cookie(ConstantsMessage.Cookie_User_Password, user.getLoginPwd());
            cookie1.setPath(request.getContextPath());
            cookie2.setPath(request.getContextPath());
            if("true".equals(check)){
                cookie1.setMaxAge(10*24*60*60);
                cookie2.setMaxAge(10*24*60*60);
            }else{
                cookie1.setMaxAge(0);
                cookie2.setMaxAge(0);
            }
            response.addCookie(cookie1);
            response.addCookie(cookie2);
        }
        return loginMessage;
    }
    @RequestMapping("/qx/user/exit.do")
    public String exit(HttpServletRequest request,HttpServletResponse response){
        Cookie[] cookies = request.getCookies();
        for(Cookie cookie : cookies){
            cookie.setMaxAge(0);
            //删除cookie要保证路径一样
            cookie.setPath(request.getContextPath());
            response.addCookie(cookie);
        }
        request.getSession().invalidate();
        return "redirect:/index";
    }
    @RequestMapping("/index.do")
    public String index(){
        return "settings/index";
    }
    @RequestMapping("/dictionary/index.do")
    public String dicIndex(){
        return "settings/dictionary/index";
    }
    @RequestMapping("/dictionary/type/index.do")
    public String typeIndex(HttpServletRequest request){
        List<DicType> dicTypes = dicTypeService.selectAllDicType();
        request.setAttribute("typeList",dicTypes);
        return "settings/dictionary/type/index";
    }
    @RequestMapping("/dictionary/value/index.do")
    public String valueIndex(HttpServletRequest request){
        List<DicValue> dicValues = dicValueService.selectAllDicValue();
        request.setAttribute("dicValueList",dicValues);
        return "settings/dictionary/value/index";
    }
    @RequestMapping("/dictionary/value/create.do")
    public String valSave(HttpServletRequest request){
        List<DicType> dicTypes = dicTypeService.selectAllDicType();
        request.setAttribute("dicTypes",dicTypes);
        return "settings/dictionary/value/save";
    }
    @ResponseBody
    @RequestMapping("/dictionary/value/save.do")
    public Object createDicValue(DicValue dicValue){
        dicValue.setId(PrimaryUtil.getUUID());
        ReturnMessage returnMessage = new ReturnMessage();
        try {
            int i = dicValueService.insertDicValue(dicValue);
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
            if(i!=1){
                throw new Exception("插入异常");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @RequestMapping("/dictionary/value/edit.do")
    public String edit(String id,HttpServletRequest request){
        DicValue dicValue = dicValueService.selectOne(id);
        request.setAttribute("dicValue",dicValue);
        return "settings/dictionary/value/edit";
    }
    @ResponseBody
    @RequestMapping("/dictionary/value/update.do")
    public Object update(DicValue dicValue){
        ReturnMessage returnMessage = new ReturnMessage();
        int i = dicValueService.updateClue(dicValue);
        returnMessage.setCode(ConstantsMessage.Return_Object_Code_Success);
        if(i!=1){
            returnMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        }
        return returnMessage;
    }
    @ResponseBody
    @RequestMapping("/dictionary/value/delete.do")
    public Object delete(String[] ids){
        int i = dicValueService.deleteByKeys(ids);
        Map<String,Object> map = new HashMap<>();
        map.put("code",ConstantsMessage.Return_Object_Code_Success);
        if(i<1){
            map.put("code",ConstantsMessage.Return_Object_Code_Fail);
            return map;
        }
        List<DicValue> dicValues = dicValueService.selectAllDicValue();
        map.put("dicValueList",dicValues);
        return map;
    }
}
