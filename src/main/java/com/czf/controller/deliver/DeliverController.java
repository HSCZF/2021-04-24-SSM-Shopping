package com.czf.controller.deliver;

import com.czf.dao.OrderDao;
import com.czf.model.*;
import com.czf.service.CommentService;
import com.czf.service.DeliverService;
import com.czf.service.OrderService;
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
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/deliver")
public class DeliverController {

    @Autowired
    private DeliverService deliverService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private CommentService commentService;

    @Autowired
    private UserService userService;

    /**
     * ========================配送员模块========================
     */

    /**
     * 给配送员分页，分页插件PageHelper
     *
     * @param pn
     * @return
     */
    @RequestMapping("/deliverAll")
    @ResponseBody
    public Msg getDeliverWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        System.out.println("配送员分页");
        // 在查询之前只需要调用，传入页码，以及每页的大小PageHelper.startPage( , );
        PageHelper.startPage(pn, 5);
        // startPage后面紧跟的这个查询是一个分页查询
        List<Deliver> deliverAll = deliverService.findAllDeliver();
        // 使用PageInfo包装查询后的结果，只需要将pageInfo交给页面就行了。
        // 封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
        PageInfo page = new PageInfo(deliverAll, 5);
        System.out.println(page.toString());
        return Msg.success().add("pageInfo", page);
    }

    /**
     * 去到订单首页大厅，并显示
     * @param model
     * @return
     */
    @RequestMapping("/getAllOrdersByDeliverAndDeliverIndex")
    public String getAllOrdersByDeliverAndDeliverIndex(Integer pageNum, Model model){
        System.out.println("获取所有用户订单");
        if(ObjectUtils.isEmpty(pageNum)){
            pageNum = 1;  // 默认值为 1
        }
        List<OrderVo> orderList = orderService.getAllOrdersToDeliver();
        model.addAttribute("pageInfo", orderList);
        return "deliver/deliver_index";
    }

    /**
     * 去到订单大厅，并显示所有状态下的订单
     * @param model
     * @return
     */
    @RequestMapping("/getDeliverToDeliver")
    public String getDeliver(Model model, HttpSession session){
        System.out.println("获取所有用户订单");
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员所有订单。。。。");
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        // 先查出comment 中 接取订单的用户id
        List<OrderVo> orderVoList = orderService.getAllOrdersByDeliverIdAndStatusNoAll(deliver.getId());
        model.addAttribute("orderVoList", orderVoList);
        return "deliver/deliver_order";
    }

    /**
     * 订单大厅，显示所有状态下的配送员订单状态
     * @return
     */
    @RequestMapping("/getDeliverAllOrders")
    public String getDeliverAllOrders(){
        return null;
    }


    /**
     * 去到配送员个人中心
     * @return
     */
    @RequestMapping("/toDeliverCenter")
    public String toDeliverCenter(HttpSession session, Model model){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员个人中心" + deliver);
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        /*
        *  根据用户的订单id，还有配送员id去查询所有状态下的订单，comment表单独存放 评价 和 配送
        * */
        Deliver deliver1 = deliverService.getByDeliverId(deliver.getId());
        model.addAttribute("deliver", deliver1);
        return "/deliver/deliver_center";
    }



    /*  ============================= 状态 =========================== */
    /* 状态解释
    * 6代表：已接单待配送      用户为2：配送中
    * 7代表：已拿货开始配送    用户为2：配送中
    * 8代表：配送完成         用户为3：配送完成
    * 9代表：查看评价         用户为3：查看评价与配送完成一起实现
    * 10代表：配送完成的订单删除
    * */


    /**
     * 配送员接取订单，生成Comment新订单，并在deliver数据库表插入订单数量+1
     * @param session 缓存
     * @param userId  用户id
     * @param orderId 订单id
     * @return
     */
    @RequestMapping("/toGetOrderByDeliver")
    @ResponseBody
    public Msg toGetOrderByDeliver(HttpSession session, Integer userId , Integer orderId){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员接取订单，生成Comment新订单");
        if(ObjectUtils.isEmpty(deliver)){
            return Msg.fail().add("vag", "请登录在操作");
        }
        // 传送到 comment 表，并修改用户的订单状态 和 配送员的状态
        // 点击后，用户变更为：待收货，配送员变更为：已接单
        // 这里要一起判断，不然一个成功，一个失败，不好处理
        try{
            // 根据订单编号 和 用户id，获取用户的所有订单信息, 这里的 orderNumber 需要单独拿出来，因为前台获取不到
            Order oneOrder = orderService.getOneOrderByOrderId(orderId);
            //System.out.println(order);
            User user = userService.getByUserId(userId);
            Comment comment = new Comment();
            comment.setOrderNumber(oneOrder.getOrderNumber());
            comment.setUserId(userId);
            comment.setUserName(user.getUserName());
            comment.setUserPhone(user.getPhone());
            comment.setUserAddress(oneOrder.getAddress());
            comment.setDeliverId(deliver.getId());
            comment.setDeliverName(deliver.getDeliverName());
            comment.setOrderId(orderId);
            comment.setCommentStatus(6);  // 设置为： 待取货
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            comment.setCreateTime(timestamp);
            // 插入配送订单
            commentService.insertComment(comment);
            //订单数量 + 1
            int sum = deliver.getTotalName();
            sum = sum + 1;
            deliver.setTotalName(sum);
            // 更新数据库
            deliverService.updateDeliver(deliver);
            // 用户此时的订单状态应该修改： 2
            Boolean flag = orderService.updateOrderStatusByGetOrderIdByDeliver(userId, orderId);
            if (flag) {
                System.out.println("配送员已接取订单。。。。");
            }
        }catch (Exception e){
            e.printStackTrace();
            return Msg.fail().add("vag", "接单失败");
        }
        return Msg.success().add("vag" , "已接单");
    }

    /**
     * 配送员已接单, 取货中状态为 6
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("deliverGetOrder")
    public String deliverGetOrder(HttpSession session, Model model , Integer userId, Integer orderId){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员已接单的订单显示列表。。。。");
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        // 先查出comment 中 接取订单的用户id
        List<OrderVo> orderVoList = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 6);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet", "active");
        return "deliver/deliver_order";
    }

    /**
     * 配送员配送中, 状态设置为 7
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("deliverToReceiver")
    public String deliverToReceiver(HttpSession session, Model model , Integer userId, Integer orderId){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员配送中, 状态为7。。。。");
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        // 先查出comment 中 接取订单的用户id
        List<OrderVo> orderVoList = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 7);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet1", "active");
        return "deliver/deliver_order";
    }

    /**
     * 配送完成，状态为 8
     * @param session
     * @param model
     * @param userId
     * @param orderId
     * @return
     */
    @RequestMapping("deliverOrderFinished")
    public String deliverOrderFinished(HttpSession session, Model model , Integer userId, Integer orderId){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("配送员完成, 状态为 8 。。。。");
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        // 先查出comment 中 接取订单的用户id
        List<OrderVo> orderVoList = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 8);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet2", "active");
        return "deliver/deliver_order";
    }

    /**
     * 查看评价，状态为 9，评价
     * @param session
     * @param model
     * @param userId
     * @param orderId
     * @return
     */
    @RequestMapping("deliverOrderComment")
    public String deliverOrderComment(HttpSession session, Model model , Integer userId, Integer orderId){
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        System.out.println("查看评价，状态为 9，另起一页显示");
        if(ObjectUtils.isEmpty(deliver)){
            return "/deliver/deliver_login";
        }
        // 先查出comment 中 接取订单的用户id
        List<OrderVo> orderVoList = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 9);
        model.addAttribute("orderVoList", orderVoList);
        model.addAttribute("activeSet3", "active");
        return "deliver/deliver_order";
    }

    /**
     * 查询所有配送员订单的记录数
     * @param session
     * @return
     */
    @ModelAttribute("ManyDeliverOrderNumber")
    public Map<String,Object> getDifferentDeliverOrderStatusNumber(HttpSession session){
        System.out.println("配送员，获取不同订单状态下的数量");
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        //获取已接单未配送的订单
        List<OrderVo> comments= orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 6);
        //获取配送中的订单列表
        List<OrderVo> comments1 = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 7);
        //获取配送完成的订单列表
        List<OrderVo> comments2 = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 8);
        //获取已评价的订单列表
        List<OrderVo> comments3 = orderService.getDeliverOrdersByDeliverIdAndStatus(deliver.getId(), 9);

        Map<String,Object> map = new HashMap<>();
        map.put("notToStart",comments.size());
        map.put("inDelivery",comments1.size());
        map.put("deliverFinished",comments2.size());
        map.put("commentItem",comments3.size());
        return map;
    }



    /*
    * ======================================== 配送订单按钮控制层实现内容 ==================================================
    * */



    /**
     * 确认已取货前往配送, 取货过程用户状态无需变更，配送员状态从 6 变到 7
     * @param session
     * @param pickUpOrderId
     * @return
     */
    @RequestMapping("/confirmPickUpToDeliver")
    @ResponseBody
    public Msg confirmPickUpToDelivery(HttpSession session, Integer pickUpOrderId){
        System.out.println("确认已取货前往配送。。。。");
        System.out.println("pickUpOrderId = " + pickUpOrderId);
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        if (ObjectUtils.isEmpty(deliver)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        // 配送员更新与用户不同的是，先从comments订单中获取用户的订单id
        Boolean flag = commentService.updateDeliverOrderStatusByDeliverIdAndOrderId(deliver.getId(), pickUpOrderId, 7);
        if(flag){
            return Msg.success().add("vag", "已取货，前往配送");
        }
        return Msg.fail().add("vag", "点击取货前往配送确认失败");
    }

    /**
     * 确认已送达 配送员状态从 7 变到 8
     * @param session
     * @param finishedOrderId
     * @return
     */
    @RequestMapping("/confirmToDeliverFinished")
    @ResponseBody
    public Msg confirmToDeliverFinished(HttpSession session, Integer finishedOrderId){
        System.out.println("确认已送达。。。。");
        System.out.println("finishedOrderId = " + finishedOrderId);
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        if (ObjectUtils.isEmpty(deliver)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        try {
            // 更新送达时间
            Date date = new Date();
            Timestamp timestamp = new Timestamp(date.getTime());
            Boolean flag_date = commentService.updateFinishedByDeliverAndOrderId(deliver.getId(), finishedOrderId, timestamp);
            Boolean flag = commentService.updateDeliverOrderStatusByDeliverIdAndOrderId(deliver.getId(), finishedOrderId, 8);
            if(flag && flag_date){
                return Msg.success().add("vag", "已确认配送完成");
            }
        }catch (Exception e){
            e.printStackTrace();
            return Msg.fail().add("vag", "点击确认已送达失败");
        }
        return Msg.fail().add("vag", "点击确认已送达失败");
    }

    /* 状态 9 是用户评价了才有  */

    /**
     * 删除订单，状态修改为 10
     * @param session
     * @param deleteOrderId
     * @return
     */
    @RequestMapping("/confirmToDeliverDelete")
    @ResponseBody
    public Msg confirmToDeliverDelete(HttpSession session, Integer deleteOrderId){
        System.out.println("确认已送达。。。。");
        System.out.println("deleteOrderId = " + deleteOrderId);
        Deliver deliver = (Deliver) session.getAttribute("session_deliver");
        if (ObjectUtils.isEmpty(deliver)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        // 配送员更新与用户不同的是，先从comments订单中获取用户的订单id
        Boolean flag = commentService.updateDeliverOrderStatusByDeliverIdAndOrderId(deliver.getId(), deleteOrderId, 10);
        if(flag){
            return Msg.success().add("vag", "该订单已删除");
        }
        return Msg.fail().add("vag", "订单删除失败");
    }


    /**
     * *=========================管理员操作========================
     */



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
     * 配送员更新
     *
     * @return
     */
    @RequestMapping(value = "/delivers/{id}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateDeliverId(Deliver deliver) {
        System.out.println("updateDeliverId...");
        System.out.println("更新->" + deliver);
        deliverService.updateDeliver(deliver);
        return Msg.success();
    }

    /**
     * 验证配送员是否存在
     * @param deliverName
     * @return
     */
    @RequestMapping("/checkRepeatDeliver")
    @ResponseBody
    public Msg checkRepeatDeliver(@RequestParam("deliverName") String deliverName){
        System.out.println("checkRepeatDeliver。。。");
        System.out.println("存在1，不存在0 = " + deliverService.findByDeliverName(deliverName));
        if(deliverService.findByDeliverName(deliverName) == 1){
            return Msg.fail().add("va_msg", "配送员已存在");
        }
        return Msg.success().add("va_msg","配送员名可用");
    }



}
