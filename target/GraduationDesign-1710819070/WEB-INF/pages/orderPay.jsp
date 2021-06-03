<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>支付订单</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/js/user-modal.js"></script>
    <script src="${APP_PATH}/static/js/area.js"></script>
    <script src="${APP_PATH}/static/js/template.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/order-style.css"/>

    <style>
        .apy{
            width: 500px;
            height: 250px;
            margin-top: 10%;
            text-align: center;
        }
        table{
            width: 400px;
            height: 200px;
        }
        table th{
            text-align: center;
        }
        #toPayFor{
            margin-top: 2%;
        }
    </style>

</head>

<body class="animated fadeIn">

<!-- 导航栏 -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="8"/>
</jsp:include>

<div class="container apy">
    <div class="row">
        <table class="text-primary table-bordered text-center">
            <tr>
                <th>订单编号：</th>
                <th>${order.orderNumber}</th>
            </tr>
            <tr>
                <th>商品名称：</th>
                <th>贺州市果蔬商品</th>
            </tr>
            <tr>
                <th>支付金额：</th>
                <th>￥ ${order.price}</th>
            </tr>
            <tr>
                <th>商品数量：</th>
                <th>${order.productNumber}</th>
            </tr>
        </table>
        <input type="hidden" name="orderNumber" id="orderNumber">
        <button type="button" id="toPayFor" class="btn btn-info col-sm-offset-3 col-sm-3" onclick="aliPay()">支付宝支付</button>
    </div>
</div>

<script>
    $(function () {
        //显示服务端响应的消息
        var orderFailMsg = "${orderFailMsg}";
        if (orderFailMsg != "") {
            layer.msg(orderFailMsg, {
                time: 1500,
                skin: "errorMsg"
            });
        }
    });

    //使用支付宝支付
    function aliPay() {
        location.href = "${APP_PATH}/pay/toAliPay?orderNumber=" + "${order.orderNumber}";
    }

</script>


</body>

</html>
