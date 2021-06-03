package com.czf.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.Pattern;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;

/**
 * 实体类
 */
@Data
@AllArgsConstructor
public class Deliver implements Serializable{

    private Integer id;

    /* 支持JSR303校验自定义规则 */
    @Pattern(regexp = "(^[\\u4e00-\\u9fa5]{1,7}$|^[\\a-zA-Z0-9]{1,14}$)"
            , message = "用户名必须是2-7位中文或者1-10位数字和字母的组合")
    private String deliverName;

    /* 支持JSR303校验自定义规则 */
    @Pattern(regexp = "^[1][3,4,5,7,8][0-9]{9}$"
            , message = "手机号码必须是11位数字")
    private String phone;

    private String deliverPassWord;
    private String confirm_passWord;
    private String sex;
    private Integer totalName;
    private Integer status;
    private String role;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date addTime;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Timestamp updateTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDeliverName() {
        return deliverName;
    }

    public void setDeliverName(String deliverName) {
        this.deliverName = deliverName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDeliverPassWord() {
        return deliverPassWord;
    }

    public void setDeliverPassWord(String deliverPassWord) {
        this.deliverPassWord = deliverPassWord;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public Integer getTotalName() {
        return totalName;
    }

    public void setTotalName(Integer totalName) {
        this.totalName = totalName;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getAddTime() {
        return addTime;
    }

    public void setAddTime(Date addTime) {
        this.addTime = addTime;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Deliver() {
    }

    public Deliver(String deliverName, String phone, String deliverPassWord, String sex, Integer totalName, Integer status, String role, Date addTime, Timestamp updateTime) {
        this.deliverName = deliverName;
        this.phone = phone;
        this.deliverPassWord = deliverPassWord;
        this.sex = sex;
        this.totalName = totalName;
        this.status = status;
        this.role = role;
        this.addTime = addTime;
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Deliver{" +
                "id=" + id +
                ", deliverName='" + deliverName + '\'' +
                ", phone='" + phone + '\'' +
                ", deliverPassWord='" + deliverPassWord + '\'' +
                ", sex='" + sex + '\'' +
                ", totalName=" + totalName +
                ", status=" + status +
                ", role='" + role + '\'' +
                ", addTime=" + addTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
