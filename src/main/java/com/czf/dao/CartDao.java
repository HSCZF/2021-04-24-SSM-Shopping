package com.czf.dao;

import com.czf.model.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CartDao {

    /**
     * 添加购物车
     *
     * @param cart
     * @return
     */
    public int insertCart(Cart cart);

    /**
     * 获取一个购物车
     * @param id
     * @return
     */
    Cart selectCartById(@Param("id") Integer id);

    /**
     * 查看购物车
     *
     * @param customerId
     * @return
     */
    public List<Cart> findCustomerAllCarts(Integer customerId);

    /**
     * 查看购物车是否存在该商品信息
     *
     * @param customerId
     * @param productId
     * @return
     */
    public Cart selectCartIsExistProduct(@Param("customerId") Integer customerId, @Param("productId") Integer productId);

    /**
     * 根究用户id和购物车id 查商品
     * @param customerId
     * @param cartId
     * @return
     */
    public Cart selectCartByCustomerIdAndCartId(@Param("customerId") Integer customerId,@Param("cartId") Integer cartId);

    /**
     * 更新购物车
     *
     * @param id
     * @param num
     * @param price
     * @return
     */
    public int updateCartNumAndTotalPriceById(@Param("id") Integer id, @Param("productNum") Integer num, @Param("totalPrice") Double price);

    /**
     * 删除单个商品
     *
     * @param cartId
     * @param id
     * @param status
     * @return
     */
    public int deleteProductByCustomerId(@Param("cartId") Integer cartId,
                                         @Param("customerId") Integer id,
                                         @Param("status") Integer status);

    /**
     * 删除多个商品
     *
     * @param cartIds
     * @param customerId
     * @param status
     * @return
     */
    public int deleteProductByCustomerIds(@Param("cartIds") Integer[] cartIds,
                                          @Param("customerId") Integer customerId,
                                          @Param("status") Integer status);

    /**
     * 用户在购物车页面修改商品数量
     * @param cartId
     * @param productNum
     * @param id
     * @param status
     * @param totalPrice
     * @return
     */
    public int updateProductNumByCustomerIdAndCartId(@Param("cartId") Integer cartId,
                                                               @Param("productNum") Integer productNum,
                                                               @Param("customerId") Integer id,
                                                               @Param("status") int status,
                                                               @Param("totalPrice")Double totalPrice);

    /**
     * 清空购物车
     * @param id
     * @param status
     * @return
     */
    public int updateCartStatusByCustomerId(@Param("customerId") Integer id,@Param("status") Integer status);

    /**
     * 确认订单
     * @param orderCartIds
     * @param id
     * @param status
     * @return
     */
    List<Cart> findCartByCartIdsAndCustomerId(@Param("cartIds") Integer[] orderCartIds,
                                                @Param("customerId") Integer id,
                                                @Param("status") int status);

    /**
     * 根据购物车状态码去查询
     * @param orderCartIds
     * @param id
     * @param status
     * @return
     */
    List<Cart> findStatusCartByCartIdsAndCustomerId(@Param("cartIds") Integer[] orderCartIds,
                                                        @Param("customerId") Integer id,
                                                        @Param("status") int status);

}
