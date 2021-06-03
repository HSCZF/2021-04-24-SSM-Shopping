package com.czf.service;

import com.czf.model.Deliver;
import com.czf.model.Order;
import com.czf.model.OrderVo;

import java.util.List;

public interface DeliverService {


    /**
     * 查找所有配送员
     * @return
     */
    public List<Deliver> findAllDeliver();

    /**
     * 模糊查询
     * @param deliver
     * @return
     */
    public List<Deliver> findDeliversByParams(Deliver deliver);

    /**
     * 查询配送员是否已存在
     * @return
     */
    public int findByDeliverName(String DeliverName);

    /**
     * 添加配送员
     * @param deliver
     */
    public void insertDeliver(Deliver deliver);

    /**
     * 根据id查询配送员
     * @param deliverId
     * @return
     */
    public Deliver getByDeliverId(Integer deliverId);

    /**
     * 配送员更新信息
     * @param deliver
     */
    public void updateDeliver(Deliver deliver);

    /**
     * 删除单个配送员
     * @param deliverId
     * @return
     */
    public void deleteByDeliverId(Integer deliverId);

    /**
     * 删除多个配送员
     * @param ids
     * @return
     */
    public void deleteByManyDeliverId(Integer[] ids);



}
