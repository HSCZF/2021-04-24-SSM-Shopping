package com.czf.model;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order implements Serializable {
    /*订单id*/
    private Integer id;
    /*订单编号*/
    private String orderNumber;
    /* 客户id */
    private Integer customerId;
    /*商品总价*/
    private Double price;
    /*订单的创建时间*/
    private Date createDate;
    /*商品数量*/
    private Integer productNumber;
    /**
     *功能描述:订单的状态
     * 0 表示未支付
     * 1 表示已经付未发货
     * 2 表示已支付已发货
     * 3 表示已发货未收货
     * 4 表示交易完成
     * 5 表示客户删除的订单，设置为无效
     */
    private Integer status;
    /*收货地址*/
    private String address;
    /*客户对象*/
    private User user;

    /* 配送订单和评论 */
    private Comment comment;

    private OrderItem orderItem;

    public OrderItem getOrderItem() {
        return orderItem;
    }

    public void setOrderItem(OrderItem orderItem) {
        this.orderItem = orderItem;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderNumber='" + orderNumber + '\'' +
                ", customerId=" + customerId +
                ", price=" + price +
                ", createDate=" + createDate +
                ", productNumber=" + productNumber +
                ", status=" + status +
                ", address='" + address + '\'' +
                ", user=" + user +
                ", comment=" + comment +
                ", orderItem=" + orderItem +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Integer getProductNumber() {
        return productNumber;
    }

    public void setProductNumber(Integer productNumber) {
        this.productNumber = productNumber;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }


}
