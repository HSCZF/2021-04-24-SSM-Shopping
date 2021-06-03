package com.czf.test;

import com.czf.dao.UserDao;
import com.czf.model.Shop;
import com.czf.model.ShopVo;
import com.czf.model.User;
import com.czf.service.ShopService;
import com.czf.service.UserService;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class shopTest {

    @Autowired
    private ShopService shopService;

    @Test
    public void test() {

        Shop shop1 = shopService.findShopByUserIdAndShopId(106, 18);
        Shop shop2 = shopService.findShopByUserIdAndShopId(106, 19);
        System.out.println(shop1);
        System.out.println(shop2);

        ShopVo shopVo = new ShopVo();
        BeanUtils.copyProperties(shopVo, shop1);


    }


}
