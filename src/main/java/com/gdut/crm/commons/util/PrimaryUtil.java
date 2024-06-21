package com.gdut.crm.commons.util;

import java.util.UUID;

public class PrimaryUtil {
    public static String getUUID(){
        UUID uuid = UUID.randomUUID();
        String s = uuid.toString().replaceAll("[-]","");
        return s;
    }
}
