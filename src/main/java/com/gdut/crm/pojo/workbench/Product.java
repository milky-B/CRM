package com.gdut.crm.pojo.workbench;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * (TProduct)实体类
 * @author leen
 * @description 
 */
@Data
public class Product implements Serializable {
    private static final long serialVersionUID = 847411244015831814L;

        private String id;
         
        private String name;
         
        private String sort;
         
        private Date createTime;
         
        private Date modifyTime;
         
        private String createBy;
         
        private String editBy;
         
        private String price;
         
        private String describe;

}


