package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.model.Deliver;
import com.czf.model.User;
import com.czf.service.UserService;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

/**
 * 负责页面跳转
 */
@Controller
@RequestMapping("/admin")
public class AdminUserController {


    @Autowired
    private UserService userService;

    /**
     * 管理员分页所有用户
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllUser")
    public String getAllUser(Integer pageNum, Model model, HttpSession session){
        System.out.println("管理员：用户分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if(ObjectUtils.isEmpty(admin)){
            // 传回来为空，则设为 1
            return "system/login";
        }
        if(ObjectUtils.isEmpty(pageNum)){
            // 传回来为空，则设为 1
            pageNum = 1;
        }

        PageHelper.startPage(pageNum,5);

        List<User> userList = userService.findAllUser();
        PageInfo<User> pageInfo = new PageInfo<>(userList);
        model.addAttribute("pageInfo", pageInfo);

        return "/system/users";
    }

    /**
     * 管理员管理用户 多条件模糊查询（已实现）
     * @param user
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getParamsByUserInput")
    public String getParamsByUserInput(User user, Integer pageNum, Model model, HttpSession session){
        System.out.println("用户模糊搜索");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if(ObjectUtils.isEmpty(admin)){
            // 传回来为空，则设为 1
            return "system/login";
        }
        if(ObjectUtils.isEmpty(pageNum)){
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        System.out.println("pageNum = " + pageNum);
        PageHelper.startPage(pageNum,5);
        List<User> userList = userService.findUsersByParams(user);
        PageInfo<User> pageInfo = new PageInfo<>(userList);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("params", user);
        return "/system/users";
    }

    /**
     * (管理员面)添加新用户
     *
     * @param user
     * @return
     */
    @RequestMapping("/registerUser")
    @ResponseBody
    public Msg registerUser(User user) {
        System.out.println("registerUser。。。");
        int sum = userService.findByUserName(user.getUserName());
        System.out.println("存在1，不存在0 = " + sum);
        if (userService.findByUserName(user.getUserName()) > 0) {
            System.out.println("该用户数据已存在！");
            return Msg.fail().add("va_msg", "该用户已存在！");
        } else {
            // 插入新的管理员，加入时间，并设置权限
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            user.setAddTime(timestamp);
            user.setUpdateTime(timestamp);
            user.setRole("普通用户");
            System.out.println(user);
            if (user.getUserName() != null && user.getPassWord() != null) {
                userService.insertUser(user);
            } else {
                Msg.fail().add("va_msg", "账号密码不能为空");
            }
            return Msg.success().add("va_msg", "用户名可用");
        }
    }


}
