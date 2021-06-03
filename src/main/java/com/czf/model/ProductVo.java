package com.czf.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.Serializable;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductVo implements Serializable {
    /*商品id*/
    private Integer id;
    /*商品名称*/
    private String name;
    /*商品价格*/
    private Double price;
    /*上传的图片*/
    private MultipartFile file;
    /*商品类型的id*/
    private Integer productTypeId;
    /*商品的描述*/
    private String info;
    /*商品数量*/
    private Integer shopNumber;

}
