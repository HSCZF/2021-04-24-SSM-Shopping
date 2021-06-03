package com.czf.model;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product implements Serializable{

    /*商品id*/
    private Integer id;
    /*商品名称*/
    private String name;
    /*商品价格*/
    private Double price;
    /*商品简介*/
    private String info;
    /*商品的图片*/
    private String image;
    /*商品的数量*/
    private Integer shopNumber;
    /*商品的类型id*/
    private Integer productTypeId;
    /*商品类型*/
    private ProductType productType;

}
