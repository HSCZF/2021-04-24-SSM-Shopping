package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.service.AdminService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

/**
 * 管理员登录,注册管理
 */
@Controller
@RequestMapping("/admin")
public class AdminLogRegController {

    @Autowired
    private AdminService adminService;

    /**
     * 退出登录
     * @param session
     * @return
     */
    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.removeAttribute("session_admin");
        return "/system/index";
    }

    /**
     * 跳转到管理员登录页面
     *
     * @return
     */
    @RequestMapping("/adminLogin")
    public String adminLogin() {
        //System.out.println("跳转到管理员登录页面。。。");
        return "/system/login";
    }

    /**
     * 校验后台管理员账号密码是否正确, 正确存入session
     *
     * @param userName
     * @param passWord
     * @return
     */
    @RequestMapping("/checkAdmin")
    @ResponseBody
    public Msg validateAdmin(@RequestParam("userName") String userName, @RequestParam("passWord") String passWord, HttpSession session) {
        System.out.println("checkAdmin..........");
        //System.out.println("前端接收userName = " + userName);
        List<Admin> list = adminService.findAll();
        for (Admin account : list) {
            if (account.getAdminName().equals(userName) && account.getAdminPassWord().equals(passWord)) {
                session.setAttribute("session_admin", account);
                return Msg.success();
            }
        }
        return Msg.fail().add("error", "账号或密码不对！");
    }

    /**
     * 账号密码正确跳转到：后台管理首页
     * window.parent.location = "index";
     *
     * @return
     */
    @RequestMapping("/index")
    public String index() {
        System.out.println("首页index。。。");
        return "/system/index";
    }

    /**
     * 管理员是否存在，功能已取消，为了安全性
     * @param adminName
     * @return
     */
    @RequestMapping("/checkRepeatAdmin")
    @ResponseBody
    public Msg checkRepeatAdmin(@RequestParam("adminName") String adminName){
        System.out.println("checkRepeatAdmin。。。");
        System.out.println("存在1，不存在0 = " + adminService.findByAdminName(adminName));
        if(adminService.findByAdminName(adminName) == 1){
            return Msg.fail().add("va_msg", "管理员已存在");
        }
        return Msg.success().add("va_msg","管理员名可用");
    }

    /**
     * 添加普通管理员, 功能已取消，为了安全性
     * @param admin
     * @return
     */
    @RequestMapping(value = "/registerAdmin", method = RequestMethod.POST)
    @ResponseBody
    public Msg registerAdmin(@Valid Admin admin){
        System.out.println("registerAdmin。。。");
        int sum = adminService.findByAdminName(admin.getAdminName());
        System.out.println("存在1，不存在0 = " + sum);
        if(adminService.findByAdminName(admin.getAdminName()) > 0){
            System.out.println("该管理员数据已存在！");
            return Msg.fail().add("va_msg", "该管理员数据已存在！");
        }else {
            // 插入新的管理员，加入时间，并设置权限
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            admin.setCreateTime(timestamp);
            admin.setUpdateTime(timestamp);
            admin.setRole("普通管理员");  // 1：普通管理员

            System.out.println(admin);
            if(admin.getAdminName() != null && admin.getAdminPassWord() != null){
                adminService.insertAdmin(admin);
            }else {
                Msg.fail().add("va_msg","账号密码不能为空");
            }
            return Msg.success().add("va_msg","管理员名可用");
        }
    }




}
