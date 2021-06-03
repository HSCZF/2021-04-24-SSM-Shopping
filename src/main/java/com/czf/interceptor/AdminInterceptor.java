package com.czf.interceptor;

import com.czf.model.Admin;
import com.czf.model.Deliver;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AdminInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        System.out.println("管理员拦截器：preHandle");
        HttpSession session = request.getSession();
        Admin admin = (Admin) request.getSession().getAttribute("session_admin");
        System.out.println("管理员缓存信息="+admin);
        if(admin == null){
            request.setAttribute("message", "您尚未登录，请登录后在进行相关操作");
            request.getRequestDispatcher("/WEB-INF/pages/system/login.jsp").forward(request, response);
            return false;
        }else {
            // 有登录信息，不拦截
            return true;
        }
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
        System.out.println("管理员拦截器：postHandle");
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {
        System.out.println("管理员拦截器：afterCompletion");
    }
}
