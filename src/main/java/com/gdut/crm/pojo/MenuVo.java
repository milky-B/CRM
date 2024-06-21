package com.gdut.crm.pojo;

import lombok.Data;

import java.util.List;

@Data
public class MenuVo {
    private Long id;

    private String name;

    private Integer menuSort;

    private Integer menuType;

    private String path;

    private Integer state;

    private String icon;

    private List<MenuVo> children;

    private String perms;

}
