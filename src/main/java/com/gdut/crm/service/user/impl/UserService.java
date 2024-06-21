package com.gdut.crm.service.user.impl;

import cn.hutool.crypto.SecureUtil;
import com.alibaba.fastjson.JSONObject;
import com.gdut.crm.commons.constants.MenuPermsEnum;
import com.gdut.crm.commons.pojo.Result;
import com.gdut.crm.commons.util.DateUtil;
import com.gdut.crm.commons.util.HuToolUtil;
import com.gdut.crm.mapper.MenuMapper;
import com.gdut.crm.mapper.RoleMapper;
import com.gdut.crm.mapper.UserMapper;
import com.gdut.crm.pojo.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import static com.gdut.crm.commons.constants.ConstantsMessage.Session_User;

@Slf4j
@Service("userService")
public class UserService {

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private RoleMapper roleMapper;

    @Autowired
    private MenuMapper menuMapper;

    public List<User> querySurvival() {
        List<User> users = userMapper.selectAll();
        List<User> result = new ArrayList<>();
        //筛选出有效的用户
        users.forEach(user -> {
            if("1".equals(user.getLockState())){
                if(DateUtil.formatDateTime(new Date()).compareTo(user.getExpireTime())<0){
                    result.add(user);
                }
            }
        });
        return result;
    }

    public User selectUserByLoginAct(String id) {
        return userMapper.selectUserByLoginAct(id);
    }


    public User user(Long id) {
        return null;
    }

    public UserVo getCurrentUserInfo(User user, boolean b) {
        return null;
    }

    public Result<List<UserVo>> userList(String lockState, Long roleId, String name, boolean b, Date startTime, Date endTime, boolean pagingData, Integer page, Integer pageSize) {
        int startRow = (page-1)*pageSize;
        List<User> users = userMapper.selectUser(lockState, roleId, name, startTime, endTime, pagingData, startRow, pageSize);
        long total = userMapper.count(lockState, roleId, name, startTime, endTime);
        log.info(JSONObject.toJSONString(users));
        if(CollectionUtils.isEmpty(users)){
            return Result.success();
        }
        List<String> collect = users.stream().map(User::getId).collect(Collectors.toList());
        List<UserRole> userRoles = roleMapper.selectAll(collect);
        Map<String, String> userRoleMapper = userRoles.stream().collect(Collectors.groupingBy(UserRole::getUserId, Collectors.mapping(userRole -> userRole.getName(), Collectors.joining(","))));
        List<UserVo> userVos = users.stream().map(user -> {
            UserVo userVo = new UserVo();
            BeanUtils.copyProperties(user, userVo);
            userVo.setDeptno(userRoleMapper.get(user.getId()));
            return userVo;
        }).collect(Collectors.toList());
        log.info(JSONObject.toJSONString(userVos));
        return Result.success(userVos,total);
    }

    public int insertUser(UserDto userDto) {
        User user = userMapper.selectUserByLoginAct(userDto.getLoginAct());
        if(user != null){
            throw new IllegalArgumentException("账号已经存在");
        }
        Role role = roleMapper.selectByPrimaryKey(userDto.getDeptId());
        user =  new User();
        BeanUtils.copyProperties(userDto,user);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String format = simpleDateFormat.format(new Date());
        user.setCreatetime(format);
        String createBy = ((User)((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getName();
        user.setCreateBy(createBy);
        String originPwd = user.getLoginPwd();
        String salt = HuToolUtil.salt();
        user.setSalt(salt);
        String loginPwd = SecureUtil.md5(originPwd + salt);
        user.setLoginPwd(loginPwd);
        user.setId(UUID.randomUUID().toString().replaceAll("-",""));
        user.setDeptno(role.getName());
        UserRole userRole = new UserRole();
        userRole.setUserId(user.getId());
        userRole.setRoleId(role.getId());
        userRole.setCreateTime(new Date());
        userRole.setModifyTime(new Date());
        userRole.setDelFlag(0);
        if (!StringUtils.hasLength(user.getLockState())) {
            user.setLockState("1");
        }
        roleMapper.insertUserRole(userRole);
        return userMapper.insert(user);
    }

    public User updateUser(UserDto userDto) {
        User user = userMapper.selectByPrimaryKey(userDto.getId());
        if(user==null){
            throw new IllegalArgumentException("无效id");
        }
        BeanUtils.copyProperties(userDto,user);
        UserRole role = roleMapper.selectAll(Collections.singletonList(user.getId())).get(0);
        if (!role.getRoleId().equals(userDto.getDeptId())) {
            roleMapper.deleteByUserId(user.getId());
            UserRole userRole = new UserRole();
            userRole.setUserId(user.getId());
            userRole.setRoleId(userDto .getDeptId());
            userRole.setDelFlag(0);
            userRole.setCreateTime(new Date());
            userRole.setModifyTime(new Date());
            roleMapper.insertUserRole(userRole);
            String name = roleMapper.selectByPrimaryKey(userDto.getDeptId()).getName();
            user.setDeptno(name);
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String format = simpleDateFormat.format(new Date());
        user.setEditTime(format);
        String editBy = ((User)((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getName();
        user.setEditBy(editBy);
        userMapper.updateSelective(user);
        return user;
    }

    public boolean deleteUserById(List<String> id) {
        userMapper.deleteByPrimaryKey(id);
        return true;
    }

    public Role insertRole(RoleDto dto) {
        return null ;
    }

    public void deleteRoleById(Long id) {

    }

    public Role updateRoleByDto(RoleDto dto) {
        return null;
    }

    public Result<List<Role>> roleList(String name, Integer state, boolean pagingData, Integer page, Integer pageSize) {
        int start = (page-1)* pageSize;
        List<Role> roles = roleMapper.selectRole(start, pageSize);
        long count = roleMapper.count();
        return Result.success(roles,count);
    }

    public RoleVo roleVo(Long id) {
        return null;
    }

    public Menu insertMenu(MenuDto dto) {
        return null;
    }

    public boolean deleteMenuById(Long id) {
        return true;
    }

    public Menu updateMenu(MenuDto dto) {
        return null;
    }

    public List<MenuVo> menuList() {
        String userId = ((User)((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getId();
        List<Menu> menus = menuMapper.selectMenusByUserId(userId, MenuPermsEnum.MANAGE.getPerms());
        List<MenuVo> menuVos = new ArrayList<>();
        for (Menu menu : menus) {
            if(menu.getParentId()==0){
                menuVos.add(buildMenuVo(menu, menus));
            }
        }
        MenuSort menuSort = menuMapper.selectMenuSort(userId);
        if(menuSort!=null){
            List<Long> sortIds = Arrays.stream(menuSort.getMenuSort().split(",")).map(sort -> Long.valueOf(sort)).collect(Collectors.toList());
            Map<Long, MenuVo> collect = menuVos.stream().collect(Collectors.toMap(MenuVo::getId, menuVo -> menuVo));
            menuVos.clear();
            sortIds.forEach(id->{
                menuVos.add(collect.get(id));
            });
        }
        return menuVos;
    }
    private MenuVo buildMenuVo(Menu menu, List<Menu> menus) {
        MenuVo menuVo = new MenuVo();
        BeanUtils.copyProperties(menu,menuVo);
        for (Menu m : menus) {
            if (menuVo.getId().equals(m.getParentId())) {
                if (menuVo.getChildren() == null) {
                    menuVo.setChildren(new ArrayList<>());
                }
                menuVo.getChildren().add(buildMenuVo(m, menus));
            }
        }
        return menuVo;
    }
    public Result<List<Menu>> menus(boolean pagingData, Integer page, Integer pageSize){
        String userId = ((User)((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getId();
        List<Menu> menus = menuMapper.selectMenus(userId,pagingData,(page-1)*pageSize,pageSize);
        long count = menuMapper.count();
        return Result.success(menus,count);
    }
    public List<Menu> menus(){
        String userId = ((User)((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getId();
        List<Menu> menus = menuMapper.selectManageMenus(userId);
        //看看有没有自定义顺序
        MenuSort menuSort = menuMapper.selectMenuSort(userId);
        if(menuSort!=null){
            List<Long> sortIds = Arrays.stream(menuSort.getMenuSort().split(",")).map(sort -> Long.valueOf(sort)).collect(Collectors.toList());
            Map<Long, Menu> collect = menus.stream().collect(Collectors.toMap(Menu::getId, m -> m));
            menus.clear();
            sortIds.forEach(id->{
                menus.add(collect.get(id));
            });
        }
        return menus;
    }


    public List<Role> allRole() {
        return roleMapper.select();
    }

    public User selectUserById(String id) {
        return userMapper.selectByPrimaryKey(id);
    }

    public String findRoleId(String id) {
        return userMapper.findRoleIdByUserId(id);
    }

    public void sortMenus(String id) {
        String userId = ((User) ((ServletRequestAttributes) (RequestContextHolder.getRequestAttributes())).getRequest().getSession().getAttribute(Session_User)).getId();
        menuMapper.deleteSort(userId);
        menuMapper.insertSort(userId,id);
    }
}
