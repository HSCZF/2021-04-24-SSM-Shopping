package com.czf.test;


import com.czf.model.Product;
import com.czf.model.ProductParam;
import com.czf.service.ProductService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class productTest {

    @Autowired
    private ProductService productService;

    @Test
    public void productAndParamAll() {
        ProductParam productParam = new ProductParam();
        List<Product> products = productService.findByProductParams(productParam);
        for (Product product : products) {
            System.out.println(product);
        }
    }

    @Test
    public void productAll() {
        /*List<Product> products = productService.findAllProducts();
        for (Product product : products) {
            System.out.println(product);
        }*/
        Product product = productService.findProductById(18);
        System.out.println(product);
    }

    @Test
    public void productAll1() {
        String p = "12345667";
        String p1 = p.substring(1);
        System.out.println(p1);
    }

}
