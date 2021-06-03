package com.czf.test;

import com.czf.dao.OrderDao;
import com.czf.dao.OrderItemDao;
import com.czf.model.*;
import com.czf.service.CommentService;
import com.czf.service.DeliverService;
import com.czf.service.OrderService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class deliverTest {

    @Autowired
    private DeliverService deliverService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private CommentService commentService;

    /**
     * 测试更新密码
     */
    @Test
    public void update(){
        Deliver deliver = deliverService.getByDeliverId(16);
        deliver.setDeliverPassWord("123");
        try {
            deliverService.updateDeliver(deliver);
        }catch (Exception e){
            e.printStackTrace();
        }
        System.out.println(deliver);
    }

    /**
     * 测试不同状态下的配送员的订单
     */
    @Test
    public void getDeliverOrdersByDeliverIdAndStatus(){
       // List<OrderVo> orderVoList = orderService.getDeliverOrdersByDeliverIdAndStatus(3, 2);
        List<OrderVo> orderVoList = orderService.getAllOrdersByDeliverIdAndStatusNoAll(3);  // 所有状态
        System.out.println(orderVoList.size());
        System.out.println(orderVoList.toString());
        for (OrderVo orderVo : orderVoList) {
            //System.out.println(orderVo);
        }
    }

    /**
     * 根据配送员id 和 订单状态不是 5 的订单
     */
    @Test
    public void getAllCommentsByDeliverIdAndStatusNoAll(){
        List<OrderVo> orderVoList = orderService.getAllOrdersByDeliverIdAndStatusNoAll(3);
        List<OrderVo> orderVoList1 = orderService.getUserAllOrders(106);
        for (OrderVo vo : orderVoList) {
           // System.out.println(vo.getComment().getCStatus());
        }
        for (OrderVo vo : orderVoList1) {
           System.out.println(vo.getComment().getCommentStatus());
        }
    }

    /**
     * 查找所有配送员
     */
    @Test
    public void findAllDeliver() {
        System.out.println("Test：查找所有配送员");
        List<Deliver> delivers = deliverService.findAllDeliver();
        for (Deliver deliver : delivers) {
           // System.out.println(deliver);
        }
    }

    /**
     * 添加配送员
     */
    @Test
    public void insertDeliver() {
        System.out.println("Test：添加配送员");
        String[] str = {"李四1", "15778449940", "123", "男", "配送员"};
        Date date = new Date();
        Timestamp timestamp = new Timestamp(date.getTime());
        Timestamp addTime = timestamp;
        Timestamp updateTime = timestamp;
        //String deliverName, String phone, String deliverPassWord, String sex, Integer totalName, Integer status, String role, Data addTime, Timestamp updateTime
        Deliver deliver = new Deliver(str[0], str[1], str[2], str[3], 0, 0, str[4], addTime, updateTime);
        deliverService.insertDeliver(deliver);
        System.out.println(deliver);
    }

    @Test
    public  void t2(){
       // PageHelper.startPage(1,5);
        List<OrderVo> orderList = orderService.getAllOrdersToDeliver();
        //PageInfo<OrderVo> pageInfo = new PageInfo<>(orderList);
       // System.out.println(orderList.toString());
        for (OrderVo orderVo : orderList) {
            System.out.println(orderVo.getId());
            for (OrderItem item : orderVo.getOrderItemList()) {
                System.out.println("          "  +  item.getProduct().getPrice());
            }
        }
    }

    /**
     * 查询所有配送员订单的记录数
     */
    @Test
    public void getDifferentDeliverOrderStatusNumber(){
        try{
            List<OrderVo> comments= orderService.getDeliverOrdersByDeliverIdAndStatus(3, 6);
            //获取配送中的订单列表
            List<OrderVo> comments1 = orderService.getDeliverOrdersByDeliverIdAndStatus(3, 7);
            //获取配送完成的订单列表
            List<OrderVo> comments2 = orderService.getDeliverOrdersByDeliverIdAndStatus(3, 8);
            //获取已评价的订单列表
            List<OrderVo> comments3 = orderService.getDeliverOrdersByDeliverIdAndStatus(3, 9);
            System.out.println(comments.size());
            System.out.println(comments1.size());
            System.out.println(comments2.size());
            System.out.println(comments3.size());
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    /**
     * 根据订单id获取用户的id
     */
    @Test
    public void getOrderUserId(){
        try {
            String orderNumber = "202104151315727819";
            int userId = 106;
            Order order = orderService.findOneOrderByOrderNoAndUserId(orderNumber , userId);
            Comment comment = new Comment();
            comment.setOrderNumber(orderNumber);
            comment.setUserId(userId);
            comment.setUserName(order.getUser().getUserName());
            comment.setUserPhone(order.getUser().getPhone());
            comment.setUserAddress(order.getAddress());
            comment.setDeliverId(3);
            comment.setDeliverName("配送员1");
            comment.setOrderId(158);
            comment.setCommentStatus(6);  // 设置为： 待取货
            comment.setCreateTime(new Date());
            System.out.println(comment);
            // 插入配送订单
           // commentService.insertComment(comment);

        }catch (Exception e){
            e.printStackTrace();
        }

    }

}
