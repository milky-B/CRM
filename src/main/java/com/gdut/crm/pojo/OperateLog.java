package com.gdut.crm.pojo;

public class OperateLog {
    private Long id;
    private String userId;
    private String des;
    private String userName;
    private String messageId;

    public OperateLog(String userId, String describe, String userName, String messageId) {
        this.userId = userId;
        this.des = describe;
        this.userName = userName;
        this.messageId = messageId;
    }

    public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getDescribe() {
        return des;
    }

    public void setDescribe(String describe) {
        this.des = describe;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
}
