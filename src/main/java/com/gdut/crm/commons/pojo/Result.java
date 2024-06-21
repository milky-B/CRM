package com.gdut.crm.commons.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Result<T> {
    private Integer code;
    private String msg;
    private T data;
    private Long total;

    public static <T> Result<T> success() {
        return new Result(ResultEnum.SUCCESS.getCode(), ResultEnum.SUCCESS.getMsg(), (Object) null, (Long) null);
    }

    public static <T> Result<T> success(T data) {
        return new Result(ResultEnum.SUCCESS.getCode(), ResultEnum.SUCCESS.getMsg(), data, (Long) null);
    }

    public static <T> Result<T> success(T data, Long total) {
        return new Result(ResultEnum.SUCCESS.getCode(), ResultEnum.SUCCESS.getMsg(), data, total);
    }

    public static <T> Result<T> success(String msg, T data) {
        return new Result(ResultEnum.SUCCESS.getCode(), msg, data, (Long) null);
    }

    public static <T> Result<T> fail() {
        return new Result(ResultEnum.Fail.getCode(), ResultEnum.Fail.getMsg(), (Object) null, (Long) null);
    }

    public static <T> Result<T> fail(String msg) {
        return new Result(ResultEnum.Fail.getCode(), msg, (Object) null, (Long) null);
    }
    public static <T> Result<T> invalidToken() {
        return new Result(ResultEnum.INVALID_TOKEN.getCode(), ResultEnum.INVALID_TOKEN.getMsg(), (Object)null, (Long)null);
    }
}
