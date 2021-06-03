package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cart implements Serializable {

    /*  商品id */
    private Integer id;
    /*客户id*/
    private Integer customerId;


    /*商品对象*/
    private Product product;   // 封装商品对象


    /*商品数量*/
    private Integer productNum;
    /*商品加入购物车的时间*/
    private Date createTime;
    /*商品总价*/
    private Double totalPrice;
    /* 状态 */
    private Integer status;

}
