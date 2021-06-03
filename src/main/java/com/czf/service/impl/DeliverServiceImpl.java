package com.czf.service.impl;

import com.czf.dao.DeliverDao;
import com.czf.dao.OrderDao;
import com.czf.dao.OrderItemDao;
import com.czf.model.Deliver;
import com.czf.model.Order;
import com.czf.model.OrderItem;
import com.czf.model.OrderVo;
import com.czf.service.DeliverService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class DeliverServiceImpl implements DeliverService {

    @Autowired
    private DeliverDao deliverDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private OrderItemDao orderItemDao;


    @Override
    public List<Deliver> findAllDeliver() {
        return deliverDao.findAllDeliver();
    }

    @Override
    public List<Deliver> findDeliversByParams(Deliver deliver) {
        return deliverDao.findDeliversByParams(deliver);
    }

    @Override
    public int findByDeliverName(String DeliverName) {
        if(deliverDao.findByDeliverName(DeliverName) == 0){
            return 0;
        }
        return 1;
    }

    @Override
    public void insertDeliver(Deliver deliver) {
        deliverDao.insertDeliver(deliver);
    }

    @Override
    public Deliver getByDeliverId(Integer deliverId) {
        return deliverDao.getByDeliverId(deliverId);
    }

    @Override
    public void updateDeliver(Deliver deliver) {
        deliverDao.updateDeliver(deliver);
    }

    @Override
    public void deleteByDeliverId(Integer deliverId) {
        deliverDao.deleteByDeliverId(deliverId);
    }

    @Override
    public void deleteByManyDeliverId(Integer[] ids) {
        deliverDao.deleteByManyDeliverId(ids);
    }


}
