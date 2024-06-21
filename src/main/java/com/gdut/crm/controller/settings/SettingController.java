package com.gdut.crm.controller.settings;

import cn.hutool.crypto.SecureUtil;
import com.gdut.crm.commons.constants.ConstantsMessage;
import com.gdut.crm.commons.pojo.PageInitInfoEnum;
import com.gdut.crm.commons.pojo.Result;
import com.gdut.crm.commons.pojo.ReturnMessage;
import com.gdut.crm.commons.util.DateUtil;
import com.gdut.crm.commons.util.PrimaryUtil;
import com.gdut.crm.pojo.*;
import com.gdut.crm.pojo.settings.DicType;
import com.gdut.crm.pojo.settings.DicValue;
import com.gdut.crm.service.settings.DicTypeService;
import com.gdut.crm.service.settings.DicValueService;
import com.gdut.crm.service.user.impl.UserService;
import io.swagger.annotations.ApiParam;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import javax.naming.AuthenticationException;
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

    /*
    采用加密后如何实现记住密码：

    普通的明文记住密码,不用考虑这个密码是不是用户输入的,因为验证方式一样,
    而加密后的记住密码,如果用户没有选择更换账号或者重新输入密码,选择直接登录那么传入的密文密码直接与数据库的32位md5直接比对

    记住密码无非就是方便用户登录,等到用户下次登录的时候可以直接点击登录就进入系统
    但是有可能用户想切换账号并不想以上次记住的账号登录

    问题1: 加密后记住密码,保存的是32位md5密码,如何判别下次登录时的密码是自动填充的32位md5密码,而不是用户自己输入的
    var inputElement = document.getElementById("password");
		inputElement.addEventListener("input", function() {
			if (this.value.length > 10) {
				this.value = this.value.slice(0, 10); // 限制输入框内容为前 10 个字符
			}
		});

		限制用户的密码长度,保证其长度小于32就行
		因为用户输入的密码长度不能为32,而自动填充的可以为32,自动填充的初始值不会触发input事件
	然后根据用户名和密码长度决定是否走原始密码验证

	问题2: 加密后的密码为32位，显示的长度太长
	删除一个字符一下就变成限制的最大长度,会让用户觉得奇怪

	究其原因还是${cookie.user.password}
	我们可以在页面跳转到登录页面前先进行判断,如果有记住密码那么就使得这个password的input填充为和密码最长限制一致的特殊符号,让用户在感官上和不会产生差异

	问题3: 填充的特殊字符和用户设置的密码可能冲突

	这样的话只能限制用户注册时所能使用的字符,然后填充字段使用密码中肯定不会出现的字符,到时候就以此为是否为记住密码后的验证的依据
	或者限制用户必须使用至少一个字母,数字,符号这样,说白了就是填充字段不能为用户密码

     */
    @RequestMapping("/qx/user/login.do")
    @ResponseBody
    public Object login(String username, String password, String check, HttpServletRequest request, HttpServletResponse response){
        User user = userService.selectUserByLoginAct(username);
        ReturnMessage loginMessage = new ReturnMessage();
        loginMessage.setCode(ConstantsMessage.Return_Object_Code_Fail);
        if(user == null){
            loginMessage.setMessage("用户名或者密码错误");
            return loginMessage;
        }
        String cookieName = null;
        String cookiePassword = null;
        String holder = null;
        Cookie[] cookies = request.getCookies();
        if(cookies != null  && cookies.length>0){
            for (Cookie cookie : cookies){
                String str = cookie.getName();
                String value = cookie.getValue();
                switch (str){
                    case "username" -> cookieName = value;
                    case "holder" -> holder = value;
                    case "password" -> cookiePassword = value;
                }
            }
        }
        String pwd = user.getLoginPwd();
        if(cookieName!=null&&cookieName.equals(username)&&password.equals(holder)){//如果用户名和cookie中的相同并且密码是十个“*”则进行md5的直接比对
            if(!pwd.equals(cookiePassword)){
                user = null;
            }
        }else{//正常输入密码的加密后验证
            String salt = user.getSalt();
            if(!SecureUtil.md5(password+salt).equals(pwd)){
                user=null;
            }
        }
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
            Cookie cookie3 = new Cookie(ConstantsMessage.Cookie_User_Holder, ConstantsMessage.Cookie_User_Holder_Value);
            cookie1.setPath(request.getContextPath());
            cookie2.setPath(request.getContextPath());
            cookie3.setPath(request.getContextPath());
            if("true".equals(check)){
                cookie1.setMaxAge(10*24*60*60);
                cookie2.setMaxAge(10*24*60*60);
                cookie3.setMaxAge(10*24*60*60);
            }else{
                cookie1.setMaxAge(0);
                cookie2.setMaxAge(0);
                cookie3.setMaxAge(0);
            }
            response.addCookie(cookie1);
            response.addCookie(cookie2);
            response.addCookie(cookie3);
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


    /**
     * 通过主键查询单条数据
     */
    @GetMapping("{id}")
//    @ApiOperation(value = "获取用户详情", notes = "获取用户详情")
    public Result<UserVo> getUserOne(@PathVariable @ApiParam Long id) throws AuthenticationException {
        User user = userService.user(id);
        if (user == null) {
            return Result.fail("无效id");
        }
        return Result.success(userService.getCurrentUserInfo(user, false));
    }
    @GetMapping("/qx/user/index.do")
    public String index(HttpServletRequest request) {
        List<Role> roles = userService.allRole();
        request.setAttribute("roles",roles);
        return "/settings/qx/user/index";
    }
    @GetMapping("/qx/role/index.do")
    public String roleIndex(HttpServletRequest request) {
        List<Role> roles = userService.allRole();
        request.setAttribute("roles",roles);
        return "/settings/qx/role/index";
    }
    @GetMapping("/qx/user/detail.do")
    public String detail(String id,HttpServletRequest request) {

        List<Role> roles = userService.allRole();
        request.setAttribute("roles",roles);
        User user = userService.selectUserById(id);
        request.setAttribute("user",user);
        String roleId = userService.findRoleId(id);
        request.setAttribute("roleId",roleId);
        return "/settings/qx/user/detail";
    }
    /**
     * 通过查询条件筛选数据
     */
    @GetMapping("/qx/user/list")
    @ResponseBody
//    @ApiOperation(value = "获取用户列表", notes = "获取用户列表")
    public Result<List<UserVo>> getUserList(@ApiParam("登录账号") @RequestParam(required = false) String lockState,
                                            @ApiParam("角色") @RequestParam(required = false) Long roleId,
                                            @ApiParam("用户名称") @RequestParam(required = false) String name,
                                            @ApiParam("创建日期 yyyy-MM-dd") @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
                                            @ApiParam("创建日期 yyyy-MM-dd") @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
                                            @ApiParam(value = "是否分页数据；true-分页；false-不分页,默认true") @RequestParam(defaultValue = "true") boolean pagingData,
                                            @ApiParam(value = "页码,默认1") @RequestParam(required = false) Integer page,
                                            @ApiParam(value = "每页大小,默认10") @RequestParam(required = false) Integer count) throws AuthenticationException {
        if (page == null) {
            page = PageInitInfoEnum.INIT_PAGE_NUM.getInitValue();
        }
        if (count == null) {
            count = PageInitInfoEnum.INIT_PAGE_SIZE.getInitValue();
        }
        if (count > PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue()) {
            count = PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue();
        }
        return userService.userList(lockState, roleId, name, false, startTime, endTime,pagingData, page, count);
    }

    /*public static void main(String[] args) {
        LocalDate localDate = LocalDate.now();
        System.out.println(localDate);
        LocalDateTime now = LocalDateTime.now();
        System.out.println(now);
        localDate = LocalDate.from(now);
        System.out.println(localDate);
    }*/

    /**
     * 新增数据
     */
    @PostMapping("/qx/user/register")
    @ResponseBody
//    @LogAnnotation(operateType = OperateTypeEnum.ADD, message = "注册用户")
    public Result<Integer> addUser(@RequestBody UserDto userDto) throws AuthenticationException {
        //EmployeeEnum.getInstance(userDto.getType());
        return Result.success(userService.insertUser(userDto));
    }

    /**
     * 修改数据
     */
    @PostMapping("/qx/user/update")
//    @LogAnnotation(operateType = OperateTypeEnum.UPDATE, message = "更新用户")
    @ResponseBody
    public Result<User> updateUser(UserDto userDto) {
        return Result.success(userService.updateUser(userDto));
    }

    /**
     * 删除数据
     *
     * @return
     */
    @PostMapping("/qx/user/delete")
    @ResponseBody
    public Result<Boolean> deleteUser(@ApiParam @RequestParam List<String> id) {
        if(CollectionUtils.isEmpty(id)){
            return Result.success();
        }
        return Result.success(userService.deleteUserById(id));
    }

    /***********************************************角色****************************************/
    @PostMapping("/role")
//    @LogAnnotation(operateType = OperateTypeEnum.ADD, message = "添加角色")
    public Result<Role> addRole(@RequestBody RoleDto dto) {
        return Result.success(userService.insertRole(dto));
    }

    @DeleteMapping("/role/{id}")
    public Result deleteRole(@PathVariable Long id) {
        userService.deleteRoleById(id);
        return Result.success();
    }

    @PutMapping("/role")
//    @LogAnnotation(operateType = OperateTypeEnum.UPDATE, message = "更改角色")
    public Result<Role> updateRole(@RequestBody RoleDto dto) {
        return Result.success(userService.updateRoleByDto(dto));
    }

    @GetMapping("/qx/role/list")
    @ResponseBody
    public Result<List<Role>> roleList(@ApiParam("名称") @RequestParam(required = false) String name,
                                         @ApiParam("状态") @RequestParam(required = false) Integer state,
                                         @ApiParam(value = "是否分页数据；true-分页；false-不分页,默认true") @RequestParam(defaultValue = "true") boolean pagingData,
                                         @ApiParam(value = "页码,默认1") @RequestParam(required = false) Integer page,
                                         @ApiParam(value = "每页大小,默认10") @RequestParam(required = false) Integer pageSize) {
        Result result = null;
        if (page == null) {
            page = PageInitInfoEnum.INIT_PAGE_NUM.getInitValue();
        }
        if (pageSize == null) {
            pageSize = PageInitInfoEnum.INIT_PAGE_SIZE.getInitValue();
        }
        if (pageSize > PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue()) {
            pageSize = PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue();
        }
        return userService.roleList(name, state, pagingData, page, pageSize);
    }

    @GetMapping("role/{id}")
    public Result<RoleVo> role(@PathVariable("id") @ApiParam("主键") Long id) {
        return Result.success(userService.roleVo(id));
    }

    /**********************************************菜单管理**************************************************/
    @PostMapping("menu")
//    @LogAnnotation(operateType = OperateTypeEnum.ADD, message = "添加菜单")
    public Result<Menu> addMenu(@RequestBody MenuDto dto) {
        return Result.success(userService.insertMenu(dto));
    }

    @DeleteMapping("menu/{id}")
//    @LogAnnotation(operateType = OperateTypeEnum.DELETE, message = "删除菜单")
    public Result<Boolean> deleteMenu(@PathVariable("id") @ApiParam("主键") Long id) {
        return Result.success(userService.deleteMenuById(id));
    }

    @PutMapping("menu")
//    @LogAnnotation(operateType = OperateTypeEnum.UPDATE, message = "更新菜单")
    public Result<Menu> updateMenu(@RequestBody MenuDto dto) {
        return Result.success(userService.updateMenu(dto));
    }

    @GetMapping("/qx/enum/list")
    @ResponseBody
    public Result<List<Menu>> menuList(@ApiParam(value = "是否分页数据；true-分页；false-不分页,默认true") @RequestParam(defaultValue = "true") boolean pagingData,
                                         @ApiParam(value = "页码,默认1") @RequestParam(required = false) Integer page,
                                         @ApiParam(value = "每页大小,默认10") @RequestParam(required = false) Integer pageSize) {
        Result result = null;
        if (page == null) {
            page = PageInitInfoEnum.INIT_PAGE_NUM.getInitValue();
        }
        if (pageSize == null) {
            pageSize = PageInitInfoEnum.INIT_PAGE_SIZE.getInitValue();
        }
        if (pageSize > PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue()) {
            pageSize = PageInitInfoEnum.MAX_PAGE_SIZE.getInitValue();
        }
        return userService.menus(pagingData , page,pageSize);
    }

    @GetMapping("/qx/menu/index.do")
    public String menuIndex(){
        return "/settings/qx/permission/index";
    }

    @GetMapping("/qx/menu/set.do")
    public String setMenu(HttpServletRequest request){
        List<Menu> menus = userService.menus();
        request.setAttribute("menus",menus);
        return "settings/qx/permission/set";
    }
    @GetMapping("/qx/menu/demo.do")
    public String setMenuDemo(HttpServletRequest request){
        List<Menu> menus = userService.menus();
        request.setAttribute("menus",menus);
        return "settings/qx/permission/demo";
    }
    @GetMapping("/qx/menus")
    @ResponseBody
    public List<Menu> setMenus(HttpServletRequest request){
        return userService.menus();
    }
    @GetMapping("/qx/menu/updateSort")
    @ResponseBody
    public Result updateSort(String id){
        if(StringUtils.hasLength(id) ){
            userService.sortMenus(id);
        }
        return Result.success();
    }
}
