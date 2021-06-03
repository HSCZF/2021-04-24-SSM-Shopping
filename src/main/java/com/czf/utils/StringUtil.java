package com.czf.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.UUID;

/**
 * 有些功能本身没有的。文件重命名工具
 */
public class StringUtil {

    public static String reFileName(String fileName) {
        if (fileName == null) {
            fileName = "default.jpg";
        }
        // 取出"."的位置，在拼接
        int dotIndex = fileName.lastIndexOf(".");
        String msg = fileName.substring(dotIndex);
        return new SimpleDateFormat("yyyyMMdddHHmmss").format(new Date())
                + new Random().nextInt(100)
                + msg;
    }

    /**
     * 根据时间生成随机的订单号,唯一
     *
     * @return
     */
    public static String getOrderIdByUUID() {

        Date date = new Date();
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        String newTime = dateFormat.format(date);
        int carry = UUID.randomUUID().toString().hashCode();
        if (carry < 0) {
            carry = -carry;
        }
        //return newTime + String.format("%010d", carry);
        return newTime + carry;
    }


    public static void main(String[] args) {
        String oderId = getOrderIdByUUID();
        System.out.println("StringUtil->唯一订单号：" + oderId);
    }

}
