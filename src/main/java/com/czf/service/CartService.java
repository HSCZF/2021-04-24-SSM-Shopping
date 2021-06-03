package com.czf.service;

import com.czf.model.Cart;
import com.czf.model.CartVo;

import java.util.List;

public interface CartService {

    /**
     * 添加购物车
     * @param cartVo
     * @return
     */
    int saveToCart(CartVo cartVo);

    /**
     * 查找用户购物车所有商品
     * @param customerId
     * @return
     */
    List<Cart> findCustomerAllCarts(Integer customerId);

    /**
     * 删除购物车一个商品
     * @param cartId
     * @param customerId
     * @return
     */
    Boolean deleteProductByCustomerId(Integer cartId, Integer customerId);

    /**
     * 删除购物车多个商品
     * @param cartIds
     * @param customerId
     * @return
     */
    Boolean deleteProductByCustomerIds(Integer[] cartIds, Integer customerId);

    /**
     * 用户在购物车页面修改商品数量
     * @param cartId
     * @param productNum
     * @param id
     * @return
     */
    Boolean updateProductNumByCustomerIdAndCartId(Integer cartId, Integer productNum, Integer id);

    /**
     * 清空购物车，状态变更，数据库保留信息
     * @param id
     * @return
     */
    Boolean updateCartStatusByCustomerId(Integer id);

    /**
     * 订单确认，状态码 1
     * @param orderCartIds
     * @param id
     * @return
     */
    List<Cart> findCartByCartIdsAndCustomerId(Integer[] orderCartIds, Integer id);

    /**
     * 根据购物车状态码查询
     * @param orderCartIds
     * @param id
     * @return
     */
    List<Cart> findStatusCartByCartIdsAndCustomerId(Integer[] orderCartIds, Integer id);


}
