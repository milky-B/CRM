package com.gdut.crm.commons.util;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.DateUtil;

public class HSSFCellValue {

    private HSSFCellValue(){};
    public static String getStr(HSSFCell cell){
        String value = "";
        switch (cell.getCellType()){
            case HSSFCell.CELL_TYPE_STRING -> value=String.valueOf(cell.getStringCellValue());
            case HSSFCell.CELL_TYPE_NUMERIC -> {
                if(DateUtil.isCellDateFormatted(cell)){
                    value=String.valueOf(cell.getDateCellValue());
                }else{
                    value=String.valueOf(cell.getNumericCellValue());
                }
            }
            case HSSFCell.CELL_TYPE_BOOLEAN -> value=String.valueOf(cell.getBooleanCellValue());
            case HSSFCell.CELL_TYPE_FORMULA -> value=String.valueOf(cell.getCellFormula());
            default -> value="";
        }
        return value;
    }

}
