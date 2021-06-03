package com.czf.service.impl;

import com.czf.dao.ShopDao;
import com.czf.model.Shop;
import com.czf.model.ShopVo;
import com.czf.service.ShopService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ShopServiceImpl implements ShopService {

    @Autowired
    private ShopDao shopDao;

    @Override
    public List<Shop> findUserAllShops(Integer userId) {
        List<Shop> shopList = shopDao.findUserAllShops(userId, 1);
        if (shopList.size() != 0) {
            return shopList;
        }
        return null;
    }

    /**
     * 显示用户的一个地址信息
     *
     * @param userId
     * @param shopId
     * @return
     */
    @Override
    public Shop findShopByUserIdAndShopId(Integer userId, Integer shopId) {
        Shop shop = shopDao.findShopByUserIdAndShopId(userId, shopId);
        if (shop != null) {
            return shop;
        }
        return null;
    }

    /**
     * 用户修改配送地址
     *
     * @param shopVo
     * @param userId
     * @return
     */
    @Override
    public Boolean updateShopAddress(ShopVo shopVo, Integer userId) {
        Shop shop = shopDao.findShopAddressByUserIdAndShopId(userId, shopVo.getId());
        //System.out.println("地址=" + shop);
        if (shop == null) {
            System.out.println("/ShopServiceImpl/updateShopAddress/用户地址不存在");
        }
        // 一次性复制过去，避免一个一个赋值
        BeanUtils.copyProperties(shopVo, shop);
        // 更新修改的时间
        shop.setUpdateTime(new Date());
        //System.out.println("新shop=" + shop);
        //System.out.println("id = " + shop.getId());
        int rows = shopDao.updateByShop(shop);
        if (rows >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 添加用户配送地址
     * @param shopVo
     * @param userId
     * @return
     */
    @Override
    public int addShop(ShopVo shopVo, Integer userId) {
        Shop shop = new Shop();
        // 一次性复制，数据库是没有ShopVo的
        BeanUtils.copyProperties(shopVo, shop);
        shop.setCustomerId(userId);
        shop.setCreateTime(new Date());
        shop.setUpdateTime(new Date());
        shop.setStatus(1);
        int rows = shopDao.addShop(shop);
        if(rows >= 1){
            return shop.getId();
        }
        return 0;  // 拿不到，失败
    }

    /**
     * 用户删除一个地址
     * @param shopId
     * @param userId
     * @return
     */
    @Override
    public Boolean deleteShopAddress(Integer shopId, Integer userId) {
        Date time = new Date();
        int rows = shopDao.deleteShopAddressByShopIdAndUserId(shopId, userId, 0, time);
        if(rows >= 1){
            return true;
        }
        return false;
    }
}
