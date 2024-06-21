package com.gdut.crm.commons.pojo;

public class ReturnMessage {
    private String code;
    private String message;

    @Override
    public String toString() {
        return "LoginMessage{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ReturnMessage() {
    }
}
