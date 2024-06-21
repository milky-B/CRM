package com.gdut.crm.pojo;

import lombok.Data;

import java.util.List;

@Data
public class RoleVo {
    private Long id;
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
    private List<Long> menuList;
}
