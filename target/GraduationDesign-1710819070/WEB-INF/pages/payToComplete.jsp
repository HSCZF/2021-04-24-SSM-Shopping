<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>支付成功</title>
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
        .toPayFor{
            margin-top: 4%;
        }
    </style>


</head>

<body class="animated fadeIn">
<!-- 导航栏 start -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="9"/>
</jsp:include>

<div class="container apy">
    <div class="row">
        <table class="text-primary table-bordered text-center">
            <tr>
                <th>订单编号：</th>
                <th>${orderNumber}</th>
            </tr>
            <tr>
                <th>交易编号：</th>
                <th>${trade_no}</th>
            </tr>
            <tr>
                <th>商品名称：</th>
                <th>${productName}</th>
            </tr>
            <tr>
                <th>订单价格：</th>
                <th>￥${price}</th>
            </tr>
        </table>
        <button type="button" class="btn btn-primary col-sm-offset-1 col-sm-3 toPayFor" onclick="showOrders()">查看订单
        </button>
        <button type="button" class="btn btn-success col-sm-offset-1 col-sm-3 toPayFor" onclick="goShopping()">继续购物
        </button>
    </div>
</div>

<!--主体内容-->
<%--<div class="container" style="margin-top: 80px">
    <div class="row">
        <div class="col-md-offset-2 col-sm-7">
            <div class="tick">
                <div class="tickimg"></div>
                <p>购买成功</p>
            </div>
            <div align="center">
                <ul style="margin-top: 10px" class="list-group">
                    <li class="list-group-item">
                        <div align="left" style="margin-left: 30px" class="mark">
                            <p>
                                <span class="des-label">订单编号：</span>
                                <span>${orderNumber}</span>
                            </p>
                            <p>
                                <span class="des-label">交易编号：</span>
                                <span>${trade_no}</span>
                            </p>
                            <p>
                                <span class="des-label">商品名称：</span>
                                <span>${productName}</span>
                            </p>
                            <p>
                                <span class="des-label">支付金额：</span>
                                <b><span>${price}</span></b>
                            </p>
                        </div>

                    </li>
                </ul>
                <button type="button" class="btn btn-default col-sm-offset-3 col-sm-3" onclick="showOrders()">查看订单
                </button>
                <button type="button" class="btn btn-success col-sm-offset-1 col-sm-3" onclick="goShopping()">继续购物
                </button>
            </div>
        </div>
    </div>
</div>--%>

<script>

    //  查看订单
    function showOrders() {
        location.href = "${APP_PATH}/order/myOrders";
    }

    // 继续购物
    function goShopping() {
        location.href = "${APP_PATH}/product/searchAllProducts";
    }
</script>


</body>

</html>
