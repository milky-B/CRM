package com.gdut.crm.commons.pojo;

public enum ResultEnum {
    SUCCESS(0, "success"),
    Fail(1, "fail"),
    INVALID_TOKEN(401, "Invalid token, please refresh");

    final Integer code;
    final String msg;

    ResultEnum(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return this.code;
    }

    public String getMsg() {
        return this.msg;
    }
}
