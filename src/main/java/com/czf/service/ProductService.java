package com.czf.service;

import com.czf.model.Product;
import com.czf.model.ProductDto;
import com.czf.model.ProductParam;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.ibatis.annotations.Param;

import java.io.OutputStream;
import java.util.List;

/**
 * 商品业务层
 */
public interface ProductService {

    /**
     *功能描述: 添加商品
     */
    int addProduct(Product product) throws FileUploadException;

    /**
     *功能描述: 检测商品名称是否存在
     */
    Boolean checkProductName(String name);

    /**
     *功能描述: 查询所有商品的信息
     */
    List<Product> findAllProducts();

    List<Product> selectAllProductsWithStatus(@Param("status") Integer status);

    /**
     *功能描述: 根据id 查找商品信息
     */
    Product findProductById(int id);


    /**
     *功能描述: 根据id 删除商品
     */
    int removeProductById(int id);

    /**
     * 更新商品
     * @param product
     * @return
     */
    int updateProduct(Product product);

    List<Product> findByProductParams(ProductParam productParam);

    Boolean updateProductNumber(@Param("shopNumber") Integer shopNumber,
                            @Param("id") Integer id);

    List<Product> getAllProductByIndex();
}
