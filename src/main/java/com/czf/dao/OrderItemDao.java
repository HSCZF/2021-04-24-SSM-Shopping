package com.czf.dao;

import com.czf.model.Order;
import com.czf.model.OrderItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderItemDao {

    /**
     * 插入订单
     * @param orderItemList
     * @return
     */
    public int insertOrderItemByOrderItems(@Param("orderItemList") List<OrderItem> orderItemList);

    /**
     * 根据订单id 查询用户下的订单
     * @param orderId
     * @return
     */
    List<OrderItem> findOrderItemsByOrderId(Integer orderId);



}
