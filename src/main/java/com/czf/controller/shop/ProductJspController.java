package com.czf.controller.shop;

import com.czf.service.ProductService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/product")
public class ProductJspController {

    @Autowired
    private ProductService productService;

    /**
     * 注销登录
     * @param session
     * @return
     */
    @RequestMapping("/logout")
    @ResponseBody
    public Msg logout(HttpSession session){
        System.out.println("/product/logout....");
        System.out.println("重定向到首页：index.jsp");
        session.removeAttribute("session_user");
        return Msg.success();
    }

}
