package com.gdut.crm.service.workbench.impl;

import com.gdut.crm.mapper.workbench.ProductMapper;
import com.gdut.crm.pojo.workbench.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ProductService {
    @Autowired
    private ProductMapper productMapper;

    public List<Product> selectAllByConditions(Map<String, Object> map) {
        return productMapper.selectAll(map);
    }

    public int countAllByConditions(Map<String, Object> map) {
        return 0;
    }
}
