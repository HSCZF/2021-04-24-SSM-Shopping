package com.czf.dao;

import com.czf.model.Product;
import com.czf.model.ProductParam;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductDao {
    int insertProduct(Product product);

    Product selectByProductName(String name);

    List<Product> selectAllProducts();

    List<Product> selectAllProductsWithStatus(@Param("status") Integer status);

    Product selectProductById(int id);

    int updateProduct(Product product);

    int updateProductNumber(@Param("shopNumber") Integer shopNumber,
                            @Param("id") Integer id);

    int deleteProductById(@Param("id") Integer id);

    List<Product> selectByProductParams(ProductParam productParam);

    List<Product> getAllProductByIndex();
}
