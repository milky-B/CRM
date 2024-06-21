package com.gdut.crm.commons.pojo;

public enum PageInitInfoEnum {
    INIT_PAGE_NUM(1, "初始页数"),
    INIT_PAGE_SIZE(10, "初始页大小"),
    MAX_PAGE_SIZE(100, "最大页大小");

    final Integer initValue;
    final String desc;

    private PageInitInfoEnum(Integer initValue, String desc) {
        this.initValue = initValue;
        this.desc = desc;
    }

    public Integer getInitValue() {
        return this.initValue;
    }

    public String getDesc() {
        return this.desc;
    }
}
