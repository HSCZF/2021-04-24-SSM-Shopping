package com.czf.controller.cart;

import com.czf.model.Cart;
import com.czf.model.CartVo;
import com.czf.model.Product;
import com.czf.model.User;
import com.czf.service.CartService;
import com.czf.service.ProductService;
import com.czf.utils.Msg;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductService productService;

    /**
     * 添加到购物车
     *
     * @param id
     * @param textBox
     * @param session
     * @return
     */
    @RequestMapping("addToCart")
    @ResponseBody
    public Msg addToCart(Integer id, Integer textBox, HttpSession session) {
        System.out.println("cart/addToCart");
        System.out.println("textBox = " + textBox);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        } else {
            CartVo cartVo = new CartVo();
            cartVo.setCustomerId(user.getId());
            cartVo.setProductId(id);
            cartVo.setProductNum(textBox);
            System.out.println("商品成功加入购物车");
            // 需要减少商品数量，支付完成才减少，在支付宝接口处实现
           /* Product product = productService.findProductById(id);
            int newNumber = product.getShopNumber()-textBox;
            if(newNumber <= 0){
                newNumber = 0;
            }
            productService.updateProductNumber(newNumber, id);*/
            //System.out.println(cartVo);
            Product product = productService.findProductById(id);
            System.out.println("库存商品数量=" + product.getShopNumber());
            // 已有该购物车，点击购买，service层判断更新数量
            // 为了防止出现bug，去掉更新，保留添加已存在购物车更新数量操作
            if (product.getShopNumber() >= 1) {
                int sum = cartService.saveToCart(cartVo);
                if (sum == 1) {
                    return Msg.success().add("vag", "商品成功加入购物车");
                } else if (sum == 0) {
                    return Msg.fail().add("vag", "添加失败");
                }else {
                    return Msg.fail().add("vag", "该商品已添加至购物车，请勿重复添加");
                }
            } else {
                return Msg.fail().add("vag", "商品缺货");
            }
        }
    }

    /**
     * 显示购物车详情
     *
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("showShopCarts")
    public String showShopCarts(HttpSession session, Model model) {
        System.out.println("显示购物车详情");
        User user = (User) session.getAttribute("session_user");
        //System.out.println(user);
        if (user != null) {
            List<Cart> cartList = cartService.findCustomerAllCarts(user.getId());
            //System.out.println(cartList);
            model.addAttribute("cartList", cartList);
        }
        return "cart";
    }

    /**
     * 只删除购物车中一个商品
     *
     * @return
     */
    @RequestMapping("/removeOneProduct")
    @ResponseBody
    public Msg removeOneProduct(Integer cartId, HttpSession session) {
        System.out.println("删除一个商品...");
        System.out.println(cartId);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        Boolean flag = cartService.deleteProductByCustomerId(cartId, user.getId());
        //Cart cart = cartService.

        if (flag) {
            return Msg.success().add("vag", "商品删除成功！");
        }
        return Msg.fail().add("vag", "商品删除失败！");
    }

    /**
     * 删除购物车中多个商品
     *
     * @return
     */
    @RequestMapping("removeMoreProduct")
    @ResponseBody
    public Msg removeMoreProductFromCart(Integer[] cartIds, HttpSession session) {
        System.out.println("删除多个商品...");
        for (Integer id : cartIds) {
            System.out.print(id + ",");
        }
        System.out.println();
        System.out.println(cartIds);
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        Boolean flag = cartService.deleteProductByCustomerIds(cartIds, user.getId());
        if (flag) {
            return Msg.success().add("vag", "商品删除成功！");
        }
        return Msg.fail().add("vag", "商品删除失败！");
    }

    /**
     * 局部刷新：用户点击 ”+“ ”-“ 商品数量变化
     *
     * @param cartId
     * @param productNum
     * @param session
     * @return
     */
    @RequestMapping("updateProductNum")
    @ResponseBody
    public Msg inputModifyProductNum(Integer cartId, Integer productNum, HttpSession session) {
        System.out.println("修改商品数量。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        if (cartService.updateProductNumByCustomerIdAndCartId(cartId, productNum, user.getId())) {
            return Msg.success().add("vag", "商品数量已修改");
        }
        return Msg.fail().add("vag", "商品数量修改失败！");
    }

    /**
     * 清空购物车
     *
     * @param session
     * @return
     */
    @RequestMapping("removeAllProduct")
    @ResponseBody
    public Msg clearAllProductFromCart(HttpSession session) {
        System.out.println("清空购物车。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        } else {
            if (cartService.updateCartStatusByCustomerId(user.getId())) {
                return Msg.success().add("vag", "购物车已清空");
            }
        }
        return Msg.fail().add("vag", "购物车清除失败");
    }

    /**
     * 数据暂时存在session缓存中，不存在数据库
     *
     * @param count
     * @param price
     * @param orderCartIds
     * @param session
     * @return
     */
    @RequestMapping("addOrderItem")
    @ResponseBody
    public Msg addOrderItem(Integer count, String price, Integer[] orderCartIds, HttpSession session) {
        System.out.println("购物车计算，生成订单。。。。");
        User user = (User) session.getAttribute("session_user");
        if (ObjectUtils.isEmpty(user)) {
            //用户没有登录，则提示让他登录
            return Msg.fail().add("vag", "请登录在操作");
        }
        session.setAttribute("count", count);
        System.out.println("price = " + price);
        /*String[] str = price.split("¥");
        for (String s : str) {
            System.out.println("price.split = " + s);
        }*/
        double newPrice = Double.parseDouble(price);

        session.setAttribute("price", newPrice);
        session.setAttribute("orderCartIds", orderCartIds);
        return Msg.success().add("vag", "结算成功");
    }

}
