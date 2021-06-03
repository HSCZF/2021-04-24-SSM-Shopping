package com.czf.config;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.FileWriter;
import java.io.IOException;
import java.util.logging.LogManager;
import java.util.logging.Logger;

/* *
 *类名：AlipayConfig
 *功能：基础配置类
 *详细：设置帐户有关信息及返回路径
 *修改日期：2017-04-05
 *说明：
 *以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 *该代码仅供学习和研究支付宝接口使用，只是提供一个参考。
 */

public class AlipayConfig {
	
//↓↓↓↓↓↓↓↓↓↓请在这里配置您的基本信息↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

    public static Log log = LogFactory.getLog(AlipayConfig.class);

	// 应用ID,您的APPID，收款账号既是您的APPID对应支付宝账号
	public static String app_id = "2021000117635884";
	
	// 商户私钥，您的PKCS8格式RSA2私钥
    public static String merchant_private_key = "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCFQ4gyYZu4X60grgfDqNlB5OJtOJb+EoLb//3ywfxwFnzpQgBWxWgqgJZbuv789NIoLsLB/FpaNh5LXq/+gPKuM1IWtP9iqYTIgGOR9R4JBt1pL2YrZY2xTGhGEapBt7Za8WMu2b//VDY7dRkQE1jp/GtKYz0K7F6REXs/tXrnYnO45S9yK3eefXLO4L/ljPbcBzrOaOvuBRiDEea1fyj3gN9Ntba6BabaqgX25sd5WvvcB+AWRKor/Gy1irrLUc4Ovgd2IoaLBchbWM00fSEa5ohhS6ocDEsaMkfmT+iZ7rpbZxMTJ8gZCoXDcqj6m1fYkgTOxY51UP/2pP+EnjZfAgMBAAECggEAOMyg10BtG7eD1gL3AjkMaJ6Ct6TADoibR+OjPH3b93ZORSlBdbpr/HmUHILmPbCnhkLv9bh2Vi7s2JkCEEqrpP3wxgbdNxMjqkW2qrY72AMaCcQPGv4M133Gj97ln18LFVX/PS/IOq6M8uilBwoIAqr4m9sSYH6Ai/pUesICIW5h3ibQInfi4WcyLyumT1QZi9rF6IuZ9XdGry6x/N3eAZHjQttB9+19aI6AJJzXS66DBmeXnSxDpqbT6bO4lHwiobCOoadT83uETZ+2JWytQ5cLgbhS3EJKVRudKtFj61M/KhE5ob35Xram6K75CKtX2AI3Af9456cdF5eLu8+X8QKBgQDKoMMjNSNX4Ssa3ftcmr7ZLEMJM/s0l1na+UXSq0eYSBQWTh3PFDxzJRux23pc7LJYgGD8v7EgoY3/nXl8glpaVCqLqoZk7QU7H0TMdeh38IR0lo3eFdtU6yefSTmef4A+8IbqwRIsUtmAVRs6zl9v7+eZsFVL8F8ldzIMQZnxZwKBgQCoXYgdCO4Co4D1m8/KjVQdjwbeqLPgjU6lrG1sPJaKgRIHHqOQaALWFNDLWWCq9GyaL1DwxEoCge5jjsqW4Q8Rk1cFQY1JuVrRUY9tXUCV/Yl3eGgQcXIEXgCjll06Mh77dLJayprfZRTJuCfi01Ks+d4SLo4S44ZxzVD94WigSQKBgFyVkjQvHoQT/XccQLMyfcuLfuHgn4KLOWJljbLR0jfRj2QVs2cgLvLJ3Nqql0GIYYEwv6AdEpj/WHuYf58VjKVDWeFRPHE3H7HA+tWVdm//NPZ0qEP2pq4peIQ+mBZE2dtoWa1AJMad4IXT3UpEa7Ug4CkIOiElpsPer76L5wQ3AoGARFyF0dQ4X9XnnNJBEqtDxiS2012Ie9qkXlyeqV4IegBiQ4XLP+0bibU1+fs2ZvOLzSb9JGVu74m2M7Jcy9ph9e7vXHD7Xz3lhCwrompEuSIS2PGIv3RwqRlKBSIehGypa8w8RuUQ8TfnsugVOeI4JYfnBVbl1QGRK1AEXLFTfBECgYAVfVlrUU9sjgURMLKuul7r2skpVQ+Fz5AetHHmgFV5fs5Ef8jJ4gF+jNn/FTGM4/KGZuxz4wHL5fOUuuzJ0skasChSLRS8dwlnMOmQ9eFPaV0sQK3NvSAvC+rFWTrjCnXaPtDEFIJOcfQDsOTTtu7a/8+XoF9F1G49+ia2SiJNjg==";
	
	// 支付宝公钥,查看地址：https://openhome.alipay.com/platform/keyManage.htm 对应APPID下的支付宝公钥。
    public static String alipay_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmqJnMywPTI42zeOvrjQSbBdFkl9sijQ+jewiHkyjzAIVgK+uhDUq0FEQZD9xB8VsGNzcpdBvjv+0VDx2goKBPnLco6nGM9oY33pFS5yjtUIlgxTNX8Nt/Sl9Y9y2puSTdyr0/DF43a/AZbCqvNy9y9YIAibFywq90LPsvYozPHfWroHBLy886X1l4KB+PwHD9Za/lKr/zMK2to9dP6C/qvDpXBKUGmi6rVHn3Ix2X/8YaxR45by5JiNU0kLMsAJFASsaDQLCGgv46HlIHRpZm6AidJuYryvCM1Gj2meb/QtCeL0MsfQb8Q0BxN2305eEeIAgz+Rk72lD4L2zSb3/HwIDAQAB";

	// 服务器异步通知页面路径  需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
    // public static String notify_url = "http://工程公网访问地址/alipay.trade.page.pay-JAVA-UTF-8/notify_url.jsp";
    public static String notify_url = "http://localhost:8080/pay/aliPayNotifyUrl";

	// 页面跳转同步通知页面路径 需http://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
	public static String return_url = "http://localhost:8080/pay/aliPayReturnUrl";

	// 签名方式
	public static String sign_type = "RSA2";
	
	// 字符编码格式
	public static String charset = "utf-8";
	
	// 支付宝网关
	public static String gatewayUrl = "https://openapi.alipaydev.com/gateway.do";

	public static String log_path = "E:\\apy\\";


//↑↑↑↑↑↑↑↑↑↑请在这里配置您的基本信息↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

    /** 
     * 写日志，方便测试（看网站需求，也可以改成把记录存入数据库）
     * @param sWord 要写入日志里的文本内容
     */
   public static void logResult(String sWord) {
        FileWriter writer = null;
        try {
            writer = new FileWriter(log_path + "alipay_log_" + System.currentTimeMillis()+".txt");
            //log.debug(writer);
            writer.write(sWord);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }


}

