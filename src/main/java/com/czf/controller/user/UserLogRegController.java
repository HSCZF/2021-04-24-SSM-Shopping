package com.czf.controller.user;

import com.czf.model.User;
import com.czf.service.UserService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 登录注册逻辑处理
 */
@Controller
@RequestMapping("/user")
public class UserLogRegController {

    @Autowired
    private UserService userService;

    /**
     * 检查用户名是否可用 （使用 bootstrap has-success、has-error 提示）
     *
     * @param userName
     * @return
     */
    @RequestMapping("/checkRegisterUser")
    @ResponseBody
    public Msg checkRegisterUser(@RequestParam("userName") String userName) {
        System.out.println("/user/checkRegisterUser.......");
        System.out.println("拿到数据 = " + userName);
        // 格式校验
        String regx = "(^[a-zA-Z0-9_-]{1,10}$)|(^[\\u2E80-\\u9FFF]{2,7})";
        if (!userName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名必须是2-7位中文或者1-10位数字和字母的组合");
        }
        // 验证用户名重复
        //System.out.println("userService.findByUser(userName) = " + userService.findByUser(userName));
        int sum = userService.findByUserName(userName);
        if (sum == 0) {
            System.out.println("用户名可以用！");
            return Msg.success().add("va_msg", "");
        } else {
            System.out.println("用户名不可用！");
            return Msg.fail().add("va_msg", "用户名不可用！");
        }
    }

    /**
     * 校验密码是否合法
     *
     * @param passWord
     * @return
     */
    @RequestMapping("/checkPassword")
    @ResponseBody
    public Msg checkPassword(@RequestParam("passWord") String passWord) {
        if (passWord == "") {
            return Msg.fail().add("va_msg", "密码不能为空！");
        }
        if (passWord.length() < 6 || passWord.length() > 16) {
            return Msg.fail().add("va_msg", "密码长度为6-16位！");
        } else {
            return Msg.success().add("va_msg", "");
        }
    }

    /**
     * 校验密码是否和确认密码一致 （使用 bootstrap has-success、has-error 提示）
     *
     * @param passWord
     * @param regPass
     * @return
     */
    @RequestMapping("/checkConfirmPassword")
    @ResponseBody
    public Msg checkConfirmPassword(@RequestParam("passWord") String passWord, @RequestParam("regPass") String regPass) {
        if (!passWord.equals(regPass)) {
            return Msg.fail().add("va_msg", "密码与确认密码不一致！");
        } else {
            return Msg.success().add("va_msg", "");
        }
    }

    /**
     * 用户修改密码
     *
     * @return
     */
    @RequestMapping("/checkPassWord")
    public Msg checkPassWord() {
        System.out.println("user/checkPassWord....");
        return Msg.success();
    }

    /**
     * 检查真实姓名
     *
     * @param trueName
     * @return
     */
    @RequestMapping("/checkTrueUser")
    @ResponseBody
    public Msg checkTrueUser(@RequestParam("trueName") String trueName) {
        System.out.println("checkTrueUser....");
        String regTrue = "[\\u4e00-\\u9fa5]+";
        if (trueName == "") {
            return Msg.fail().add("va_msg", "姓名不能为空");
        }
        if (!trueName.matches(regTrue)) {
            return Msg.fail().add("va_msg", "姓名只能是全中文");
        } else {
            return Msg.success().add("va_msg", "");
        }
    }

    /**
     * 用户注册信息保存到数据库
     *
     * @param user
     * @param result
     * @return
     */
    @RequestMapping(value = "/loginIndex", method = RequestMethod.POST)
    @ResponseBody
    public Msg loginIndex(@Valid User user, BindingResult result) {
        //在User使用了@Pattern()，这里使用@Valid,使用BindingResult进行封装
        System.out.println("loginIndex->用户注册。。。。");
        String str = user.getUserName();
        if (userService.findByUserName(str) > 0) {
            System.out.println("请勿重复提交数据!");
            return Msg.fail().add("va_msg", "请勿重复提交数据!");
        } else {
            // 插入数据，数据库创建索引防止重复提交
            //  设置权限: 0：普通用户
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            user.setRole("普通用户");
            user.setAddTime(timestamp);
            user.setUpdateTime(timestamp);
            System.out.println(user);
            userService.insertUser(user);
            return Msg.success().add("va_msg", "注册成功！");
        }
    }

    /**
     * 校验用户账号密码是否正确, 在前端跳转登录成功页面，保存用户session
     *
     * @param userName
     * @param passWord
     * @return
     */
    @RequestMapping("/checkUser")
    @ResponseBody
    public Msg checkUser(@RequestParam("userName") String userName, @RequestParam("passWord") String passWord, HttpSession session) {
        System.out.println("checkUser..........");
        String strName = "";
        String strPass = "";
        System.out.println(userName + ", " + passWord);
        List<User> users = userService.findAllUser();
        for (User user : users) {
            strName = user.getUserName();
            strPass = user.getPassWord();
            if (strName.equals(userName) && strPass.equals(passWord)) {
                System.out.println(user);
                session.setAttribute("session_user", user);   // 保存登录session
                return Msg.success();
            }
        }
        return Msg.fail().add("error", "账号或密码不对！");
    }


    /* BootstrapValidator表单校验 */

    /**
     * 检查用户名是否可用 BootstrapValidator表单校验
     *
     * @param userName
     * @return
     */
    @RequestMapping("/checkRegisterUser1")
    @ResponseBody
    public Map<String, Object> checkRegisterUser1(String userName) {
        System.out.println("/user/checkRegisterUser1.......map集合");
        System.out.println("拿到数据 = " + userName);
        // 验证用户名重复
        //System.out.println("userService.findByUser(userName) = " + userService.findByUser(userName));
        Map<String, Object> map = new HashMap<>();
        int sum = userService.findByUserName(userName);
        if (sum == 0) {
            map.put("valid", true);
            System.out.println("用户名可以用！");
        } else {
            map.put("valid", false);
            map.put("message", "用户名不可用！");
            System.out.println("用户名不可用！");
        }
        return map;
    }



}
