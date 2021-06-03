package com.czf.service;

import com.czf.model.Order;
import com.czf.model.OrderVo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderService {

    /**
     * 插入订单
     * @param orderVo
     * @return
     */
    public String saveOrder(OrderVo orderVo);

    /**
     * 根据用户的id 和 订单的编号 查询一个订单
     * @param orderNo
     * @param id
     * @return
     */
    public Order findOneOrderByOrderNoAndUserId(String orderNo, Integer id);

    /**
     * 支付宝同步通知 沙盒支付成功，修改订单状态
     * @param id
     * @param out_trade_no
     * @return
     */
    Boolean updateOrderStatusByUserId(Integer id, String out_trade_no);

    /**
     * 支付宝异步通知，修改订单状态，异步通知session失效
     * @param out_trade_no
     * @return
     */
    Boolean updateOrderStatusByOrderNo(String out_trade_no);

    /**
     * 获取用户id的所有订单列表
     * @param id
     * @return
     */
    List<OrderVo> getUserAllOrders(Integer id);

    /**
     * 这里查order,根据配送员id 和 status!=5 所有的订单
     * @param deliverId
     * @return
     */
    List<OrderVo> getAllOrdersByDeliverIdAndStatusNoAll(Integer deliverId);

    /**
     * 这里查order,根据配送员id 和 订单状态查询订单
     * @param deliverId
     * @param status
     * @return
     */
    List<OrderVo> getDeliverOrdersByDeliverIdAndStatus(Integer deliverId, Integer status);


    /**
     * 根据 订单id 获取订单信息
     * @param orderId
     * @return
     */
    Order getOneOrderByOrderId(@Param("orderId") Integer orderId);


    /*  ======   配送员/管理员 ============== */



    /**
     * 管理员/配送员：获取所有用户订单 配送员订单分页用下面那个接口
     * @return
     */
    List<Order> getUserAllOrdersByAdminOrDeliver();

    /**
     * 配送员：获取所有用户订单
     * @return
     */
    List<OrderVo> getAllOrdersToDeliver();

    /**
     * 配送员接取订单：同时修改用户的订单状态, 根据订单id修改，状态修改为 2
     * @param userId
     * @param getOrderId
     * @return
     */
    Boolean updateOrderStatusByGetOrderIdByDeliver(Integer userId , Integer getOrderId);



    /**
     * 管理员根据订单id、用户id 查找所有配送订单，无输入值
     * @return
     */
    List<Order> getUserAllOrdersByAdminAndOrderIdAndUserId();

    /**
     * 模糊查询
     * @param order
     * @return
     */
    List<Order> findOrdersByParams(Order order);




    /* ========== 用户 =====================*/




    /**
     * 取消订单
     * @param userId
     * @param orderId
     * @return
     */
    Boolean updateCancelOrderStatusByUserIdAndOrderId(Integer userId, Integer orderId);

    /**
     * 删除订单
     * @param userId
     * @param deleteOrderId
     * @return
     */
    Boolean updateDeleteOrderByUserIdAndOrderId(Integer userId, Integer deleteOrderId);

    /**
     * 确认收货
     * @param userId
     * @param confirmOrderId
     * @return
     */
    Boolean updateConfirmOrderByUserIdAndOrderId(Integer userId, Integer confirmOrderId);

    /**
     * 获取订单不同状态下的所有订单详情
     * @param userId
     * @param status
     * @return
     */
    List<OrderVo> getDifferentStatusOrders(Integer userId,Integer status);

    /**
     * 获取用户下的所有订单
     * @param userId
     * @return
     */
    List<Order> getAllOrderByUserId(Integer userId);

    /**
     * 获取用户的所有订单及用户信息
     * @param userId
     * @return
     */
    List<Order> getUserAllOrdersAndUserByUserId(@Param("userId") Integer userId);

    /**
     * 多表联合查询
     * @return
     */
    List<Order> selectOrderList();


    /**
     * 更新地址
     * @param orderId
     * @param address
     * @return
     */
    public Boolean updateOrderByAdmin(@Param("orderId") Integer orderId,
                                  @Param("address") String address);

    /**
     * 管理员获取一个订单
     * @param orderId
     * @return
     */
    Order getOneOrderByAdminAndOrderId(@Param("orderId") Integer orderId);

}
