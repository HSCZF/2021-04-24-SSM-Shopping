package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductParam implements Serializable {

    /*商品名称*/
    private String name;
    /*最低价格*/
    private Double minPrice;
    /*最高价格*/
    private Double maxPrice;
    /*商品类型的id*/
    private Integer productTypeId;

}
