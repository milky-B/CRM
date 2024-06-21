package com.gdut.crm.commons.util;

import com.gdut.crm.handlerInterceptor.SqlBeautyInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisConfiguration {

    //测试使用
    @Bean
//    @ConditionalOnProperty(value = "sql.detail.show", havingValue = "true", matchIfMissing = false)
    public SqlBeautyInterceptor sqlBeautyInterceptor() {
        return new SqlBeautyInterceptor();
    }

}
