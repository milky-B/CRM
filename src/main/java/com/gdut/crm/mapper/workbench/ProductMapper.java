package com.gdut.crm.mapper.workbench;

import com.gdut.crm.pojo.workbench.Product;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ProductMapper {
    List<Product> selectAll(Map<String, Object> map);
}
