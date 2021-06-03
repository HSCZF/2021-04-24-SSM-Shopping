package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;


@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderVo extends Order implements Serializable {
    /*订单中包含的类目*/
    private List<OrderItem> orderItemList;
}
