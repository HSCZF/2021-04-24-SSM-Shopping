package com.czf.service;

import com.czf.model.OrderItem;

import java.util.List;

public interface OrderItemService {

    /**
     * 根据订单id 查询用户下的订单
     * @param id
     * @return
     */
    List<OrderItem> findOrderItemsByOrderId(Integer id);

}
