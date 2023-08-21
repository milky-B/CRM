package com.bjpowernode.crm.mapper.workbench;

import com.bjpowernode.crm.pojo.workbench.ClueRemark;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

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