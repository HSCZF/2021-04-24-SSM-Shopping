package com.czf.service.impl;

import com.czf.dao.OrderItemDao;
import com.czf.model.OrderItem;
import com.czf.service.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class OrderItemServiceImpl implements OrderItemService {

    @Autowired
    private OrderItemDao orderItemDao;

    /**
     * 根据订单id 查询用户下的订单
     * @param id
     * @return
     */
    @Override
    public List<OrderItem> findOrderItemsByOrderId(Integer id) {
        List<OrderItem> orderItems = orderItemDao.findOrderItemsByOrderId(id);
        return orderItems;
    }
}
