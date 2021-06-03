<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>果蔬配送后台首页</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/js/jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="${APP_PATH}/static/js/toastr.js"></script>
    <script src="${APP_PATH}/static/iconfont/icon_font/iconfont.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrap-responsive.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/styles.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/defined-remind.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css"/>

    <style>
        body{
            margin: 0 auto;
            width: 100%;
            height: 100%;
        }
        .top-ul {
            width: 100%;
            height: 83%; /* 头部拿了 10% */
            position: absolute;
        }
        .top-ul ul {
            border: #CCCCCC 1px solid;
        }
        .top-ul ul li {
            padding-left: 20%;
        }
        .top-ul ul li:hover{
            background-color: yellow;
            cursor: pointer;
        }
        .row-set {
            height: 100%;
        }
        .ict {
            color: #33CCFF;
        }
        #adminSet {
            margin: 0 auto;
            padding-left: 0;
            height: 100%;
        }
        footer{
            margin: auto;
            width: 100%;
            height: auto;
            background-color: #33CCFF;
        }
        .cy-foot {
            color: white;
            width: 100%;
            background-color: #33CCFF;
        }

    </style>

</head>
<body>
<%-- 总体内容 = 导航栏 + 左边选择标签 + 内嵌网页iframe --%>

<%-- 引入导航栏 --%>
<jsp:include page="head.jsp">
    <jsp:param name="num" value="1"/>
</jsp:include>
<%-- 主体 --%>
<div class="top-ul">
    <div class="row row-set">
        <div class="col-xs-2" style="padding-right: 0;">
            <ul class="list-group">
                <li class="list-group-item active" name="userController" id="userController">
                    <i class="iconfont ict">&#58917;</i> &nbsp;用户管理
                </li>
                <li class="list-group-item" name="deliverController" id="deliverController">
                    <i class="iconfont ict">&#58880;</i> &nbsp;配送员管理
                </li>
                <li class="list-group-item" name="productTypeController" id="productTypeController">
                    <i class="iconfont ict">&#59056;</i></i> &nbsp;商品类型管理
                </li>
                <li class="list-group-item" name="productController" id="productController">
                    <i class="glyphicon glyphicon-shopping-cart ict"></i> &nbsp;商品管理
                </li>
                <li class="list-group-item" name="orderController" id="orderController">
                    <i class="iconfont ict">&#58909;</i> &nbsp;订单管理
                </li>
                <li class="list-group-item" name="commentController" id="commentController">
                    <i class="iconfont ict">&#58909;</i> &nbsp;配送管理
                </li>
            </ul>
        </div>
        <%-- 引入其他嵌套页面 --%>
        <div class="col-xs-10" id="adminSet">
            <iframe id="switch-frame" src="${APP_PATH}/admin/getAllUser"
                    style="width: 100%; height: 100%; text-align: center;border: #0e0e0e 1px solid;"
                    frameborder="0" scrolling="no">
            </iframe>
        </div>
    </div>
    <!-- 尾部栏 -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="cy-foot">
                    <p class="pull-right">版权所有&nbsp;&nbsp;&nbsp;</p>
                    <p>&copy; Copyright 2021 czf</p>
                </div>
            </div>
        </div>
    </footer>
</div>


<script>
    $(function () {

        /* 选择左边，变颜色 */
        $(".top-ul .row ul li").click(function(){
            $(".top-ul .row ul li").removeClass("active");
            $(this).addClass("active");
            var iframeId = "#"+$(this).attr("name");
            $("#adminSet > div").css({'display':'none'});
            $(iframeId).css({'display':'block'});

        });

        // iframe切换页面
        $("#userController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/getAllUser");
        });
        $("#deliverController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/getAllDeliver");
        });
        $("#productTypeController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/productType/getAllProductType");
        });
        $("#productController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/product/getAllProducts");
        });
        $("#orderController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/order/getAllOrders");
        });
        $("#commentController").click(function () {
            $("#switch-frame").attr("src", "${APP_PATH}/admin/comment/getAllComments");
        });

    });



</script>

</body>


</html>