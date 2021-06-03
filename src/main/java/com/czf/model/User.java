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

@Data
@AllArgsConstructor
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;

    /* 支持JSR303校验自定义规则 */
    @Pattern(regexp = "(^[a-zA-Z0-9_-]{1,10}$)|(^[\\u2E80-\\u9FFF]{2,7})"
            , message = "用户名必须是2-7位中文或者1-10位数字和字母的组合")
    private String userName;

    /* 支持JSR303校验自定义规则 */
    @Pattern(regexp = "^[1][3,4,5,7,8][0-9]{9}$"
            , message = "手机号码必须是11位数字")
    private String phone;

    private String passWord;
    // 前端验证密码是否一致
    private String confirm_passWord;

    @Pattern(regexp = "[\\u4e00-\\u9fa5]+"
            ,message = "姓名只能是全中文")
    private String trueName;

    private String sex;
    private String address;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getConfirm_passWord() {
        return confirm_passWord;
    }

    public void setConfirm_passWord(String confirm_passWord) {
        this.confirm_passWord = confirm_passWord;
    }

    public String getTrueName() {
        return trueName;
    }

    public void setTrueName(String trueName) {
        this.trueName = trueName;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public User() {
    }

    public User(String userName, String phone, String passWord, String trueName, String sex, String address, String role, Date addTime, Timestamp updateTime) {

        this.userName = userName;
        this.phone = phone;
        this.passWord = passWord;
        this.trueName = trueName;
        this.sex = sex;
        this.address = address;
        this.role = role;
        this.addTime = addTime;
        this.updateTime = updateTime;
    }

    public User(String userName, String phone, String passWord, String trueName, String sex, String address, Integer status, String role, Date addTime, Timestamp updateTime) {
        this.userName = userName;
        this.phone = phone;
        this.passWord = passWord;
        this.trueName = trueName;
        this.sex = sex;
        this.address = address;
        this.status = status;
        this.role = role;
        this.addTime = addTime;
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", userName='" + userName + '\'' +
                ", phone='" + phone + '\'' +
                ", passWord='" + passWord + '\'' +
                ", confirm_passWord='" + confirm_passWord + '\'' +
                ", trueName='" + trueName + '\'' +
                ", sex='" + sex + '\'' +
                ", address='" + address + '\'' +
                ", status=" + status +
                ", role='" + role + '\'' +
                ", addTime=" + addTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
