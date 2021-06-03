package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductType {
    /*主键 id*/
    private Integer id;
    /*商品类型的状态 0 表示禁用，1表示启用，默认都是启用的状态*/
    private Integer status;
    /*商品类型的名称*/
    private String name;
}

