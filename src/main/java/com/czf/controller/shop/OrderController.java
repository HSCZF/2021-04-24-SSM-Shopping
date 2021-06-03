package com.czf.controller.shop;

import com.czf.model.*;
import com.czf.service.*;
import com.czf.utils.Msg;
import com.czf.utils.StringUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.*;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private CartService cartService;

    @Autowired
    private ShopService shopService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private CommentService commentService;

    /**
     * 加载用户的地址
     *
     * @param session
     * @return
     */
    @ModelAttribute("shopList")
    public List<Shop> showShops(HttpSession session) {
        System.out.println("加载用户的地址。。。。");
        User user = (User) session.getAttribute("session_user");
        List<Shop> shopList = shopService.findUserAllShops(user.getId());
        return shopList;
    }

    /**
     * 结算购物车，去到订单确认、地址确认页面
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("myCartOrder")
    public String confirmOrder(HttpSession session, Model model) {
        System.out.println("购物车计算，生成订单。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            model.addAttribute("fail_vag", "请登录在操作");
        }
        // 从结算购物车中拿到session
        Double price = (Double) session.getAttribute("price");
        Integer count = (Integer) session.getAttribute("count");
        Integer[] orderCartIds = (Integer[]) session.getAttribute("orderCartIds");

        try {
            List<Cart> list = cartService.findCartByCartIdsAndCustomerId(orderCartIds, user.getId());
            model.addAttribute("orderList", list);
            model.addAttribute("price", price);
            model.addAttribute("count", count);
        } catch (Exception e) {
            model.addAttribute("error_vag", e.getMessage());
        }
        return "order";
    }

    /**
     * 创建订单，清空对应购物车的缓存
     *
     * @param shopId
     * @param status
     * @param session
     * @return
     */
    @RequestMapping("addOrder")
    @ResponseBody
    public Msg addOrder(Integer shopId, Integer status, HttpSession session) {
        System.out.println("创建订单，清空对应购物车的缓存。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        Double price = (Double) session.getAttribute("price");
        Integer count = (Integer) session.getAttribute("count");
        Integer[] orderCartIds = (Integer[]) session.getAttribute("orderCartIds");

        List<Cart> cartList = null;
        if (status == 2) {
            cartList = cartService.findStatusCartByCartIdsAndCustomerId(orderCartIds, user.getId());
        } else {
            // 状态码 1
            cartList = cartService.findCartByCartIdsAndCustomerId(orderCartIds, user.getId());
        }
        //获取该笔订单的收获信息
        Shop shop = shopService.findShopByUserIdAndShopId(user.getId(), shopId);
        //生成一个订单
        OrderVo orderVo = new OrderVo();
        Order order = new Order();
        // 拼接数据库地址信息
        String address = shop.getReceiverProvince() + shop.getReceiverCity()
                + shop.getReceiverDistrict() + shop.getAddressDetail();
        orderVo.setAddress(address);
        orderVo.setCreateDate(new Date());
        orderVo.setUser(user);
        // 工具类生成随机的按照时间的订单号
        orderVo.setOrderNumber(StringUtil.getOrderIdByUUID());

        orderVo.setPrice(price);
        orderVo.setProductNumber(count);
        // 状态码设置为0
        orderVo.setStatus(0);
        // 一次性复制
        BeanUtils.copyProperties(orderVo, order);

        // 获取订单详情
        List<OrderItem> orderItems = new ArrayList<>();
        // 遍历赋值
        for (Cart cart : cartList) {
            OrderItem orderItem = new OrderItem();
            orderItem.setNum(cart.getProductNum());
            orderItem.setPrice(cart.getTotalPrice());
            orderItem.setProduct(cart.getProduct());
            // 先插入后获取
            //orderItem.setOrder(order);
            orderItems.add(orderItem);
        }

        //将所有的订单条目加入到订单中
        orderVo.setOrderItemList(orderItems);
        String orderNo = orderService.saveOrder(orderVo);
        if (orderNo != null) {
            //将订单号放到 session 中去
            session.setAttribute("orderNo", orderNo);
            //将购物车对应的商品移除
            Boolean flag = cartService.deleteProductByCustomerIds(orderCartIds, user.getId());
            if (flag) {
                // 清除缓存
                session.removeAttribute("orderCartIds");
            } else {
                return Msg.fail().add("vag", "购物车清空失败");
            }
            return Msg.success().add("orderNo_vag", orderNo);
        }
        return Msg.fail().add("vag", "订单创建失败");
    }

    /**
     * 订单未支付跳转到订单详情页面
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("showOrderDetails")
    public String showOrderDetails(HttpSession session, Model model) {
        System.out.println("订单未支付跳转到订单详情页面。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        String orderNo = (String) session.getAttribute("orderNo");
        Order order = orderService.findOneOrderByOrderNoAndUserId(orderNo, user.getId());
        if (order != null) {
            List<OrderItem> orderItemList = orderItemService.findOrderItemsByOrderId(order.getId());
            model.addAttribute("orderItems", orderItemList);
            model.addAttribute("order", order);
        }
        return "orderDetail";
    }

    /**
     * 点击订单，查看订单详情
     *
     * @param session
     * @param orderNo
     * @param model
     * @return
     */
    @RequestMapping("toShowOrderDetails")
    public String toShowOrderDetails(HttpSession session, String orderNo, Model model) {
        System.out.println("点击订单，查看订单详情页面。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            // 用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        Order order = orderService.findOneOrderByOrderNoAndUserId(orderNo, user.getId());
        //System.out.println("toShowOrderDetails:order = " + order);
        if (order != null) {
            List<OrderItem> orderItemList = orderItemService.findOrderItemsByOrderId(order.getId());
            model.addAttribute("orderItems", orderItemList);
            model.addAttribute("order", order);
            //System.out.println("toShowOrderDetails:order = " + orderItemList);
        }
        return "orderDetail";
    }

    /**
     * 取消订单
     *
     * @param orderId
     * @param session
     * @return
     */
    @RequestMapping("cancelOrder")
    @ResponseBody
    public Msg cancelOrder(Integer orderId, HttpSession session) {
        System.out.println("取消订单。。。。");
        System.out.println("orderId = " + orderId);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        Boolean flag = orderService.updateCancelOrderStatusByUserIdAndOrderId(user.getId(), orderId);
        if (flag) {
            return Msg.success().add("vag", "订单已取消");
        }
        return Msg.fail().add("vag", "订单取消失败");
    }

    /**
     * 删除订单
     *
     * @param deleteOrderId
     * @param session
     * @return
     */
    @RequestMapping("deleteOrder")
    @ResponseBody
    public Msg deleteOrder(Integer deleteOrderId, HttpSession session) {
        System.out.println("删除订单。。。。");
        System.out.println("deleteOrderId = " + deleteOrderId);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        if (orderService.updateDeleteOrderByUserIdAndOrderId(user.getId(), deleteOrderId)) {
            return Msg.success().add("vag", "订单已删除");
        }
        return Msg.fail().add("vag", "订单删除失败");
    }

    /**
     * 确认收货
     *
     * @param confirmOrderId
     * @param session
     * @return
     */
    @RequestMapping("confirmOrder")
    @ResponseBody
    public Msg confirmOrder(Integer confirmOrderId, HttpSession session) {
        System.out.println("确认收货订单。。。。");
        System.out.println("confirmOrderId = " + confirmOrderId);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        Date date = new Date();
        Timestamp timestamp = new Timestamp(date.getTime());
        Comment comment = commentService.getOrderUserId(confirmOrderId);
        if (comment.getCommentStatus() != 8) {
            Boolean flag_date = commentService.updateFinishedByDeliverAndOrderId(comment.getDeliverId(), confirmOrderId, timestamp);
            Boolean flag = commentService.updateDeliverOrderStatusByDeliverIdAndOrderId(comment.getDeliverId(), confirmOrderId, 8);
            Boolean flag1 = orderService.updateConfirmOrderByUserIdAndOrderId(user.getId(), confirmOrderId);
            if (flag && flag1 && flag_date) {
                return Msg.success().add("vag", "确认收货，订单完成");
            }
        } else {
            Boolean flag1 = orderService.updateConfirmOrderByUserIdAndOrderId(user.getId(), confirmOrderId);
            if (flag1) {
                return Msg.success().add("vag", "确认收货，订单完成");
            }
        }

        return Msg.fail().add("vag", "确认收货失败");
    }

    /**
     * 未支付订单
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("/userOrderNotPay")
    public String userOrderNotPay(HttpSession session, Model model) {
        System.out.println("未支付订单。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 0);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet", "active");
        return "userOrders";
    }

    /**
     * 未发货的订单列表
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userOrderNotDeliver")
    public String userOrderNotDeliver(HttpSession session, Model model) {
        System.out.println("未发货的订单列表。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 1);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet1", "active");
        return "userOrders";
    }

    /**
     * 未收货的订单列表
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userOrderNotReceiver")
    public String userOrderNotReceiver(HttpSession session, Model model) {
        System.out.println("未收货的订单列表。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 2);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet2", "active");
        return "userOrders";
    }

    /**
     * 交易完成的订单
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userOrderFinished")
    public String userOrderFinished(HttpSession session, Model model) {
        System.out.println("交易完成的订单。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 3);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet3", "active");
        return "userOrders";
    }

    /**
     * 已取消的所有订单列表
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userOrderCancel")
    public String userOrderCancel(HttpSession session, Model model) {
        System.out.println("已取消的所有订单列表。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 4);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet4", "active");
        return "userOrders";
    }

    /**
     * 已删除的订单列表
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("userOrderDelete")
    public String userOrderDelete(HttpSession session, Model model) {
        System.out.println("已删除的订单列表。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return "index";  // 回到首页去
        }
        //获取所有订单列表，并返回该页面，刷新addAttribute，获取新的model值
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 5);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet5", "active");
        return "userOrders";
    }

    /**
     * 立即支付
     *
     * @param orderNumber
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("showPayNowOrders")
    public String showPayNowOrders(String orderNumber, HttpSession session, Model model) {
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            return "index";
        }
        Order order = orderService.findOneOrderByOrderNoAndUserId(orderNumber, user.getId());
        List<OrderItem> orderItemList = orderItemService.findOrderItemsByOrderId(order.getId());
        if (orderItemList != null) {
            String ProductName = orderItemList.get(0).getProduct().getName();
            //System.out.println("商品名称: " + ProductName);
            model.addAttribute("orderItem", orderItemList);
        }
        model.addAttribute("order", order);
        return "orderPay";
    }

    /**
     * 添加/更新评论
     * @param session
     * @param addCommentId
     * @param newComment
     * @return
     */
    @RequestMapping("/addComment")
    @ResponseBody
    public Msg addComment(HttpSession session, Integer addCommentId, String newComment){
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            return Msg.fail().add("vag", "请登录在操作");
        }
        Comment comment = commentService.getOrderUserId(addCommentId);
        comment.setComment(newComment);
        // 更新评论
        Boolean flag = commentService.updateComment(newComment, addCommentId);
        // 更新状态为9
        Boolean flag1 = commentService.updateDeliverOrderStatusByDeliverIdAndOrderId(comment.getDeliverId(), addCommentId, 9);
        if(flag && flag1){
            return Msg.success().add("vag", "添加成功");
        }
        return Msg.fail().add("vag", "添加或/更新失败");
    }

    /**
     * 用户所有订单列表
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("myOrders")
    public String myOrders(HttpSession session, Model model) {
        System.out.println("用户所有订单列表。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录，返回首页登录去
            return "index";
        }

        //获取所有订单列表
        List<OrderVo> orderVoList = orderService.getUserAllOrders(user.getId());
        model.addAttribute("orderVoList", orderVoList);
        return "userOrders";
    }


    /* 商品详情 在product已经实现，这里不需要在写了，以免冲突 */


    /**
     * 获取不同订单状态下的数量，显示在左边选项卡
     *
     * @param session
     * @return
     */
    @ModelAttribute("ManyOrderNumber")
    public Map<String, Object> getDifferentOrderStatusNumber(HttpSession session) {
        System.out.println("获取不同订单状态下的数量");
        User user = (User) session.getAttribute("session_user");
        //获取未支付的订单
        List<OrderVo> orderVoList = orderService.getDifferentStatusOrders(user.getId(), 0);
        //获取待发货的订单列表
        List<OrderVo> orderVoList1 = orderService.getDifferentStatusOrders(user.getId(), 1);
        //获取待收货的订单列表
        List<OrderVo> orderVoList11 = orderService.getDifferentStatusOrders(user.getId(), 2);
        //获取待评价的订单列表
        List<OrderVo> orderVoList2 = orderService.getDifferentStatusOrders(user.getId(), 3);
        //获取已取消的订单列表
        List<OrderVo> orderVoList3 = orderService.getDifferentStatusOrders(user.getId(), 4);
        //获取回收站的订单列表
        List<OrderVo> orderVoList4 = orderService.getDifferentStatusOrders(user.getId(), 5);

        Map<String, Object> map = new HashMap<>();
        map.put("notPay", orderVoList.size());
        map.put("notDeliver", orderVoList1.size());
        map.put("notReceiver", orderVoList11.size());
        map.put("finished", orderVoList2.size());
        map.put("cancelOrder", orderVoList3.size());
        map.put("deleteOrder", orderVoList4.size());
        return map;
    }
}
