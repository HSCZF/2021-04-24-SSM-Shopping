package com.czf.interceptor;

import com.czf.model.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 页面拦截，不登录无法访问其他页面
 */
public class UserInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        System.out.println("用户拦截器：preHandle");
        HttpSession session = request.getSession();
        User user = (User)request.getSession().getAttribute("session_user");
        System.out.println("用户缓存信息="+user);
        if(user == null){
            request.setAttribute("message", "您尚未登录，请登录后在进行相关操作");
            request.getRequestDispatcher("/WEB-INF/pages/user_login.jsp").forward(request, response);
            return false;
        }else {
            // 有登录信息，不拦截
            return true;
        }
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {
        System.out.println("用户拦截器：postHandle");
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {
        System.out.println("用户拦截器：afterCompletion");
    }
}
