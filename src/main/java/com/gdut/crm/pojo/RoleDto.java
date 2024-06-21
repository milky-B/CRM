package com.gdut.crm.pojo;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * (Role)表实体类
 *
 * @author leen
 * @since 2023-12-21 10:45:07
 */
@Data
public class RoleDto {
    /**
     * 角色id
     */
    @ApiModelProperty(value = "角色ID")
    private Long id;
    /**
     * 名字
     */
    @ApiModelProperty(value = "角色名字")
    private String name;
    /**
     * 统一编码
     */
    @ApiModelProperty(value = "角色统一编码")
    private String unionId;
    /**
     * 状态
     */
    @ApiModelProperty(value = "角色状态，1-启用，0-禁用")
    private Integer state;
    /**
     * 描述
     */
    @ApiModelProperty(value = "角色描述")
    private String description;
    @ApiModelProperty(value="菜单列表")
    private List<Long> menuList;
}

