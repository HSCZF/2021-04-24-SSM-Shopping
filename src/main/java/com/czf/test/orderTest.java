package com.czf.test;

import com.czf.dao.OrderDao;
import com.czf.dao.OrderItemDao;
import com.czf.model.*;
import com.czf.service.CommentService;
import com.czf.service.OrderItemService;
import com.czf.service.OrderService;
import com.czf.service.ShopService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})

public class orderTest {

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private ShopService shopService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private OrderItemDao orderItemDao;

    @Autowired
    private OrderDao orderDao;

    @Test
    public void testOrder() {

     /*   List<Order> orders = orderService.getUserAllOrdersByAdminAndOrderIdAndUserId();
        for (Order order : orders) {
        }

        List<Comment> comments= commentService.getAllComments();
        for (Comment comment : comments) {
            System.out.println(comment);
        }*/
       Order order = orderService.findOneOrderByOrderNoAndUserId("202104241231821918", 106);
        //System.out.println(order);
        List<OrderItem> orderItems = orderItemService.findOrderItemsByOrderId(order.getId());
        for (OrderItem item : orderItems) {
            System.out.println("item="+item.getNum());
        }

    }

    @Test
    public void test2(){
       /* List<OrderVo> orderList = orderService.getAllOrdersToDeliver();
        System.out.println("大小:"+orderList.size());
        System.out.println(orderList);
        for (OrderVo vo : orderList) {
            System.out.println(vo);
        }*/

        //List<Order> orders1 = orderDao.getAllOrdersToDeliver();
        List<Comment> comments = commentService.getAllCommentsByDeliverIdAndStatusNoAll(3);
        for (Comment comment : comments) {
            System.out.println(comment);
            List<OrderItem> orderItemList = orderItemDao.findOrderItemsByOrderId(comment.getOrderId());
            for (OrderItem item : orderItemList) {
                System.out.println("item="+item.getProduct());
                System.out.println("item222="+item.getOrder());
            }
            Order order = orderDao.getOneOrderByOrderId(comment.getOrderId());
        }



       /* List<OrderVo> orderVos1 = new ArrayList<>();
        for (Order order : orders1) {
            OrderVo orderVo = new OrderVo();
            // 根据 订单id 去找 订单信息
            List<OrderItem> orderItems1 = orderItemDao.findOrderItemsByOrderId(order.getId());
            for (OrderItem orderItem : orderItems1) {
                orderItem.setAddress("="+order.getAddress());  // 这里不知道对不对
            }
            // 重复前面的写法，复制实体类
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItems1);
            orderVos1.add(orderVo);
        }*/

    }




}
