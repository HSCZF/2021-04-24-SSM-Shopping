package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.model.Deliver;
import com.czf.model.User;
import com.czf.service.DeliverService;
import com.czf.service.UserService;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 负责页面跳转
 */
@Controller
@RequestMapping("/admin")
public class AdminDeliverController {


    @Autowired
    private DeliverService deliverService;

    /**
     * 管理员分页所有配送员
     *
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllDeliver")
    public String getAllDeliver(Integer pageNum, Model model, HttpSession session) {
        System.out.println("管理员：配送员分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if (ObjectUtils.isEmpty(admin)) {
            // 传回来为空，则设为 1
            return "system/login";
        }
        if (ObjectUtils.isEmpty(pageNum)) {
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        PageHelper.startPage(pageNum, 5);
        List<Deliver> deliverList = deliverService.findAllDeliver();
        PageInfo<Deliver> pageInfo = new PageInfo<>(deliverList);
        model.addAttribute("pageInfo", pageInfo);

        return "/system/delivers";
    }

    /**
     * 管理员管理员 多条件模糊查询（已实现）
     *
     * @param deliver
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getParamsByDeliverInput")
    public String getParamsByDeliverInput(Deliver deliver, Integer pageNum, Model model) {
        System.out.println("配送员模糊搜索");
        if (ObjectUtils.isEmpty(pageNum)) {
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        System.out.println("pageNum = " + pageNum);
        PageHelper.startPage(pageNum, 5);
        List<Deliver> deliverList = deliverService.findDeliversByParams(deliver);
        PageInfo<Deliver> pageInfo = new PageInfo<>(deliverList);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("params", deliver);
        return "/system/delivers";
    }

    /**
     * 根据id获取配送员信息
     *
     * @param single_id
     * @return
     */
    @RequestMapping(value = "/delivers/{single_id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getByDeliverId(@PathVariable("single_id") Integer single_id) {
        System.out.println("进入到  admin/delivers/" + single_id + "........");
        Deliver deliver = deliverService.getByDeliverId(single_id);
        System.out.println(deliver);
        return Msg.success().add("deliver", deliver);
    }

    /**
     * 管理员更新配送员
     *
     * @param phone
     * @return
     */
    @RequestMapping("/updateDeliverByAdmin")
    @ResponseBody
    public Msg updateDeliverByAdmin(Integer id, String phone) {
        System.out.println("前台传回来的phone=" + phone);
        Deliver deliver = deliverService.getByDeliverId(id);
        deliver.setPhone(phone);
        System.out.println("更新->" + deliver);
        deliverService.updateDeliver(deliver);
        return Msg.success();
    }

    /**
     * 删除单个或者多个配送员
     * @return
     */
    @RequestMapping(value = "/delivers/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteDeliverById(@PathVariable("ids") String ids){
        System.out.println("/admin/delivers/{ids}....");
        // 匹配"-"为多删除操作
        if(ids.contains("-")){
            System.out.println("进入 删除多个配送员");
            String[] str_ids = ids.split("-"); //切割id
            Integer[] del_ids = new Integer[str_ids.length+2];
            int i = 0;
            for (String str_id : str_ids) {
                del_ids[i++] = Integer.parseInt(str_id); // 字符串强转整型
            }
            deliverService.deleteByManyDeliverId(del_ids);
        }else {
            // 未匹配到"-"为单操作
            System.out.println("进入 删除单个配送员");
            Integer id = Integer.parseInt(ids);
            deliverService.deleteByDeliverId(id);
        }
        return Msg.success();
    }




}
