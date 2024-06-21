package com.gdut.crm.commons.util;

import java.util.Random;

public class HuToolUtil {
    private static char[] hex={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

    //随机生成长度为16位的十六进制的盐
    public static String salt(){
        Random random = new Random();
        StringBuilder str = new StringBuilder(16);
        for(int i=0;i<str.capacity();i++){
            str.append(hex[random.nextInt(16)]);
        }
        return str.toString();
    }

}
