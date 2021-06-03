package com.czf.service.impl;

import com.czf.dao.ProductDao;
import com.czf.model.Product;
import com.czf.model.ProductDto;
import com.czf.model.ProductParam;
import com.czf.model.ProductType;
import com.czf.service.ProductService;
import com.czf.utils.StringUtil;
import org.apache.commons.fileupload.FileUploadException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StreamUtils;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 业务层接口实现类
 */
@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao productDao;

    @Override
    public int addProduct(Product product) throws FileUploadException {
        return productDao.insertProduct(product);
    }

    /**
     * 校验商品名称是否可用
     *
     * @param name
     * @return
     */
    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    @Override
    public Boolean checkProductName(String name) {
        Product product = productDao.selectByProductName(name);
        if (product != null) {
            return false;
        }
        return true;
    }

    @Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
    @Override
    public List<Product> findAllProducts() {
        return productDao.selectAllProducts();
    }

    @Override
    public List<Product> selectAllProductsWithStatus(Integer status) {
        return productDao.selectAllProductsWithStatus(status);
    }

    @Override
    public Product findProductById(int id) {
        return productDao.selectProductById(id);
    }


    @Override
    public int removeProductById(int id) {
        return productDao.deleteProductById(id);
    }

    @Override
    public int updateProduct(Product product) {
        return productDao.updateProduct(product);
    }


    @Override
    public List<Product> findByProductParams(ProductParam productParam) {
        return productDao.selectByProductParams(productParam);
    }

    @Override
    public Boolean updateProductNumber(Integer shopNumber, Integer id) {
        int sum = productDao.updateProductNumber(shopNumber, id);
        if (sum >= 1){
            return true;
        }
        return false;
    }

    @Override
    public List<Product> getAllProductByIndex() {
        return productDao.getAllProductByIndex();
    }
}
