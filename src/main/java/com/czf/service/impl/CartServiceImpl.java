package com.czf.service.impl;

import com.czf.dao.CartDao;
import com.czf.dao.ProductDao;
import com.czf.model.Cart;
import com.czf.model.CartVo;
import com.czf.model.Product;
import com.czf.model.User;
import com.czf.service.CartService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CartServiceImpl implements CartService {

    @Autowired
    private CartDao cartDao;

    @Autowired
    private ProductDao productDao;

    /**
     * 添加商品到购物车
     *
     * @param cartVo
     * @return
     */
    @Override
    public int saveToCart(CartVo cartVo) {
        System.out.println(cartVo);
        System.out.println("cart/addToCar....接口");
        Cart isExistCart = cartDao.selectCartIsExistProduct(cartVo.getCustomerId(), cartVo.getProductId());
        // 个人购物车没有这件商品，直接添加新的
        if (isExistCart == null) {
            Cart cart = new Cart();
            // 获取商品的 Id 的信息
            Product product = productDao.selectProductById(cartVo.getProductId());
            // 计算总的价格
            Double sum = product.getPrice() * cartVo.getProductNum();
            // 一次性赋值，修改的后面在设置
            BeanUtils.copyProperties(cartVo, cart);
            cart.setTotalPrice(sum);
            cart.setProduct(product);
            cart.setStatus(1);
            cart.setCreateTime(new Date());
            System.out.println("addTocar接口 = " + cart);
            int row = cartDao.insertCart(cart);
            if (row >= 1) {
                return 1;
            } else {
                return 0;
            }
        }else {
            // 购物车存在这个商品，更新数量即可
            // 更新数量需要判断库存，不可能让你无限添加
            return 2;
            /*int newTotal = isExistCart.getProductNum() + cartVo.getProductNum();
            Product product = productDao.selectProductById(cartVo.getProductId());
            if(newTotal <= product.getShopNumber()){
                Double newSum = product.getPrice() * newTotal;
                int row = cartDao.updateCartNumAndTotalPriceById(isExistCart.getId(), newTotal, newSum);
                if (row >= 1) {
                    return 1;
                }else {
                    return 0;
                }
            }else {
                return 2;
            }*/
        }
    }

    /**
     * 查找用户购物车所有商品
     * @param customerId
     * @return
     */
    @Override
    public List<Cart> findCustomerAllCarts(Integer customerId) {
        return cartDao.findCustomerAllCarts(customerId);
    }

    @Override
    public Boolean deleteProductByCustomerId(Integer cartId, Integer id) {
        int rows = cartDao.deleteProductByCustomerId(cartId, id , 0);
        if (rows >= 1) {
            return true;
        }
        return false;
    }

    @Override
    public Boolean deleteProductByCustomerIds(Integer[] cartIds, Integer customerId) {
        int rows = cartDao.deleteProductByCustomerIds(cartIds, customerId, 0);
        if (rows >= 1) {
            return true;
        }
        return false;
    }

    @Override
    public Boolean updateProductNumByCustomerIdAndCartId(Integer cartId, Integer productNum, Integer id) {
        Cart cart = cartDao.selectCartByCustomerIdAndCartId(id, cartId);
        Double totolPrice = (cart.getProduct().getPrice()) * productNum;
        int rows = cartDao.updateProductNumByCustomerIdAndCartId(cartId, productNum, id, 1, totolPrice);
        if (rows >= 1) {
            return true;
        }
        return false;
    }

    /**
     * 清空购物车
     * @param id
     * @return
     */
    @Override
    public Boolean updateCartStatusByCustomerId(Integer id) {
        int rows = cartDao.updateCartStatusByCustomerId(id, 0);
        if(rows >= 1){
            return true;
        }
        return false;
    }

    /**
     * 订单确认 状态码 1 查询
     * @param orderCartIds
     * @param id
     * @return
     */
    @Override
    public List<Cart> findCartByCartIdsAndCustomerId(Integer[] orderCartIds, Integer id) {

        List<Cart> cartList = cartDao.findCartByCartIdsAndCustomerId(orderCartIds, id, 1);
        if(cartList.size() == 0){
            return null;
        }
        return cartList;
    }

    /**
     * 根据购物车状态码 2 查询
     * @param orderCartIds
     * @param id
     * @return
     */
    @Override
    public List<Cart> findStatusCartByCartIdsAndCustomerId(Integer[] orderCartIds, Integer id) {
        List<Cart> cartList = cartDao.findStatusCartByCartIdsAndCustomerId(orderCartIds, id, 2);
        if (cartList.size() == 0) {
           return null;
        }
        return cartList;
    }


}
