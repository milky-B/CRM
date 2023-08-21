package com.bjpowernode.crm.service.workbench;

import com.bjpowernode.crm.pojo.workbench.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueRemarkService {
    List<ClueRemark> queryRemarkById(String id);
    int insertRemark(ClueRemark remark);
    int deleteRemark(String id);
    int updateRemark(ClueRemark clueRemark);
    void transferClueRemark(Map<String,String> map);
    int deleteByClueId(String clueId);
}
