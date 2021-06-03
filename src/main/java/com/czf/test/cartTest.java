package com.czf.test;


import com.czf.model.Cart;
import com.czf.model.Product;
import com.czf.service.CartService;
import com.czf.service.ProductService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class cartTest {

    @Autowired
    private CartService cartService;

    @Autowired
    private ProductService productService;

    @Test
    public void test(){

        /*List<Cart> list = cartService.findCustomerAllCarts(14);
        System.out.println(list);*/
        Product product = productService.findProductById(18);
        productService.updateProductNumber(50, 18);


    }

}
