package com.czf.controller.user;

import com.czf.model.User;
import com.czf.service.UserService;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 主逻辑处理控制器
 */
@Controller
@RequestMapping("/user")
public class UserController {

    /**
     * 自动注入
     */
    @Autowired
    private UserService userService;

    /**
     * 退出登录
     * @param session
     * @return
     */
    @RequestMapping("/logout")
    @ResponseBody
    public String logout(HttpSession session){
        System.out.println("logout....");
        System.out.println("重定向到首页：index.jsp");
        session.removeAttribute("session_user");
        return "index";
    }

    /**
     * 给用户分页，分页插件PageHelper
     *
     * @param pn
     * @return
     */
    @RequestMapping("/userAll")
    @ResponseBody
    public Msg getUserWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        // 在查询之前只需要调用，传入页码，以及每页的大小PageHelper.startPage( , );
        System.out.println("用户分页");
        PageHelper.startPage(pn, 5);
        // startPage后面紧跟的这个查询是一个分页查询
        List<User> userAll = userService.findAllUser();
        // 使用PageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        // 封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(userAll, 5);
        return Msg.success().add("userPageInfo", page);
    }

    /**
     * 根据id获取用户信息
     *
     * @param single_id
     * @return
     */
    @RequestMapping(value = "/users/{single_id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getByUserId(@PathVariable("single_id") Integer single_id) {
        System.out.println("进入到  user/users/" + single_id + "........");
        System.out.println("single_id = " + single_id);
        User user = userService.getByUserId(single_id);
        System.out.println(user);
        return Msg.success().add("user", user);
    }

    /**
     * (管理员面)添加新用户
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/registerUser", method = RequestMethod.POST)
    @ResponseBody
    public Msg registerUser(@Valid User user) {
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

    /**
     * 用户更新
     *
     * @return
     */
    @RequestMapping(value = "/users/adminUpdateCenter", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateUserId(Integer userId, String trueName, String phone, String address) {
        System.out.println("updateUserId...");
        User user = userService.getByUserId(userId);
        user.setTrueName(trueName);
        user.setPhone(phone);
        user.setAddress(address);
        System.out.println("更新->" + user);
        userService.updateUser(user);
        return Msg.success();
    }

    /**
     * input方法拿不到，只能一个个传参更新
     * @param userId
     * @param userName
     * @param phone
     * @param address
     * @return
     */
    @RequestMapping("/users/updateCenter")
    @ResponseBody
    public Msg updateCenter(Integer userId, String userName, String phone, String address) {
        System.out.println("updateCenter：个人中心信息修改");
        User user = userService.getByUserId(userId);
        user.setUserName(userName);
        user.setPhone(phone);
        user.setAddress(address);
        System.out.println("更新->" + user);
        userService.updateUser(user);
        return Msg.success();
    }

    /**
     * 删除单个或者多个用户，功能二合一
     *
     * @return
     */
    @RequestMapping(value = "/users/{ids}", method = RequestMethod.POST)
    @ResponseBody
    public Msg deleteUserById(@PathVariable("ids") String ids, HttpSession session) {
        System.out.println("/admin/users/{ids}....");
        User user = (User)session.getAttribute("session_user");
        if(user == null){
            // 匹配"-"为多删除操作
            if (ids.contains("-")) {
                System.out.println("进入 删除多个用户");
                String[] str_ids = ids.split("-"); //切割id
                Integer[] del_ids = new Integer[str_ids.length + 2];
                int i = 0;
                for (String str_id : str_ids) {
                    del_ids[i++] = Integer.parseInt(str_id); // 字符串强转整型
                }
                int sum = userService.deleteByManyUserId(del_ids);
                if(sum > 1){
                    return Msg.success().add("vag", "删除成功");
                }else {
                    return Msg.fail().add("vag", "删除失败");
                }
            } else {
                // 未匹配到"-"为单操作
                System.out.println("进入 删除单个用户");
                Integer id = Integer.parseInt(ids);
                System.out.println("id = " + id);
                int sum1 = userService.deleteByUserId(id);
                if(sum1 > 1){
                    return Msg.success().add("vag", "删除成功");
                }else {
                    return Msg.fail().add("vag", "删除失败");
                }
            }
        }else {
            return Msg.fail().add("vag", "无法删除在线的用户");
        }
    }

    /**
     * 管理员删除一个用户
     * @param id
     * @param session
     * @return
     */
    @RequestMapping("/deleteUserById")
    @ResponseBody
    public Msg deleteUserById(Integer id, HttpSession session) {
        System.out.println("/admin/users/deleteUserById....");
        User user = (User)session.getAttribute("session_user");
        System.out.println("进入 删除单个用户");
        System.out.println("id = " + id);
        int sum1 = userService.deleteByUserId(id);
        if(sum1 >= 1){
            return Msg.success().add("vag", "删除成功");
        }else {
            return Msg.fail().add("vag", "删除失败");
        }

    }

    /**
     * 检查原始密码是否一致
     *
     * @param originalPassWord
     * @param session
     * @return
     */
    @RequestMapping("checkOriginalPassWord")
    @ResponseBody
    public Map<String, Object> checkOriginalPassWord(String originalPassWord, HttpSession session) {
        System.out.println("/user/checkOriginalPassWord.......map集合");
        Map<String, Object> map = new HashMap<>();
        // 从登陆 session 缓存当前用户
        User user = (User) session.getAttribute("session_user");
        System.out.println("拿到session_user缓存user = " + user);
        System.out.println("拿到前台输入的原密码 = " + originalPassWord);
        User isExist = userService.selectByLoginNameAndPassword(user.getUserName(), originalPassWord);
        if (isExist != null) {
            System.out.println("原始密码正确 = " + isExist);
            map.put("valid", true);
        } else {
            map.put("valid", false);
            map.put("message", "原始密码不正确！");
            System.out.println("原始密码不正确！");
        }
        return map;
    }

    /**
     * 用户修改密码
     *
     * @param newPassWord
     * @return
     */
    @RequestMapping("/updatePassWord")
    @ResponseBody
    public Msg updatePassWord(String newPassWord, HttpSession session) {
        // 从登陆 session 缓存当前用户
        System.out.println("/user/updatePassWord...");
        User user = (User) session.getAttribute("session_user");
        String OriginalPassWord = user.getPassWord();
        System.out.println(user);
        System.out.println("新密码 = " + newPassWord);
        // 设置新密码
        user.setPassWord(newPassWord);

        // 要是更新失败了，那就换回原来的密码，避免存入数据库
        boolean flag = userService.updateUserPassWord(user);
        if (flag) {
            //session.invalidate(); 会把管理员、配送员、用户都注销掉，用下面这种
            session.removeAttribute("session_user");
            user.setPassWord(null);
            System.out.println("密码修改成功");
            return Msg.success().add("va_msg", "密码修改成功！");
        } else {
            // 避免存入数据库，设置为 null,或者插入之前的密码
            //user.setPassWord(OriginalPassWord);
            user.setPassWord(null);
            session.setAttribute("session_user", user);
            System.out.println("密码修改失败");
            return Msg.fail().add("va_msg", "密码修改失败！");
        }
    }

    /**
     * 个人信息管理中心
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userCenter")
    public String userCenter(HttpSession session, Model model){
        System.out.println("个人信息管理中心。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        User user1 = userService.getByUserId(user.getId());
        System.out.println("用户到底拿到没有，服了 user1 = " + user1);
        model.addAttribute("user",user1);
        return "userCenter";
    }


}
