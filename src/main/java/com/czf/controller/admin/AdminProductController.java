package com.czf.controller.admin;

import com.czf.model.*;
import com.czf.service.ProductService;
import com.czf.service.ProductTypeService;
import com.czf.utils.Msg;
import com.czf.utils.SystemContext;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.fileupload.FileUploadException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/admin/product")
public class AdminProductController {

    @Autowired
    private ProductTypeService productTypeService;

    @Autowired
    private ProductService productService;


    /**
     * 管理员分页所有商品
     *
     * @param pageNum
     * @param model
     * @return
     */
    @RequestMapping("getAllProducts")
    public String getAllProducts(Integer pageNum, Model model, HttpSession session) {
        System.out.println("管理员：商品分页");
        Admin admin = (Admin) session.getAttribute("session_admin");
        if (ObjectUtils.isEmpty(admin)) {
            // 传回来为空，则设为 1
            return "system/login";
        }
        if (ObjectUtils.isEmpty(pageNum)) {
            // 传回来为空，则设为 1
            pageNum = 1;
        }
        PageHelper.startPage(pageNum, 5);
        List<Product> productList = productService.findAllProducts();
        PageInfo<Product> pageInfo = new PageInfo<>(productList);
        model.addAttribute("pageInfo", pageInfo);
        return "/system/products";
    }

    /**
     * 查询有效商品类型
     *
     * @return
     */
    @ModelAttribute("productTypes")
    public List<ProductType> findAllProductTypes() {
        List<ProductType> productTypeList = productTypeService.findAllProductTypesWithStatus(1);
        return productTypeList;
    }

    /**
     * 上传图片：添加商品
     *
     * @return
     */
    @RequestMapping("/upload")
    public String addProductMut(@RequestParam("file") MultipartFile multipartFile, Model model, HttpSession session,
                                Integer productTypeId,ProductVo productVo, Integer pageNum) throws IOException, FileUploadException {
        // 处理上传文件
        // 重命名处理，先拿源文件名字，获取后缀
        System.out.println("输出productTypeId="+productTypeId);
        if (!multipartFile.isEmpty()) {
            try {
                String originalFilename = multipartFile.getOriginalFilename();
                String uu_path = UUID.randomUUID().toString();
                // 图片数据库保存路径
                String last_path = uu_path + originalFilename;
                String finally_path = "\\upload\\" + last_path;
                // 文件本地路径
                String path = "E:\\IdeaProjects\\GraduationDesign-1710819070\\upload\\" + last_path;
                System.out.println("路径path =" + path);
                File file = new File(path);
                // 判断文文件夹是否为空
                if (!file.exists()) {
                    file.mkdir();
                }
                Product product = new Product();                // 先存路径
                BeanUtils.copyProperties(productVo, product);    // 复制过去，form表单元素，productVo中间实体类
                product.setImage(finally_path);                     // 存放路径
                product.setProductTypeId(productTypeId);      // 商品类型id
                int sum = productService.addProduct(product);               // 插入数据库

                if (sum >= 1) {
                    multipartFile.transferTo(file);                         // 图片写入磁盘路径
                    model.addAttribute("successMsg", "添加成功");
                } else {
                    model.addAttribute("failMsg", "添加失败");
                }
                //System.out.println(product);
            }catch (Exception e) {
                model.addAttribute("errorMsg", "文件上传失败");
            }
        } else {
            model.addAttribute("failMsg", "添加失败，图片不能为空");
        }
        return "forward:getAllProducts?pageNum=" + pageNum;
    }

    /**
     * 更新商品
     * @param multipartFile
     * @param productVo
     * @param productTypeId
     * @param pageNum
     * @param session
     * @param model
     * @return
     */
    @RequestMapping("modifyProduct")
    public String modifyProduct(@RequestParam("file") MultipartFile multipartFile, ProductVo productVo, Integer productTypeId, Integer pageNum, HttpSession session, Model model)  {
        try {
            // 文件本地路径
            String originalFilename = multipartFile.getOriginalFilename();
            String uu_path = UUID.randomUUID().toString();

            // 图片数据库保存路径
            String last_path = uu_path + originalFilename;
            String finally_path = "\\upload\\" + last_path;
            // 文件本地路径
            String path = "E:\\IdeaProjects\\GraduationDesign-1710819070\\upload\\" + last_path;
            System.out.println("if语句前的路径path =" + path);
            File file = new File(path);
            Product product = new Product();                // 先存路径
            BeanUtils.copyProperties(productVo, product);    // 复制过去，form表单元素，productVo中间实体类

            if(multipartFile.isEmpty()){                     // 上传空的，还是原来的图片
                System.out.println("图片为空");
                Product productPath = productService.findProductById(product.getId());
                String originalPath = productPath.getImage();       // 原路径
                product.setImage(originalPath);
                System.out.println("图片为空时候，原路径 = " + originalPath);
                product.setProductTypeId(productTypeId);      // 商品类型id
                int sum = productService.updateProduct(product);               // 插入数据库
                if (sum >= 1) {
                    multipartFile.transferTo(file);                         // 图片写入磁盘路径
                    model.addAttribute("successMsg", "修改成功");
                } else {
                    model.addAttribute("failMsg", "修改失败");
                }
            }else {
                // 图片是空的
                System.out.println("图片不为空");
                product.setImage(finally_path);                     // 存放路径
                System.out.println("图片不为空finally_path = " + finally_path);
                product.setProductTypeId(productTypeId);      // 商品类型id
                int sum = productService.updateProduct(product);               // 插入数据库
                if (sum >= 1) {
                    multipartFile.transferTo(file);                         // 图片写入磁盘路径
                    model.addAttribute("successMsg", "修改成功");
                } else {
                    model.addAttribute("failMsg", "修改失败");
                }
            }
        } catch (Exception e) {
            model.addAttribute("errorMsg", "文件上传失败");
        }
        //重新刷新页面加载数据
        return "forward:getAllProducts?pageNum=" + pageNum;
    }

    /**
     * 商品有没有重复命名的
     *
     * @param name
     * @param model
     * @return
     */
    @RequestMapping("checkProductName")
    @ResponseBody
    public Map<String, Object> checkProductName(String name, Model model) {
        Map<String, Object> map = new HashMap<>();
        if (productService.checkProductName(name)) {
            map.put("valid", true);
        } else {
            map.put("valid", false);
            map.put("message", "商品(" + name + ")已存在");
        }
        return map;
    }

    /**
     * 删除商品
     *
     * @param id
     * @return
     */
    @RequestMapping("removeProductById")
    @ResponseBody
    public Msg removeProductById(int id) {
        int rows = productService.removeProductById(id);
        if (rows >= 1) {
            return Msg.success().add("v_vag", "商品删除成功");
        } else {
            return Msg.fail().add("v_vag", "商品删除失败");
        }
    }

    /**
     * 查询一个商品
     * @param id
     * @return
     */
    @RequestMapping("findProductById")
    @ResponseBody
    public Msg findProductById(int id) {
        Product product = productService.findProductById(id);
        if (product != null) {
            return Msg.success().add("product", product);
        }else{
            return Msg.fail().add("vag", "该商品信息不存在");
        }
    }


}
