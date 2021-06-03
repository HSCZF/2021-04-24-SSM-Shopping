package com.czf.dao;

import com.czf.model.ProductType;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ProductTypeDao {

    /**
     * 插入
     * @param name
     * @param status
     * @return
     */
    int insertProductType(@Param("name") String name,
                      @Param("status") int status);

    /**
     * 名字查询
     * @param name
     * @return
     */
    ProductType selectProductTypeByName(@Param("name") String name);

    /**
     * 查找所有商品类型
     */
    List<ProductType> findAllProductTypes();

    /**
     * 查找所有有效的商品类型
     */
    List<ProductType> findAllProductTypesWithStatus(int status);

    /**
     * 根据id查找类别
     * @param id
     * @return
     */
    ProductType selectProductTypeById(@Param("id") Integer id);


    /**
     * 更新类型
     * @param id
     * @param name
     * @return
     */
    int updateName(@Param("id") Integer id,
                           @Param("name") String name);


    /**
     * 禁用/启用
     * @param id
     * @param status
     * @return
     */
    int updateStatus(@Param("id") Integer id,
                           @Param("status") Integer status);

    /**
     * 删除
     * @param id
     * @return
     */
    int deleteProductTypeById(@Param("id") int id);




}
