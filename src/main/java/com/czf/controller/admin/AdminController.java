package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.service.AdminService;
import com.czf.service.UserService;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * 管理员逻辑处理页面
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    /**
     * 自动注入
     */
    @Autowired
    private AdminService adminService;

    /**
     * ========================管理员模块========================
     */

    /**
     * 给管理员分页，分页插件PageHelper，功能已取消
     *
     * @param pn
     * @return
     */
    @RequestMapping("/empAll")
    @ResponseBody
    public Msg getAdminWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        // 在查询之前只需要调用，传入页码，以及每页的大小PageHelper.startPage( , );
        PageHelper.startPage(pn, 5);
        // startPage后面紧跟的这个查询是一个分页查询
        List<Admin> empAll = adminService.findAll();
        // 使用PageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        // 封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(empAll, 5);
        return Msg.success().add("pageInfo", page);
    }

    /**
     * 根据id获取管理员信息，功能已取消，为了安全性
     *
     * @param single_id
     * @return
     */
    @RequestMapping(value = "/admins/{single_id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getByAdminId(@PathVariable("single_id") Integer single_id) {
        System.out.println("进入到  admin/admins/" + single_id + "........");
        Admin admin = adminService.getByAdminId(single_id);
        System.out.println(admin);
        return Msg.success().add("admin", admin);
    }

    /**
     * 管理员更新，功能已取消，为了安全性
     *
     * @return
     */
    @RequestMapping(value = "/admins/{id}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateAdminId(Admin admin) {
        System.out.println("updateAdminId...");
        System.out.println("更新->" + admin);
        adminService.updateAdmin(admin);
        return Msg.success();
    }

    /**
     * 删除单个或者多个管理员，功能已取消，为了安全性
     * @return
     */
    @RequestMapping(value = "/admins/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteAdminById(@PathVariable("ids") String ids){
        System.out.println("/admin/admins/{ids}....");
        // 匹配"-"为多删除操作
        if(ids.contains("-")){
            System.out.println("进入 删除多个管理员");
            String[] str_ids = ids.split("-"); //切割id
            Integer[] del_ids = new Integer[str_ids.length+2];
            int i = 0;
            for (String str_id : str_ids) {
                del_ids[i++] = Integer.parseInt(str_id); // 字符串强转整型
            }
            adminService.deleteByManyAdminId(del_ids);
        }else {
            // 未匹配到"-"为单操作
            System.out.println("进入 删除单个管理员");
            Integer id = Integer.parseInt(ids);
            adminService.deleteByAdminId(id);
        }
        return Msg.success();
    }

}
