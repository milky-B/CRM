package com.gdut.crm.pojo;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
public class RoleMenu implements Serializable {
    private static final long serialVersionUID = 373427785807354178L;
    /**
     * 主键
     */
    private Long id;
    /**
     * 角色id
     */
    private Long roleId;
    /**
     * 权限菜单id
     */
    private Long menuId;
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