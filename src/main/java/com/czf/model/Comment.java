package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class Comment implements Serializable {

    /* 评论的 id */
    private Integer id;
    /* 订单编号  唯一 */
    private String orderNumber;
    /* 用户id */
    private Integer userId;
    /* 用户名 */
    private String userName;
    /* 用户手机号 */
    private String userPhone;
    /* 用户配送地址 */
    private String userAddress;
    /* 配送员id */
    private Integer deliverId;
    /* 配送员名 */
    private String deliverName;
    /* 订单id */
    private Integer orderId;
    /* 评价内容 */
    private String comment;
    /*配送订单状态 */
    private Integer commentStatus;
    /*配送订单创建的时间 */
    private Date createTime;
    /* 配送完成的时间 */
    private Date endTime;

}
