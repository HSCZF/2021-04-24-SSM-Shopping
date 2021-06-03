package com.czf.controller.shop;

import com.czf.common.PageConstant;
import com.czf.model.Deliver;
import com.czf.model.Product;
import com.czf.model.ProductParam;
import com.czf.model.ProductType;
import com.czf.service.ProductService;
import com.czf.service.ProductTypeService;
import com.czf.utils.Msg;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductTypeService productTypeService;

    /**
     * 商品分页功能
     * @param productParam
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("/searchAllProducts")
    public String searchAllProducts(ProductParam productParam, Integer pageNum, Model model) {
        System.out.println("/product/searchAllProducts.....");
        if (ObjectUtils.isEmpty(pageNum)) {
            pageNum = 1;  // 默认页码为 1
        }
        PageHelper.startPage(pageNum, 800);  // 分20页吧
        //List<Product> products = productService.findByProductParams(productParam);
        List<Product> productList = productService.getAllProductByIndex();
        //PageInfo pageInfo = new PageInfo(products, 100);
        PageInfo<Product> pageInfo = new PageInfo<>(productList);
        model.addAttribute("pageInfo", pageInfo);
        return "index";
    }

    /**
     * 模糊查询
     * @param productParam
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("/getAllParams")
    public String getAllParams(ProductParam productParam, Integer pageNum, Model model) {
        System.out.println("/product/getAllParams.....");
        if (ObjectUtils.isEmpty(pageNum)) {
            pageNum = 1;  // 默认页码为 1
        }
        PageHelper.startPage(pageNum, 800);  // 分20页吧
        List<Product> products = productService.findByProductParams(productParam);
        //PageInfo pageInfo = new PageInfo(products, 100);
        PageInfo<Product> pageInfo = new PageInfo<>(products);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("params", productParam);
        return "index";
    }

    /**
     * 商品详情
     * @param model
     * @param id
     * @return
     */
    @RequestMapping("showProductDetail")
    public String showProductDetail(Model model,Integer id) {

        Product product = productService.findProductById(id);
        if (product != null) {
            model.addAttribute("product", product);
        }
        return "productDetail";
    }

    /**
     * 查询类型为1的商品
     * @return
     */
    @ModelAttribute("productTypes")
    public List<ProductType> findAllProductTypes(){
        List<ProductType> productTypeList = productTypeService.findAllProductTypesWithStatus(1);
        return productTypeList;
    }


}
