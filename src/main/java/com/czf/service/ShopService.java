package com.czf.service;

import com.czf.model.Cart;
import com.czf.model.CartVo;
import com.czf.model.Shop;
import com.czf.model.ShopVo;

import java.util.List;

public interface ShopService {

    /**
     * 查询用户的所有收货地址
     * @param userId
     * @return
     */
    List<Shop> findUserAllShops(Integer userId);

    /**
     * 显示用户的一个地址信息
     * @param userId
     * @param shopId
     * @return
     */
    Shop findShopByUserIdAndShopId(Integer userId,Integer shopId);

    /**
     * 用户修改配送地址
     * @param shopVo
     * @param userId
     * @return
     */
    Boolean updateShopAddress(ShopVo shopVo, Integer userId);

    /**
     * 添加用户配送地址
     * @param shopVo
     * @param userId
     * @return
     */
    public int addShop(ShopVo shopVo, Integer userId);

    /**
     * 用户删除一个地址
     * @param shopId
     * @param userId
     * @return
     */
    Boolean deleteShopAddress(Integer shopId, Integer userId);

}
