package com.czf.controller.Alipay;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.czf.config.AlipayConfig;
import com.czf.model.*;
import com.czf.service.OrderItemService;
import com.czf.service.OrderService;
import com.czf.service.ProductService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * 支付宝接口使用 aliPayNotifyUrl 和 aliPayReturnUrl
 */
@Controller
@RequestMapping("/pay")
public class AlipayController {

    public static Log log = LogFactory.getLog(AlipayController.class);

    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderItemService orderItemService;

    @Autowired
    private ProductService productService;

    /**
     * 调用沙盒支付页面
     * @param orderNumber
     * @param session
     * @return
     */
    @RequestMapping(value = "/toAliPay", produces = "text/html; charset=UTF-8")
    @ResponseBody
    public String toAliPay(String orderNumber, HttpSession session) throws AlipayApiException {
        log.info("我的log info中的 orderNumber = " + orderNumber);
        System.out.println("调用支付宝页面。。。。");
        User user = (User)session.getAttribute("session_user");
        Order order = orderService.findOneOrderByOrderNoAndUserId(orderNumber, user.getId());
        System.out.println("/toAliPay/order = " + order);
        log.info("我的log info中的 order = " + order);
        if (order == null) {
            //用户没有登录，则提示让他登录
            return "订单不存在";  // 回到首页去
        }

        //获得初始化的AlipayClient
        AlipayClient alipayClient = new DefaultAlipayClient(AlipayConfig.gatewayUrl, AlipayConfig.app_id, AlipayConfig.merchant_private_key, "json", AlipayConfig.charset, AlipayConfig.alipay_public_key, AlipayConfig.sign_type);
        log.info("我的log info中的 alipayClient = " + alipayClient);

        //设置请求参数
        AlipayTradePagePayRequest alipayRequest = new AlipayTradePagePayRequest();

        alipayRequest.setReturnUrl(AlipayConfig.return_url);
        log.info("我的log info中的 setReturnUrl后 = " + alipayRequest);
        alipayRequest.setNotifyUrl(AlipayConfig.notify_url);
        log.info("我的log info中的 setNotifyUrl后 = " + alipayRequest);

        System.out.println("订单号："+order.getOrderNumber());
        System.out.println("价格："+order.getPrice());
        System.out.println("数量："+order.getProductNumber());
        log.info("我的log info中的 订单、价格、数量 = " + order.getOrderNumber() +","+order.getPrice()+","+order.getProductNumber());

        // ============支付宝必填项==============
        //商户订单号，商户网站订单系统中唯一订单号，必填
        String out_trade_no = order.getOrderNumber();
        //付款金额，必填
        Double total_amount = order.getPrice();
        //订单名称，必填
        String subject = "贺州市果蔬配送";
        //商品描述，可空
        String body = "用户订购商品个数：" + order.getProductNumber();

        log.info("我的log info中的 支付宝必填项 out_trade_no= " + out_trade_no);
        log.info("我的log info中的 支付宝必填项 total_amount= " + total_amount);
        log.info("我的log info中的 支付宝必填项 subject= " + subject);
        log.info("我的log info中的 支付宝必填项 body= " + body);

        // 该笔订单允许的最晚付款时间，逾期将关闭交易。取值范围：1m～15d。m-分钟，h-小时，d-天，1c-当天（1c-当天的情况下，无论交易何时创建，都在0点关闭）。 该参数数值不接受小数点， 如 1.5h，可转换为 90m。
        String timeout_express = "1c";

        alipayRequest.setBizContent("{\"out_trade_no\":\"" + out_trade_no + "\","
                + "\"total_amount\":\"" + total_amount + "\","
                + "\"subject\":\"" + subject + "\","
                + "\"body\":\"" + body + "\","
                + "\"timeout_express\":\"" + timeout_express + "\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");

        log.info("我的log info中的 支付宝必填项 alipayRequest= " + alipayRequest);

        //请求
        String result = alipayClient.pageExecute(alipayRequest).getBody();
        return result;
    }

    /**
     * 支付宝 同步 通知页面
     * @param request
     * @param response
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "aliPayReturnUrl",method = RequestMethod.GET)
    public ModelAndView aliPayReturnUrl(HttpServletRequest request, HttpServletRequest response, HttpSession session) throws Exception {
        System.out.println("支付成功, 进入同步通知接口...");
        //获取支付宝GET过来反馈信息
        Map<String, String> params = new HashMap<>();
        Map<String, String[]> requestParams = request.getParameterMap();
        for (Iterator<String> items = requestParams.keySet().iterator(); items.hasNext(); ) {
            String name = items.next();
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
            valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
            //System.out.println("parameters = " + params);
        }
        boolean signVerified = false;
        try {
            signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type); //调用SDK验证签名
        } catch (Exception e) {
            System.out.println("SDK验证签名出现异常");
        }
        //支付成功后回调的页面
        ModelAndView mv = new ModelAndView("payToComplete");

        //——请在这里编写您的程序（以下代码仅作参考）——

		/* 实际验证过程建议商户务必添加以下校验：
		1、需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
		2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
		3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
		4、验证app_id是否为该商户本身。
		*/
        if (signVerified) {
            //商户订单号
            String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"), "UTF-8");
            //支付宝交易号
            String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"), "UTF-8");
            //付款金额
            String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"), "UTF-8");

            // 获取用户缓存信息
            User user = (User) session.getAttribute("session_user");
            Order order = orderService.findOneOrderByOrderNoAndUserId(out_trade_no, user.getId());
            if (order == null) {
                //校验一下订单号是够被串改
                ModelAndView mv1 = new ModelAndView("orderPay");        // 此处应该填写支付跳转过来前的页面
                mv1.addObject("orderFailMsg","非法的订单");     //
                return mv1;
            }else{
                // 修改叮当状态，改为 支付成功，已付款; 同时新增支付流水
                orderService.updateOrderStatusByUserId(user.getId(), out_trade_no);

                System.out.println("********************** 支付成功(支付宝同步通知) **********************");
                System.out.println("* 订单号: "  + out_trade_no);
                System.out.println("* 支付宝交易号: " + trade_no);
                System.out.println("* 实付金额: " + total_amount);
                System.out.println("* 购买产品: " + "贺州市果蔬配送");
                System.out.println("***************************************************************");

                // 数量变更 20210422363535858 ，商品数量减少
                //System.out.println(order);
                List<OrderItem> orderItems = orderItemService.findOrderItemsByOrderId(order.getId());
                for (OrderItem item : orderItems) {
                    //System.out.println("item="+item.getNum());
                    int id = item.getProduct().getId();
                    int sum = item.getNum();
                    // 获取数据库商品的数量
                    Product product = productService.findProductById(id);
                    // 商品减少变化
                    int newSum = product.getShopNumber()-sum;
                    if(newSum <= 0){
                        newSum = 0;
                    }
                    productService.updateProductNumber(newSum, id);
                }


                mv.addObject("orderNumber", out_trade_no);
                mv.addObject("trade_no", trade_no);
                mv.addObject("price", total_amount);
                mv.addObject("productName", "贺州市果蔬配送");
                log.info("mv3=" + mv);
            }
        } else {
            System.out.println("支付失败, SDK验签失败...");
            ModelAndView mv3 = new ModelAndView("orderPay");
            mv3.addObject("orderFailMsg","支付失败，SDK验签失败");
            return mv3;
        }

        return mv;
    }

    /**
     * 支付宝 异步 通知页面
     * @param request
     * @param session
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "aliPayNotifyUrl", method = RequestMethod.POST)
    @ResponseBody
    public String aliPayNotifyUrl(HttpServletRequest request,HttpSession session) throws Exception {

        System.out.println("支付成功, 进入异步通知接口...");

        //获取支付宝 POST 过来反馈信息
        Map<String, String> params = new HashMap<>();
        Map<String, String[]> requestParams = request.getParameterMap();
        for (Iterator<String> items = requestParams.keySet().iterator(); items.hasNext(); ) {
            String name = items.next();
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            //乱码解决，这段代码在出现乱码时使用
            //valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
            params.put(name, valueStr);
            System.out.println("参数params = " + params);
        }

        boolean signVerified = AlipaySignature.rsaCheckV1(params, AlipayConfig.alipay_public_key, AlipayConfig.charset, AlipayConfig.sign_type); //调用SDK验证签名

        //——请在这里编写您的程序（以下代码仅作参考）——

		/* 实际验证过程建议商户务必添加以下校验：
		1、需要验证该通知数据中的out_trade_no是否为商户系统中创建的订单号，
		2、判断total_amount是否确实为该订单的实际金额（即商户订单创建时的金额），
		3、校验通知中的seller_id（或者seller_email) 是否为out_trade_no这笔单据的对应的操作方（有的时候，一个商户可能有多个seller_id/seller_email）
		4、验证app_id是否为该商户本身。
		*/
        if (signVerified) {//验证成功
            //商户订单号
            String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"), "UTF-8");

            //支付宝交易号
            String trade_no = new String(request.getParameter("trade_no").getBytes("ISO-8859-1"), "UTF-8");

            //交易状态
            String trade_status = new String(request.getParameter("trade_status").getBytes("ISO-8859-1"), "UTF-8");

            //付款金额
            String total_amount = new String(request.getParameter("total_amount").getBytes("ISO-8859-1"), "UTF-8");

            if (trade_status.equals("TRADE_FINISHED")) {
            } else if (trade_status.equals("TRADE_SUCCESS")) {
                //判断该笔订单是否在商户网站中已经做过处理
                //如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
                //如果有做过处理，不执行商户的业务程序

                //注意：
                //付款完成后，支付宝系统发送该交易状态通知
                System.out.println("out_trade_no: " + out_trade_no);
                System.out.println("trade_no: " + trade_no);
                System.out.println("trade_status: " + trade_status);
                System.out.println("total_amount: " + total_amount);

                // 修改订单状态，改为 支付成功，已付款; 同时新增支付流水
                // 修改叮当状态，改为 支付成功，已付款; 同时新增支付流水
                if (orderService.updateOrderStatusByOrderNo(out_trade_no)) {
                    System.out.println("支付异步通知，订单保存成功");
                }

                System.out.println("********************** 支付成功(支付宝异步通知) **********************");
                System.out.println("* 订单号: "  + out_trade_no);
                System.out.println("* 支付宝交易号: " + trade_no);
                System.out.println("* 实付金额: " + total_amount);
                System.out.println("* 购买产品: " + "贺州市果蔬配送");
                System.out.println("***************************************************************");
                System.out.println("支付成功");
            }
        } else {
            //验证失败,记录日志
            System.out.println(AlipaySignature.getSignCheckContentV1(params));
        }
        return "success";
    }

   /* public static void main(String[] args) {

        AlipayController alipayController = new AlipayController();



    }
*/

}
