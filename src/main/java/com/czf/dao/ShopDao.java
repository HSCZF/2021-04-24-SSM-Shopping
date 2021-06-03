package com.czf.dao;

import com.czf.model.Shop;
import com.czf.model.ShopVo;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface ShopDao {

    /**
     * 查询用户的所有收货地址
     * @param userId
     * @param status
     * @return
     */
    List<Shop> findUserAllShops(@Param("userId") Integer userId , @Param("status") Integer status);

    /**
     * 显示用户的一个地址信息
     * @param userId
     * @param shopId
     * @return
     */
    Shop findShopByUserIdAndShopId(@Param("userId") Integer userId,
                                                     @Param("shopId") Integer shopId);

    /**
     * 用户修改配送地址，查询是否有这个地址的信息
     * @param userId
     * @param shopId
     * @return
     */
    Shop findShopAddressByUserIdAndShopId(@Param("userId") Integer userId,
                                                     @Param("shopId") Integer shopId);

    /**
     * 用户地址更新
     * @param shop
     * @return
     */
    public int updateByShop(Shop shop);

    /**
     * 添加用户配送地址
     * @param shop
     * @return
     */
    public int addShop(Shop shop);

    /**
     * 用户删除一个配送地址
     * @param shopId
     * @param userId
     * @param status
     * @param updateTime
     * @return
     */
    int deleteShopAddressByShopIdAndUserId(@Param("shopId") Integer shopId,
                                        @Param("userId") Integer userId,
                                        @Param("status") int status,
                                        @Param("updateTime") Date updateTime);
}

