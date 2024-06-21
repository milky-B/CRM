package com.gdut.crm.pojo.workbench;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Alias("activity")
@Data
public class Activity {
    private String id;

    private String owner;

    private String name;

    private String startDate;

    private String endDate;

    private String cost;

    private String description;

    private String createTime;

    private String createBy;

    private String editTime;

    private String editBy;
}