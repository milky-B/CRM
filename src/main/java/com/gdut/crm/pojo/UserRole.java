package com.gdut.crm.pojo;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * (Role)表实体类
 *
 * @author leen
 * @since 2023-12-21 10:45:07
 */
@Data
public class UserRole implements Serializable {
    private static final long serialVersionUID = -82156857601290691L;
    /**
     * 角色id
     */
    private Long id;
    private String userId;
    private Long roleId;

    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 修改时间
     */
    private Date modifyTime;

    private Integer delFlag;
    /**
     * 名字
     */
    private String name;
    /**
     * 统一编码
     */
    private String unionId;
    /**
     * 状态
     */
    private Integer state;
    /**
     * 描述
     */
    private String description;
    private Long tenantId;

}

