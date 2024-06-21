package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark row);

    ClueRemark selectByPrimaryKey(String id);

    List<ClueRemark> selectAll();

    int updateByPrimaryKey(ClueRemark row);

    List<ClueRemark> selectByClueKey(String id);

    /*查询备注用于联系人，客户表的备注转换*/
    List<ClueRemark> selectClueRemarkToTransfer(String clueId);

    int deleteByClueId(String clueId);
}