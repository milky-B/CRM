package com.gdut.crm.handlerInterceptor;

import com.gdut.crm.commons.constants.ConstantsMessage;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


@Slf4j
@Component
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Object attribute = request.getSession().getAttribute(ConstantsMessage.Session_User);
        System.out.println("URI:"+request.getRequestURI());
        System.out.println("URL"+request.getRequestURL());
        System.out.println("***************************"+attribute);
        if(attribute != null){
            return true;
        }
        String path = request.getContextPath()+"/index.do";
        System.out.println(path);
        response.sendRedirect(request.getContextPath()+"/index.do");
        return false;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
    }
}
