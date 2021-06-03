package com.czf.service.impl;

import com.czf.dao.ProductTypeDao;
import com.czf.model.ProductType;
import com.czf.service.ProductTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ProductTypeServiceImpl implements ProductTypeService {

    @Autowired
    private ProductTypeDao productTypeDao;

    @Override
    public void insertProductType(String name, int status) {
        productTypeDao.insertProductType(name, status);
    }

    @Override
    public ProductType selectProductTypeByName(String name) {
        return productTypeDao.selectProductTypeByName(name);
    }

    /**
     * 查询所有商品类型信息
     * @return
     */
    @Override
    public List<ProductType> findAllProductTypes() {
        return productTypeDao.findAllProductTypes();
    }

    /**
     * 查询所有商品类型信息 有效的
     * @param status
     * @return
     */
    @Override
    public List<ProductType> findAllProductTypesWithStatus(int status) {
        return productTypeDao.findAllProductTypesWithStatus(1);
    }

    @Override
    public ProductType selectProductTypeById(Integer id) {
        return productTypeDao.selectProductTypeById(id);
    }

    @Override
    public int updateName(Integer id, String name) {
        return productTypeDao.updateName(id, name);
    }

    @Override
    public int updateStatus(Integer id, Integer status) {
        return productTypeDao.updateStatus(id, status);
    }

    @Override
    public Boolean deleteProductTypeById(int id) {
        int sum = productTypeDao.deleteProductTypeById(id);
        if(sum >= 1){
            return true;
        }
        return false;
    }
}
