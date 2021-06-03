package com.czf.service.impl;

import com.czf.dao.OrderDao;
import com.czf.dao.OrderItemDao;
import com.czf.model.Comment;
import com.czf.model.Order;
import com.czf.model.OrderItem;
import com.czf.model.OrderVo;
import com.czf.service.CommentService;
import com.czf.service.OrderService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private OrderItemDao orderItemDao;

    @Autowired
    private CommentService commentService;

    /**
     * 插入订单
     *
     * @param orderVo
     * @return
     */
    @Override
    public String saveOrder(OrderVo orderVo) {
        Order order = new Order();
        BeanUtils.copyProperties(orderVo, order);
        int rows = orderDao.insertOrder(order);
        // 插入数据库
        List<OrderItem> orderItems = orderVo.getOrderItemList();
        List<OrderItem> newOrderItems = new ArrayList<>();

        if (rows >= 1) {
            for (OrderItem orderItem : orderItems) {
                orderItem.setOrder(order);
                newOrderItems.add(orderItem);
            }
        }
        // 插入订单
        int sum = orderItemDao.insertOrderItemByOrderItems(newOrderItems);
        if (sum >= 1) {
            return order.getOrderNumber();
        }
        return null;
    }

    /**
     * 根据用户的id 和 订单的编号 查询一个订单
     *
     * @param orderNo
     * @param id
     * @return
     */
    @Override
    public Order findOneOrderByOrderNoAndUserId(String orderNo, Integer id) {
        Order order = orderDao.findOneOrderByOrderNoAndUserId(orderNo, id);
        if (ObjectUtils.isEmpty(order)) {
            return null;
        }
        return order;
    }

    /**
     * 沙盒支付成功，修改订单状态
     *
     * @param id
     * @param out_trade_no
     * @return
     */
    @Override
    public Boolean updateOrderStatusByUserId(Integer id, String out_trade_no) {
        int sum = orderDao.updateOrderStatusByUserId(id, out_trade_no, 1);
        if (sum >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 支付宝异步通知，修改订单状态，异步通知session失效
     *
     * @param out_trade_no
     * @return
     */
    @Override
    public Boolean updateOrderStatusByOrderNo(String out_trade_no) {
        int sum = orderDao.updateOrderStatusByOrderNo(out_trade_no, 1);
        if (sum >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 获取用户的所有订单列表
     *
     * @param id
     * @return
     */
    @Override
    public List<OrderVo> getUserAllOrders(Integer id) {

        List<Order> orders = orderDao.getUserAllOrdersByUserId(id);
        List<OrderVo> orderVos = new ArrayList<>();
        for (Order order : orders) {
            OrderVo orderVo = new OrderVo();
            List<OrderItem> orderItems = orderItemDao.findOrderItemsByOrderId(order.getId());

            // 重复前面的写法，复制实体类
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItems);
            orderVos.add(orderVo);
        }
        return orderVos;
    }

    /**
     * 这里查order,根据配送员id 和 status!=5 所有的订单
     * @param deliverId
     * @return
     */
    @Override
    public List<OrderVo> getAllOrdersByDeliverIdAndStatusNoAll(Integer deliverId) {
        // 不同状态，意味着 配送员id 和 状态来确定，订单可能不止一单，集合存起来，也要存起来
        List<Comment> comments = commentService.getAllCommentsByDeliverIdAndStatusNoAll(deliverId);  //
        List<OrderVo> orderVoList = new ArrayList<>();
        for (Comment comment : comments) {
            OrderVo orderVo = new OrderVo();
            List<OrderItem> orderItemList = orderItemDao.findOrderItemsByOrderId(comment.getOrderId());
            // 通过订单id查询订单
            Order order = orderDao.getOneOrderByOrderId(comment.getOrderId());
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItemList);
            orderVoList.add(orderVo);
        }
        return orderVoList;
    }

    /**
     * 这里查order,根据配送员id 和 订单状态查询订单(不同状态下的订单)
     * @param deliverId
     * @param status
     * @return
     */
    @Override
    public List<OrderVo> getDeliverOrdersByDeliverIdAndStatus(Integer deliverId, Integer status) {
        // 不同状态，意味着 配送员id 和 状态来确定，订单可能不止一单，集合存起来
        List<Comment> comments = commentService.getAllCommentsByDeliverIdAndStatus(deliverId, status);
        List<OrderVo> orderVoList = new ArrayList<>();
        for (Comment comment : comments) {
            OrderVo orderVo = new OrderVo();
            List<OrderItem> orderItemList = orderItemDao.findOrderItemsByOrderId(comment.getOrderId());
            // 通过订单id查询订单
            Order order = orderDao.getOneOrderByOrderId(comment.getOrderId());
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItemList);
            orderVoList.add(orderVo);
        }
        return orderVoList;
    }

    @Override
    public Order getOneOrderByOrderId(Integer orderId) {
        return orderDao.getOneOrderByOrderId(orderId);
    }

    /**
     *管理员：获取所有用户订单
     * @return
     */
    @Override
    public List<Order> getUserAllOrdersByAdminOrDeliver() {
        return orderDao.getUserAllOrdersByAdminOrDeliver();
    }

    /**
     * 配送员：获取所有用户订单
     * @return
     */
    @Override
    public List<OrderVo> getAllOrdersToDeliver() {
        List<Order> orders1 = orderDao.getAllOrdersToDeliver();
        List<OrderVo> orderVos1 = new ArrayList<>();
        for (Order order : orders1) {
            OrderVo orderVo = new OrderVo();
            // 根据 订单id 去找 订单信息
            List<OrderItem> orderItems1 = orderItemDao.findOrderItemsByOrderId(order.getId());
            for (OrderItem orderItem : orderItems1) {
                orderItem.setAddress(order.getAddress());  // 这里不知道对不对
            }
            // 重复前面的写法，复制实体类
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItems1);
            orderVos1.add(orderVo);
        }
        return orderVos1;
    }

    /**
     * 配送员接取订单：同时修改用户的订单状态, 根据订单id修改，状态修改为 2
     * @param userId
     * @param getOrderId
     * @return
     */
    @Override
    public Boolean updateOrderStatusByGetOrderIdByDeliver(Integer userId, Integer getOrderId) {
        int sum = orderDao.updateUserOrderStatusByUserIdAndOrderId(userId, getOrderId, 2);
        if( sum >= 1){
            return true;
        }
        return false;
    }


    /**
     * 管理员根据订单id、用户id 查找所有配送订单，无输入值
     * @return
     */
    @Override
    public List<Order> getUserAllOrdersByAdminAndOrderIdAndUserId() {
        return orderDao.getUserAllOrdersByAdminAndOrderIdAndUserId();
    }

    @Override
    public List<Order> findOrdersByParams(Order order) {
        return orderDao.findOrdersByParams(order);
    }

    /**
     * 取消订单
     * @param userId
     * @param orderId
     * @return
     */
    @Override
    public Boolean updateCancelOrderStatusByUserIdAndOrderId(Integer userId, Integer orderId) {
        int sum = orderDao.updateUserOrderStatusByUserIdAndOrderId(userId, orderId, 4);
        if( sum >= 1){
            return true;
        }
        return false;
    }

    /**
     * 删除订单
     * @param userId
     * @param deleteOrderId
     * @return
     */
    @Override
    public Boolean updateDeleteOrderByUserIdAndOrderId(Integer userId, Integer deleteOrderId) {
        int sum = orderDao.updateUserOrderStatusByUserIdAndOrderId(userId, deleteOrderId, 5);
        if(sum >= 1){
            return true;
        }
        return false;
    }

    /**
     * 确认收货
     * @param userId
     * @param confirmOrderId
     * @return
     */
    @Override
    public Boolean updateConfirmOrderByUserIdAndOrderId(Integer userId, Integer confirmOrderId) {
        int sum = orderDao.updateUserOrderStatusByUserIdAndOrderId(userId, confirmOrderId, 3);
        if( sum >= 1){
            return true;
        }
        return false;
    }

    /**
     * 获取订单不同状态下的所有订单详情
     * @param userId
     * @param status
     * @return
     */
    @Override
    public List<OrderVo> getDifferentStatusOrders(Integer userId, Integer status) {
        // 先获取用户状态码的所有订单
        // 在遍历出来存
        List<Order> orderList = orderDao.getUserOrdersByUserId(userId, status);
        List<OrderVo> orderVoList = new ArrayList<>();
        for (Order order : orderList) {
            OrderVo orderVo = new OrderVo();
            Integer orderId = order.getId();
            List<OrderItem> orderItemList = orderItemDao.findOrderItemsByOrderId(orderId);
            BeanUtils.copyProperties(order, orderVo);
            orderVo.setOrderItemList(orderItemList);
            // 开始存
            orderVoList.add(orderVo);
        }
        return orderVoList;
    }

    /**
     * 获取用户下的所有订单
     * @param userId
     * @return
     */
    @Override
    public List<Order> getAllOrderByUserId(Integer userId) {
        return orderDao.getUserAllOrdersByUserId(userId);
    }

    /**
     * 获取用户的所有订单及用户信息
     * @param userId
     * @return
     */
    @Override
    public List<Order> getUserAllOrdersAndUserByUserId(Integer userId) {
        return orderDao.getUserAllOrdersAndUserByUserId(userId);
    }

    @Override
    public List<Order> selectOrderList() {
        return orderDao.selectOrderList();
    }

    /**
     * 更新地址
     * @param orderId
     * @param address
     * @return
     */
    @Override
    public Boolean updateOrderByAdmin(Integer orderId, String address) {
        int sum = orderDao.updateOrderByAdmin(orderId, address);
        if(sum >= 1){
            return true;
        }
        return false;
    }

    @Override
    public Order getOneOrderByAdminAndOrderId(Integer orderId) {
        return orderDao.getOneOrderByAdminAndOrderId(orderId);
    }


}
