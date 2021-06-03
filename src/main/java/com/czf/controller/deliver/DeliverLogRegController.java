package com.czf.controller.deliver;



import com.czf.model.Deliver;
import com.czf.service.DeliverService;
import com.czf.utils.Msg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
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
 * 登录注册
 */
@Controller
@RequestMapping("/deliver")
public class DeliverLogRegController {

    @Autowired
    private DeliverService deliverService;

    /**
     * 注册页面
     *
     * @return
     */
    @RequestMapping("/toRegisterDeliver")
    public String toLoginDeliver(){
        return "deliver/deliver_register";
    }

    /**
     * 登录页面
     *
     * @return
     */
    @RequestMapping("/toLoginDeliverToLogin")
    public String toLoginDeliverToLogin(){
        return "deliver/deliver_login";
    }

    /**
     * 注销登录
     * @param session
     * @return
     */
    @RequestMapping("/logout")
    @ResponseBody
    public Msg logout(HttpSession session){
        System.out.println("logout....");
        System.out.println("重定向到首页：deliver_login.jsp");
        session.removeAttribute("session_deliver");
        return Msg.success();
    }

    /**
     * 校验用户账号密码是否正确，正确则去到登录大厅
     *
     * @param deliverName
     * @param deliverPassWord
     * @return
     */
    @RequestMapping("/checkDeliver")
    @ResponseBody
    public Msg checkDeliver(@RequestParam("deliverName") String deliverName, @RequestParam("deliverPassWord") String deliverPassWord, HttpSession session) {
        System.out.println("deliver/checkDeliver..........");
        String strName = "";
        String strPass = "";
        List<Deliver> delivers = deliverService.findAllDeliver();
        for (Deliver deliver : delivers) {
            strName = deliver.getDeliverName();
            strPass =  deliver.getDeliverPassWord();
            if (strName.equals(deliverName) && strPass.equals(deliverPassWord)) {
                // 给配送员设置缓存
                session.setAttribute("session_deliver", deliver);
                return Msg.success().add("vag", "登录成功");
            }
        }
        return Msg.fail().add("error", "账号或密码不对！");
    }

    /**
     * 添加配送员
     * @param deliver
     * @return
     */
    @RequestMapping(value = "/registerDeliver", method = RequestMethod.POST)
    @ResponseBody
    public Msg registerDeliver(@Valid Deliver deliver){
        System.out.println("registerDeliver。。。");
        int sum = deliverService.findByDeliverName(deliver.getDeliverName());
        System.out.println("存在1，不存在0 = " + sum);
        if(deliverService.findByDeliverName(deliver.getDeliverName()) > 0){
            System.out.println("该配送员已存在！");
            return Msg.fail().add("va_msg", "该配送员已存在！");
        }else {
            // 插入新的管理员，加入时间，并设置权限
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            deliver.setAddTime(timestamp);
            deliver.setUpdateTime(timestamp);
            deliver.setRole("配送员");
            System.out.println(deliver);
            if(deliver.getDeliverName() != null && deliver.getDeliverPassWord() != null){
                deliverService.insertDeliver(deliver);
            }else {
                Msg.fail().add("va_msg","密码不能为空");
            }
            return Msg.success().add("va_msg","配送员名可用");
        }
    }

    /**
     * 验证配送小哥的账号名是否重复了 BootstrapValidator表单校验
     * @return
     */
    @RequestMapping("/checkDeliverName")
    @ResponseBody
    public Map<String, Object> checkDeliverName(String deliverName){
        Map<String, Object> map = new HashMap<>();
        int sum = deliverService.findByDeliverName(deliverName);
        if (sum == 0) {
            // bootstrap 传送前端的唯一写法
            map.put("valid", true);
            System.out.println("配送名可以用！");
        } else {
            map.put("valid", false);
            map.put("message", "配送名不可用！");
        }
        return map;
    }

    /**
     * 验证密码是否和原密码一致
     * @return
     */
    @RequestMapping("/checkDeliverOriginalPassWord")
    @ResponseBody
    public Map<String, Object> checkDeliverOriginalPassWord(String originalPassWord, HttpSession session){
        Map<String, Object> map = new HashMap<>();
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        String password = deliver.getDeliverPassWord();
        if(password.equals(originalPassWord)){
            map.put("valid", true);
            map.put("message", "原始密码正确！");
            System.out.println("原始密码正确！");
        }else {
            map.put("valid", false);
            map.put("message", "原始密码不正确！");
            System.out.println("原始密码不正确！");
        }
        return map;
    }

    /**
     * 修改配送员的密码
     * @param newPassWord
     * @param session
     * @return
     */
    @RequestMapping("/updateDeliverPassWord")
    @ResponseBody
    public Msg updateDeliverPassWord(@RequestParam("newPassWord") String newPassWord,HttpSession session){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        if(ObjectUtils.isEmpty(deliver)){
            return Msg.fail().add("vag", "账号缓存失效，请重新登录在操作");
        }
        deliver.setDeliverPassWord(newPassWord);
        try{
            deliverService.updateDeliver(deliver);
            session.removeAttribute("session_deliver");
            return Msg.success().add("vag", "密码修改成功，请重新登录");
        }catch (Exception e){
            return Msg.fail().add("vag", "密码修改失败");
        }
    }

    /**
     * 个人中心修改
     * @param session
     * @param deliverId
     * @param deliverName
     * @param phone
     * @return
     */
    @RequestMapping("/updateCenter")
    @ResponseBody
    public Msg updateCenter(HttpSession session, Integer deliverId, String deliverName, String phone){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        if(ObjectUtils.isEmpty(deliver)){
            return Msg.fail().add("vag", "账号缓存失效，请重新登录在操作");
        }
        deliver.setPhone(phone);
        deliverService.updateDeliver(deliver);
        try {
            deliverService.updateDeliver(deliver);
            return Msg.success().add("vag", "编辑成功");
        }catch (Exception e){
            return Msg.fail().add("vag", "编辑失败");
        }
    }


}
