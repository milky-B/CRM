package com.gdut.crm.commons.constants;

public enum MenuPermsEnum {
    MANAGE("MANAGE", "管理后台功能菜单"),
    PDA("PDA", "PDA功能菜单");

    final String perms;
    private String desc;

    MenuPermsEnum(String perms, String desc) {
        this.perms = perms;
        this.desc = desc;
    }

    public String getPerms() {
        return this.perms;
    }

    public String getDesc() {
        return this.desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
