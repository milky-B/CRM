package com.gdut.crm.pojo;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class Menu implements Serializable {
    private static final long serialVersionUID = -25754656328855133L;
    /**
     * 主键
     */

    private Long id;
    /**
     * 名称
     */
    private String name;
    /**
     * 父菜单名称
     */
    private String parentName;
    /**
     * 父菜单id
     */
    private Long parentId;
    /**
     * 排序
     */
    private Integer menuSort;
    /**
     * 类型; 1菜单 2功能
     */
    private Integer menuType;
    /**
     * 路由地址
     */
    private String path;
    /**
     * 是否隐藏
     */
    private Integer hidden;
    /**
     * 状态
     */
    private Integer state;
    /**
     * 图标
     */
    private String icon;
    /**
     * 权限符号
     */
    private String perms;
    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 修改时间
     */
    private Date modifyTime;

    private Integer delFlag;

}