package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

public class OrderItem implements Serializable{
    /*订单类目id*/
    private Integer id;
    /*商品数量*/
    private Integer num;
    /*商品小计*/
    private Double price;
    /* 商品地址 */
    private String address;
    /* 订单id*/
    private Integer orderId;
    /*商品对象*/
    private Product product;
    /*所属于哪个订单，订单对象*/
    private Order order;

    public OrderItem() {
    }

    public OrderItem(Integer num, Double price, String address, Integer orderId, Product product, Order order) {
        this.num = num;
        this.price = price;
        this.address = address;
        this.orderId = orderId;
        this.product = product;
        this.order = order;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }


}
