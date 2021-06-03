package com.czf.controller.index;

import com.czf.common.PageConstant;
import com.czf.model.Product;
import com.czf.model.ProductParam;
import com.czf.service.ProductService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/Home")
public class IndexController {

    @Autowired
    private ProductService productService;

    /**
     * 直接跳转到商城首页
     * @return
     */
    @RequestMapping("/pages")
    public String pages(ProductParam productParam, Integer pageName, Model model) {
        System.out.println("===========进入商城首页===========");
        System.out.println("/Home/pages.....");
        if (ObjectUtils.isEmpty(pageName)) {
            pageName = PageConstant.PAGE_NUM;  // 默认页码为 1
        }
        // github分页插件
        PageHelper.startPage(pageName, PageConstant.FRONT_PAGE_SIZE);
        List<Product> products = productService.findByProductParams(productParam);
       /* for (Product product : products) {
            System.out.println(product);
        }*/
        PageInfo<Product> pageInfo = new PageInfo<>(products);
        model.addAttribute("pageInfo", pageInfo);
        return "index";
    }

}
