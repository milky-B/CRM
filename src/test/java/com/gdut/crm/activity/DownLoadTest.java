package com.gdut.crm.activity;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class DownLoadTest {
    public static void main(String[] args) {
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("sheet1");
        HSSFRow hssfRow = sheet.createRow(0);
        HSSFCell cell = hssfRow.createCell(0);
        cell.setCellValue("id");
        cell = hssfRow.createCell(1);
        cell.setCellValue("name");
        cell = hssfRow.createCell(2);
        cell.setCellValue("age");

        for(int i = 1;i<10;i++){
            hssfRow = sheet.createRow(i);
            cell = hssfRow.createCell(0);
            cell.setCellValue(i);
            cell = hssfRow.createCell(1);
            cell.setCellValue("name"+i);
            cell = hssfRow.createCell(2);
            cell.setCellValue(i);
        }

        try(FileOutputStream fileOutputStream = new FileOutputStream("E://student.xls")) {
            workbook.write(fileOutputStream);
            workbook.close();
        }  catch (IOException e) {
            e.printStackTrace();
        }
    }
}
