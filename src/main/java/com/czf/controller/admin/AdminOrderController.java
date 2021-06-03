package com.czf.controller.admin;

import com.czf.model.*;
import com.czf.service.*;
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
import java.util.logging.Logger;

@Controller
@RequestMapping("/admin/order")
public class AdminOrderController {

    @Autowired
    private ProductTypeService productTypeService;

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private CommentService commentService;


    /**
     * 管理员分页所有订单
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllOrders")
    public String getAllProducts(Integer pageNum, Model model, HttpSession session){
        System.out.println("管理员：订单分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if(ObjectUtils.isEmpty(admin)){
            // 传回来为空，则设为 1
            return "/system/login";
        }
        if(ObjectUtils.isEmpty(pageNum)){
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        PageHelper.startPage(pageNum,5);
        List<Order> orderList = orderService.getUserAllOrdersByAdminOrDeliver();
        PageInfo<Order> pageInfo = new PageInfo<>(orderList);
        model.addAttribute("pageInfo", pageInfo);
        return "/system/orders";
    }

    /**
     * 模糊查询
     * @param order
     * @param pageNum
     * @param model
     * @param session
     * @return
     */
    @RequestMapping("getParamsByOrderInput")
    public String getParamsByOrderInput(Order order, Integer pageNum, Model model, HttpSession session){
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
        System.out.println(order);
        PageHelper.startPage(pageNum,5);
        List<Order> orderList = orderService.findOrdersByParams(order);
        System.out.println("输出下啊");
        for (Order order1 : orderList) {
            System.out.println(order1);
        }
        PageInfo<Order> pageInfo = new PageInfo<>(orderList);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("params", order);
        return "/system/orders";
    }

    /**
     * 获取修改的内容
     * @param id
     * @return
     */
    @RequestMapping("/getOneOrderById")
    @ResponseBody
    public Msg getOneOrderById(Integer id){
        Order order = orderService.getOneOrderByAdminAndOrderId(id);
        return Msg.success().add("order", order);

    }

    /**
     * 更新地址
     * @param id
     * @param address
     * @return
     */
    @RequestMapping("/updateOrderByAdmin")
    @ResponseBody
    public Msg updateOrderByAdmin(Integer id, String address){
        try {
            Boolean flag = orderService.updateOrderByAdmin(id, address);
            // 修改订单地址的同时，如果接单了，那么配送订单地址也要更新
            Comment comment = commentService.getOrderUserId(id);
            if(comment != null){
                comment.setUserAddress(address);
                commentService.updateAddress(address, comment.getId());
            }
            if(flag){
                return Msg.success();
            }else {
                return Msg.fail();
            }
        }catch (Exception e){
            e.printStackTrace();
            return Msg.fail();
        }

    }


}
