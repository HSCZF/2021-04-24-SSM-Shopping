package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.InputStream;
import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductDto implements Serializable {
    /*商品id*/
    private Integer id;
    /*商品名称*/
    private String name;
    /*商品价格*/
    private Double price;
    /*商品简介*/
    private String info;
    /*商品类型Id*/
    private Integer productTypeId;
    /*文件输入流*/
    private InputStream inputStream;
    /*文件名称*/
    private String fileName;
    /*文件上传的位置*/
    private String uploadPath;
}
