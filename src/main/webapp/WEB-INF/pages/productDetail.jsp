<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>商品购买页面</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/front-shop.js"></script>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">


    <style>
        .left-detail{
            width: 500px;
            height: 450px;
            float: left;
        }
        .right-detail{
            width: 500px;
            height: 500px;
            padding-left: 100px;
        }
    </style>

</head>
<body class="animated fadeIn">
<!-- 导航栏  -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="5"/>
</jsp:include>

<div class="row" style="margin-top: 50px">
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <div class="page-header" style="margin-bottom: 0px;">
                    <h3 style="color: #48900F">商品购买</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="col-sm-6 left-detail" style="padding: 0">
            <div class="imgShow">
                <img style="width: 400px;height: 400px" src="${product.image}" alt="">
            </div>
        </div>
        <div class="col-sm-6 right-detail">
            <span class="title">${product.name}</span>
            <div class="pic">
                <span style="margin-left: 30px;">价格:</span>
                <span class="priceIcon">￥</span>
                <span class="priceIcon" class="pcc">${product.price}</span>
            </div>
            <div class="cartCount">
                <span style="">购买数量 : </span>
                <input type="button" id="reduce" name="reduce" value="-" disabled="disabled">
                <input class="textBox" id="inputText" name="textBox" type="text" value="1" readonly>
                <input id="add" name="add" type="button" value="+">
                库存(<span class="Hgt" id="numberId" value="">${product.shopNumber}</span>)
                <input type="hidden" id="numberId2" value="${product.shopNumber}">
            </div>

            <div class="shop">
                <div class="btn btn-default cartBtn" onclick="addToCart(${product.id})">加入购物车</div>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        var t = $('#inputText');
        $('#reduce').attr('disabled', true);

        // 增加数量
        $('#add').click(function () {
            var number = $("#numberId2").val();
            var intNum = parseInt(number);
            console.log(number);
            t.val(parseInt(t.val()) + 1);
            if (parseInt(t.val()) != 1 && parseInt(t.val()) <= intNum) {
                $('#reduce').attr('disabled', false);
            }else {
                if(number == 0){
                    t.val(1);
                    layer.msg("商品缺货", {
                        time: 1500,
                        skin: 'warningMsg'
                    });
                    $('#reduce').attr('disabled', true);
                }else {
                    t.val(number);
                    layer.msg("库存不足", {
                        time: 1500,
                        skin: 'warningMsg'
                    });
                    $('#reduce').attr('disabled', false);
                }
            }
        });

        // 减少数量
        $('#reduce').click(function () {
            if(parseInt(t.val()) >= 2){
                t.val(parseInt(t.val()) - 1);
            }
            if (parseInt(t.val()) == 1) {
                $('#reduce').attr('disabled', true);
            }
        });

        // input输入改变  不弄了,不好判断
       /* $("#inputText input[type='text']").on("change", function () {

            //这里的this为 商品数量的输入框
            var number = $("#numberId2").val();
            var sum = parseInt(number);
            console.log("number="+number);
            console.log("sum="+sum);

            var count = parseInt($(this).val());
            if (count != $(this).val() || count > sum) {
                layer.msg("无效的商品数量", {
                    time: 1500,
                    skin: 'warningMsg'
                });
                count = number;
                $(this).val(count);
            }
            $('#reduce').attr('disabled', false);
        });*/


    });

    //添加商品到购物车
    function addToCart(id) {
        var sum = $("#numberId").val();
        console.log(sum);
        $.ajax({
            url: "${pageContext.request.contextPath}/cart/addToCart",
            type: "POST",
            data: {
                "id" : id,
                "textBox" : $("#inputText").val(),
            },
            success: function (result) {
                if (result.code == 200) {
                    //商品成功添加购物车
                    toastr.options = {
                        closeButton: false,       // 是否显示关闭按钮（提示框右上角关闭按钮）
                        debug: false,             // 是否为调试；
                        progressBar: true,        // 是否显示进度条（设置关闭的超时时间进度条）
                        positionClass: "toast-center-center",   // 消息框在页面显示的位置 toast-center-center我自定义的
                        onclick: null,            // 点击消息框自定义事件
                        showDuration: "300",      // 显示的动画时间
                        hideDuration: "1000",     // 消失的动画时间
                        timeOut: "2000",          // 自动关闭超时时间
                        extendedTimeOut: "1000",  // 加长展示时间
                        showEasing: "swing",      // 显示时的动画缓冲方式
                        hideEasing: "linear",     // 消失时的动画缓冲方式
                        showMethod: "fadeIn",     // 显示的动画方式
                        hideMethod: "fadeOut"     // 消失的动画方式
                    };
                    toastr.success("成功添加购物车!");   // 放入数据
                } else {
                    //商品成功添加购物车
                    toastr.options = {
                        closeButton: false,       // 是否显示关闭按钮（提示框右上角关闭按钮）
                        debug: false,             // 是否为调试；
                        progressBar: true,        // 是否显示进度条（设置关闭的超时时间进度条）
                        positionClass: "toast-center-center",   // 消息框在页面显示的位置 toast-center-center我自定义的
                        onclick: null,            // 点击消息框自定义事件
                        showDuration: "300",      // 显示的动画时间
                        hideDuration: "1000",     // 消失的动画时间
                        timeOut: "2000",          // 自动关闭超时时间
                        extendedTimeOut: "1000",  // 加长展示时间
                        showEasing: "swing",      // 显示时的动画缓冲方式
                        hideEasing: "linear",     // 消失时的动画缓冲方式
                        showMethod: "fadeIn",     // 显示的动画方式
                        hideMethod: "fadeOut"     // 消失的动画方式
                    };
                    toastr.error(result.extend.vag);   // 放入数据
                }
            }
        });
    }

    
</script>


</body>
</html>
