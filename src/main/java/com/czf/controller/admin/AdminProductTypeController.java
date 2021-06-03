package com.czf.controller.admin;

import com.czf.model.Admin;
import com.czf.model.ProductType;
import com.czf.model.User;
import com.czf.service.ProductService;
import com.czf.service.ProductTypeService;
import com.czf.utils.Msg;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin/productType")
public class AdminProductTypeController {

    @Autowired
    private ProductTypeService productTypeService;

    @Autowired
    private ProductService productService;


    /**
     * 管理员分页所有商品类型
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllProductType")
    public String getAllProductType(Integer pageNum, Model model, HttpSession session){
        System.out.println("管理员：商品类型分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if(ObjectUtils.isEmpty(admin)){
            // 传回来为空，则设为 1
            return "system/login";
        }
        if(ObjectUtils.isEmpty(pageNum)){
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        PageHelper.startPage(pageNum,5);
        List<ProductType> productTypeList = productTypeService.findAllProductTypes();
        PageInfo<ProductType> pageInfo = new PageInfo<>(productTypeList);
        model.addAttribute("pageInfo", pageInfo);
        return "/system/productTypes";
    }

    /**
     * 获取一个商品类型信息
     * @param id
     * @return
     */
    @RequestMapping("/updateProductType")
    @ResponseBody
    public Msg updateProductType(Integer id){
        ProductType productType = productTypeService.selectProductTypeById(id);
        return Msg.success().add("productType", productType);
    }

    @RequestMapping("/insertIntoByAdmin")
    @ResponseBody
    public Msg insertIntoByAdmin(String name){
        ProductType productType = productTypeService.selectProductTypeByName(name);
        if (productType != null){
            return Msg.fail().add("vag", "类型已存在");
        }else {
            productTypeService.insertProductType(name, 1);
            return Msg.success();
        }
    }

    /**
     * 删除
     * @param id
     * @return
     */
    @RequestMapping("/deleteProductTypeByAdmin")
    @ResponseBody
    public Msg deleteProductTypeByAdmin(Integer id){
        Boolean flag = productTypeService.deleteProductTypeById(id);
      // productTypeService.updateName(id, name);
        if(flag){
            return Msg.success();
        }else {
            return Msg.fail();
        }
    }

    /**
     * 修改类型
     * @param id
     * @param name
     * @return
     */
    @RequestMapping("/updateProductTypeByAdmin")
    @ResponseBody
    public Msg updateProductTypeByAdmin(Integer id, String name){
        ProductType productType = productTypeService.selectProductTypeByName(name);
        if (productType != null){
            return Msg.fail().add("vag", "类型已存在");
        }else {
            productTypeService.updateName(id, name);
            return Msg.success();
        }
    }

    /**
     * 启用
     * @param id
     * @return
     */
    @RequestMapping("/updateProductTypeStatusByAdminToDisable")
    @ResponseBody
    public Msg updateProductTypeStatusByAdminToDisable(Integer id){
        productTypeService.updateStatus(id, 1);
        return Msg.success();
    }

    /**
     * 禁用
     * @param id
     * @return
     */
    @RequestMapping("/updateProductTypeStatusByAdminToEnable")
    @ResponseBody
    public Msg updateProductTypeStatusByAdminToEnable(Integer id){
        productTypeService.updateStatus(id, 0);
        return Msg.success();
    }


}
