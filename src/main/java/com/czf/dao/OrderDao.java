package com.czf.dao;

import com.czf.model.Order;
import org.apache.ibatis.annotations.Param;
import org.aspectj.weaver.ast.Or;

import java.util.List;

public interface OrderDao {

    /**
     * 插入订单
     * @param order
     * @return
     */
    public int insertOrder(Order order);

    /**
     * 根据用户的id 和 订单的编号 查询一个订单
     * @param orderNo
     * @param id
     * @return
     */
    public Order findOneOrderByOrderNoAndUserId(@Param("orderNo") String orderNo, @Param("userId") Integer id);

    /**
     * 支付宝同步通知，支付宝支付完成
     * @param id
     * @param out_trade_no
     * @param status
     * @return
     */
    public int updateOrderStatusByUserId(@Param("userId") Integer id,
                                                @Param("orderNumber") String out_trade_no,
                                                @Param("status") Integer status);

    /**
     * 支付宝异步通知，修改订单状态，异步通知session失效
     * @param out_trade_no
     * @param status
     * @return
     */
    public int updateOrderStatusByOrderNo(@Param("orderNumber") String out_trade_no,
                                   @Param("status") Integer status);

    /**
     * 获取用户id下的所有的订单
     * @param id
     * @return
     */
    List<Order> getUserAllOrdersByUserId(@Param("userId") Integer id);



    /**
     * 根据 订单id 获取订单信息
     * @param orderId
     * @return
     */
    Order getOneOrderByOrderId(@Param("orderId") Integer orderId);

    /**
     * 管理员/配送员：获取所有用户订单
     * @return
     */
    List<Order> getUserAllOrdersByAdminOrDeliver();

    /**
     * 管理员获取一个订单
     * @param orderId
     * @return
     */
    Order getOneOrderByAdminAndOrderId(@Param("orderId") Integer orderId);

    /**
     * 配送员：获取所有用户订单
     * @return
     */
    List<Order> getAllOrdersToDeliver();


    /**
     * 多表查询
     * @return
     */
    List<Order> selectOrderList();


    /**
     * 一对多查询
     */
    List<Order> selectOneToManyOrderList(@Param("pid") int pid);


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


    /**
     * 取消、删除、确认收货订单  三合一 配送员 状态修改合集
     * @param userId
     * @param orderId
     * @param status
     * @return
     */
    public int updateUserOrderStatusByUserIdAndOrderId(@Param("userId") Integer userId,
                                                       @Param("orderId") Integer orderId,
                                                       @Param("status") Integer status);

    /**
     * 获取订单不同状态下的所有订单详情
     * @param userId
     * @param status
     * @return
     */
    List<Order> getUserOrdersByUserId(@Param("userId") Integer userId,@Param("status") Integer status);

    /**
     * 获取用户的所有订单及用户信息
     * @param userId
     * @return
     */
    List<Order> getUserAllOrdersAndUserByUserId(@Param("userId") Integer userId);

    /**
     * 更新地址
     * @param orderId
     * @param address
     * @return
     */
    public int updateOrderByAdmin(@Param("orderId") Integer orderId,
                             @Param("address") String address);

}
