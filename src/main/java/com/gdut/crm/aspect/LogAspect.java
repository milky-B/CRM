package com.gdut.crm.aspect;

import com.alibaba.fastjson.JSON;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: lee
 * @Description: 日志aop,用于测试
 * @Date: 2023/11/16 14:11
 */
@Slf4j
@Aspect
@Component
@Order(1)
//@ConditionalOnProperty(name = "log.aop.enable",havingValue = "true",matchIfMissing = false)
public class LogAspect {
    @Pointcut("(execution(* com.gdut.crm.controller..*Controller.*(..)))")
    public void pointCut() {
    }
    @Around("pointCut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {

        Object[] args = joinPoint.getArgs();
        List<Object> collect = Arrays.stream(args).filter(object -> !(object instanceof MultipartFile)).collect(Collectors.toList());
        long count = Arrays.stream(args).filter(object -> (object instanceof MultipartFile)).count();
        if(count>0){
            collect.add("MultipartFile count:"+count);
        }
        String jsonString = JSON.toJSONString(collect);
        Signature signature = joinPoint.getSignature();
        String methodName = signature.getDeclaringType().getName() + "." + signature.getName();
        log.info("{},request:{}", methodName, jsonString);
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long end = System.currentTimeMillis();
        log.info("{},response:{},costTime:{}", methodName, result, end - start);
        return result;
    }
}
