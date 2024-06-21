package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.Funnel;
import com.gdut.crm.pojo.workbench.Transaction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction row);

    Transaction selectByPrimaryKey(String id);

    List<Transaction> selectAll();


    /**
    * @program: transation/edit
    * @return:  int
    * @description: 修改除了createBy,createId之外的值
    **/

    int updateByPrimaryKey(Transaction row);

    int insertFormTransferClue(Transaction transaction);

    /*customer-detail*/
    List<Transaction> selectByCustomerId(String id);
    /*contacts-detail*/
    List<Transaction> selectByContactsId(String id);

    /**
    * @program:
    * @return:
    * @description: index页面查询
    **/
    List<Transaction> selectTransactionsByConditions(Map<String,Object> conditions);

    int countTransactionByConditons(Map<String,Object> conditions);

    int deleteTranBatch(@Param("ids")String[] id);

    /*
    * program:transaction/edit
    * */
    Transaction selectOneByPrimaryKey(String id);

    Transaction selectTranByPrimaryKey(String id);

    List<Funnel> selectFunnelByStage();
}