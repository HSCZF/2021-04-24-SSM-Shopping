package com.czf.test;


import com.czf.model.Product;
import com.czf.model.ProductParam;
import com.czf.model.ProductType;
import com.czf.service.ProductService;
import com.czf.service.ProductTypeService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class productTypeTest {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductTypeService productTypeService;

    @Test
    public void productTypeAll() {
        List<ProductType> productTypeList = productTypeService.findAllProductTypes();
        for (ProductType productType : productTypeList) {
            System.out.println(productType);
        }
    }

    @Test
    public void t1(){
        List<Product> products = productService.findAllProducts();
        for (Product product : products) {
            System.out.println(product);
        }
    }

}
