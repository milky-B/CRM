package com.gdut.crm.pojo;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class MenuDto {
    @ApiModelProperty(value = "主键")
    private Long id;

    @ApiModelProperty(value = "名称")
    private String name;

    @ApiModelProperty(value = "父菜单名称")
    private String parentName;

    @ApiModelProperty(value = "父菜单id")
    private Long parentId;

    @ApiModelProperty(value = "排序")
    private Integer menuSort;

    @ApiModelProperty(value = "类型; 1菜单 2功能")
    private Integer menuType;

    @ApiModelProperty(value = "路由地址")
    private String path;

    @ApiModelProperty(value = "是否隐藏")
    private Integer hidden;

    @ApiModelProperty(value = "状态")
    private Integer state;

    @ApiModelProperty(value = "图标")
    private String icon;

    @ApiModelProperty(value = "权限符号")
    private String perms;

}