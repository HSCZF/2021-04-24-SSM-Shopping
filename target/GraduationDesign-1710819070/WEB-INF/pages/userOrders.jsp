<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>我的订单</title>

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
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/order-style.css"/>

    <style>
        body{
            font-family: Arial,"Lucida Grande","Microsoft Yahei","Hiragino Sans GB","Hiragino Sans GB W3",SimSun,"PingFang SC",STHeiti;
            min-width: 1200px;
        }
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:hover,
        .navbar-default .navbar-nav > .active > a:focus{
            background-color: #00FFFF;
            color: #fff!important;
            text-decoration: none;
            border-bottom: 2px solid #00FFFF;
        }
        .navbar-default .navbar-nav > li > a{
            color: black;
            border-bottom: 2px solid white;
        }
        .navbar-default .navbar-nav > li > a:hover{
            color: #1E90FF;
            border-bottom: 2px solid #1E90FF;
        }
        .navbar-nav > li > a{
            line-height: 34px;
        }
        .user-active:hover>img,.user-active:focus>img{
            border: 2px solid #1E90FF;
        }
        .nav .open > a,
        .nav .open > a:hover,
        .nav .open > a:focus{
            border: none!important;
        }
        .dropdown-menu > li > a {
            padding: 10px 24px;
        }
        .dropdown-menu > li > a > i{
            padding-right: 10px;
        }
        .dropdown-menu > li > a:hover, .dropdown-menu > li > a:focus {
            color: #262626;
            text-decoration: none;
            background-color: rgba(204, 204, 204, 0.5);
        }

        .clear-padding .swiper-slide > img{
            /*height: 450px;*/
            width: 100%;
        }
        .btn-warning{
            background-color: #FF7F50;
            color: #fff;
            padding: 6px 35px;

        }
        .article > .art-user{
            display: block;
            width: 25%;
        }
        .art-back img{
            width: 210px;
        }
        .btn-link,.btn-link:hover,.btn-link:active,.btn-link:focus{
            color: #ff7200;
            text-decoration: none;
        }
        .btn-link:hover{
            text-decoration: underline;
        }
        .loading-btn > .btn-default:hover{
            background-color: #f0efee;
            text-decoration: none;
        }
        .page-header{
            margin-bottom:20px !important;
        }
        .page-header h3{
            border-left:5px solid #ff9d00;
            padding-left: 10px;
        }


        .clear-panel:hover .attention{
            border-color: #ec971f;
            cursor: pointer;
            color: #ec971f;
        }
        .clear-panel:hover .attention i{
            color: #ec971f;
            border-color: #ec971f;
        }

        .list-group-item {
            margin-bottom: 0;
            border: 0;
            background-color: inherit;
        }
        .list-group-item li:hover{
            background-color: #00FFFF;
        }

        .list-group-item ul{
            list-style: none;
            margin-left: 50px;
        }
        .list-group-item ul li{
            display: inline;
            line-height: 40px;
            float:left
        }

        .list2 {
            cursor: pointer;
        }

        .table tbody tr td {
            vertical-align: middle;
        }

        .table th {
            text-align: center !important;
        }
        .table th:hover{
           color: #81ccee;
        }

        .table > tbody > tr > th {
            text-align: center;
            border-bottom: 0;
            border-top: 0;
            background: #fafafa url(${APP_PATH}/static/images/bag.gif) repeat-x;
        }

        .table > tbody > tr > td {
            position: relative;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        .table > tbody > tr > td:first-child {
            border-left: 1px solid #ddd;
        }

        .table > tbody > tr > td:last-child {
            border-right: 1px solid #ddd;
        }

        table tr td img {
            width: 60px;
            height: 60px;
        }
        .comments {
            width: 985px;
            float: left;
            color: #FF9D00;
            border: 0;
            background-color:transparent;
            text-indent: -158px;
            resize: none;   /* 文本框不给拉伸 */
            cursor: pointer;
        }
        .myComments {
            min-width: 450px;
            max-width: 450px;
            min-height: 140px;
            max-height: 140px;
        }
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:hover,
        .navbar-default .navbar-nav > .active > a:focus{
            background-color: #00FFFF;
            color: #fff!important;
            text-decoration: none;
            border-bottom: 2px solid #00FFFF;
        }
        .navbar-default .navbar-nav > li > a{
            color: black;
            border-bottom: 2px solid white;
        }
        .navbar-default .navbar-nav > li > a:hover{
            color: #1E90FF;
            border-bottom: 2px solid #1E90FF;
        }
        .navbar-nav > li > a{
            line-height: 34px;
        }
        .img-circle{
            width: 100%;
            background-color: red;
        }
        .logo-style{
            padding: 0px 20px 0px 0px;
            line-height: 34px;
        }
        .page-header h3{
            border-left:5px solid #ff9d00;
            padding-left: 10px;
        }

        .userName{
            height: 66px;
            padding: 15px;
            line-height: 34px;
            color: black;

        }
    </style>


</head>

<body class="animated fadeIn">

<!-- 导航栏  -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="3"/>
</jsp:include>

<div class="container" style="margin-top: 50px">
    <div class="row">
        <div class="col-sm-12">
            <div class="page-header" style="margin-top: 30px;">
                <h3>我的订单</h3>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12" style="background: #00FFFF">
            <ul class="list-group list-group-item" >
                <ul class="list-group second" style="margin-top: 10px">
                    <li class="list-group-item list2"><b><span style="color: blue">全部订单</span></b></li>
                    <li class="list-group-item list2 ${activeSet}" onclick="userOrderNotPay()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("notPay")}</span>
                        待付款
                    </li>
                    <li class="list-group-item list2 ${activeSet1}" onclick="userOrderNotDeliver()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("notDeliver")}</span>
                        待发货
                    </li>
                    <li class="list-group-item list2 ${activeSet2}" onclick="userOrderNotReceiver()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("notReceiver")}</span>
                        待收货
                    </li>
                    <li class="list-group-item list2 ${activeSet3}" onclick="userOrderFinished()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("finished")}</span>
                        评价
                    </li>
                    <li class="list-group-item list2 ${activeSet4}" onclick="userOrderCancel()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("cancelOrder")}</span>
                        已取消
                    </li>
                    <li class="list-group-item list2 ${activeSet5}" onclick="userOrderDelete()">
                        <span class="badge" style="color: #f0ad4e">${ManyOrderNumber.get("deleteOrder")}</span>
                        回收站
                    </li>
                </ul>
            </ul>
        </div>
        <div class="col-sm-12">
            <table class="table table-hover orderDetail">
                <tr class="text-primary" style="background-color: #0e90d2">
                    <th>商品图片</th>
                    <th>名称</th>
                    <th>数量</th>
                    <th>单价</th>
                    <th>实付款（元）</th>
                    <th>交易状态</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${orderVoList}" var="orderVo">
                    <tr>
                        <td colspan="7" style="border: 0">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="7" style="text-align: left;background-color: cornsilk">
                            <span>订单编号：<a class="btn-link" style="text-decoration: none;color: #333333"
                                          href="javascript:void(0)"
                                          onclick="toShowOrderDetails('${orderVo.orderNumber}')">${orderVo.orderNumber}
                            </a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
                            <span>下单时间：<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss"
                                                       value="${orderVo.createDate}"/></span>
                        </td>
                    </tr>
                    <c:forEach items="${orderVo.orderItemList}" var="orderItem">
                        <tr>
                            <td class="col-sm-1">
                                <img src="${orderItem.product.image}" alt="" style="cursor: pointer"
                                     onclick="showProductDetail(${orderItem.product.id})">
                            </td>
                            <td><span style="cursor: pointer"
                                      onclick="showProductDetail(${orderItem.product.id})">${orderItem.product.name}</span>
                            </td>
                            <td><span>${orderItem.num}</span></td>
                            <td><span>&yen; ${orderItem.product.price}</span></td>
                            <td><span>&yen; ${orderItem.price}</span></td>
                            <td>
                                <span>
                                    <c:if test="${orderVo.status == 0}">待支付</c:if>
                                    <c:if test="${orderVo.status == 1}">买家已支付待发货</c:if>
                                    <c:if test="${orderVo.status == 2 and orderVo.comment.commentStatus != 8 }">卖家已发货待收货...</c:if>
                                    <c:if test="${orderVo.status == 2 and orderVo.comment.commentStatus == 8}">
                                        骑手已送达待收货
                                    </c:if>
                                    <c:if test="${orderVo.status == 3}">交易已完成</c:if>
                                    <c:if test="${orderVo.status == 4}">订单已取消</c:if>
                                    <%-- orderVo.status == 5 订单删除，但是不会显示 --%>
                                </span>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="7">
                            <div align="left">
                                <c:if test="${orderVo.status != 3}">
                                    <span class="left">总计: <b><span style="color: #FF9D00;">&yen; ${orderVo.price}</span></b></span>
                                </c:if>
                                <c:if test="${orderVo.status == 0}">  <%-- 待支付 --%>
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <button class="btn btn-primary btn-success"
                                                onclick="aliPayOrders('${orderVo.orderNumber}')">支付订单</button>
                                        <button style="padding: 7px 11px" class="btn btn-primary btn-warning"
                                                onclick="userCancelOrder(${orderVo.id})"> 取消订单 </button>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.status == 1}">  <%-- 买家已支付待发货 --%>
                                    <span class="pull-right">
                                        <%--<button class="btn btn-primary" onclick="remindBusiness()">提醒发货</button>--%>
                                        <%--<p class="btn btn-primary"> 订单状态 </p>--%>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.status == 2}">  <%-- 卖家已发货待收货 --%>
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <button class="btn btn-primary btn-info"
                                                onclick="showConfirmModal(${orderVo.id})">
                                            确认收货
                                        </button>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.status == 3}">   <%-- 交易已完成 --%>
                                    <span class="left">
                                        <c:if test="${orderVo.comment.comment != null}">
                                            <textarea id="maybeDamage" name="maybeDamage" class="comments" readonly
                                                      oninput="this.style.height=this.scrollHeight + 'px'">
                                                    ${orderVo.comment.comment}
                                            </textarea>
                                        </c:if>
                                        <c:if test="${orderVo.comment.comment == null}"><p style="color: red;">暂未评价</p></c:if>
                                    </span>
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                         <button style="padding: 7px 11px" class="btn btn-primary btn-warning"
                                                 onclick="userCommentOrder(${orderVo.id})"> 立即/更新评价 </button>
                                        <button class="btn btn-primary btn-danger"
                                                onclick="userOrderDeleteOrderModal(${orderVo.id})">
                                            删除订单
                                        </button>
                                     </span>
                                </c:if>

                                <c:if test="${orderVo.status == 4}">  <%-- 订单取消 --%>
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <button class="btn btn-primary btn-danger"
                                                onclick="userOrderDeleteOrderModal(${orderVo.id})">
                                            删除订单
                                        </button>
                                     </span>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</div>

<input type="hidden" id="refreshed" value="no">

<!-- 删除订单模态框（Modal） -->
<div class="modal fade" id="deleteOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="deleteModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认要删除该笔订单吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="deleteOrderId" id="deleteOrderId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="user_delete_order_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<!-- 取消订单模态框（Modal） -->
<div class="modal fade" id="cancelOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="cancelModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认取消该笔订单吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="orderId" id="orderId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="user_cancel_order_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<!-- 确认收货模态框（Modal） -->
<div class="modal fade" id="confirmOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="confirmModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认完成收货吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="confirmOrderId" id="confirmOrderId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="user_confirm_order_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<!-- 评价订单模态框（Modal） -->
<div class="modal fade" id="commentOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 500px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="commentModalLabel">  <%-- 模态框（Modal）标题 --%>
                    请在此输入你对此次配送订单的评价
                </h4>
            </div>
            <div class="modal-body" style="width: 500px; height: 160px;">   <%--  在这里添加一些文本 --%>
                <textarea name="newComment" rows="2" cols="20" id="textInput" maxlength="100" class="myComments input"></textarea>
                <p><span id="text-count">0</span>/100</p>
            <%--  --%>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="addCommentId" name="addCommentId">       <%-- Integer addCommentId, String newComment--%>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" id="user_comment_order_btn">
                    提交
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<script>

    // 评论文本框自适应宽度和长度
    $('#maybeDamage').each(function () {
        this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;');
    })

    // 限制文本框字数
    $("#textInput").on("input propertychange", function() {
        var $this = $(this),
            _val = $this.val(),
            count = "";
        if (_val.length > 100) {
            $this.val(_val.substring(0, 100));
        }
        count = 100 - $this.val().length;
        $("#text-count").text(count);
    });


    $(function () {
        //TODO: 刷新页面
        var refresh = document.getElementById("refreshed");
        if (refresh.value == "no") refresh.value = "yes";
        else {
            refresh.value = "no";
            location.reload();
        }
    });

    /* 打开取消订单的模态框，并拿到该订单的id */
    function userCancelOrder(orderId) {
        console.log(orderId);
        $("#orderId").val(orderId);
        // 背景不删除
        $("#cancelOrderModal").modal({
            backdrop: "static"
        });
    }

    /* 打开收货订单的模态框，并拿到该订单的id */
    function showConfirmModal(confirmOrderId) {
        console.log(confirmOrderId);
        $("#confirmOrderId").val(confirmOrderId);
        // 背景不删除
        $("#confirmOrderModal").modal({
            backdrop: "static"
        });
    }

    /* 打开删除订单的模态框，并拿到该订单的id */
    function userOrderDeleteOrderModal(deleteOrderId) {
        console.log(deleteOrderId);
        $("#deleteOrderId").val(deleteOrderId);
        // 背景不删除
        $("#deleteOrderModal").modal({
            backdrop: "static"
        });
    }

    /* 打开评论订单的模态框，并拿到该订单的id */
    function userCommentOrder(commentId){
        $("#addCommentId").val(commentId);  // 给评论复制 订单id
        // 背景不删除
        $("#commentOrderModal").modal({
            backdrop: "static"
        });
    }

    /* 取消订单确认 */
    $("#user_cancel_order_btn").click(function () {
        var orderId = $("#orderId").val();
        console.log("cancelOrder-->#orderId = " + orderId);
        $.ajax({
            url: "${APP_PATH}/order/cancelOrder",
            type: "POST",
            data: {
                "orderId": orderId,
            },
            success: function (result) {
                if (result.code == 200) {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });

    //删除订单
    $("#user_delete_order_btn").click(function () {
        var deleteOrderId = $("#deleteOrderId").val();
        $.ajax({
            url: "${APP_PATH}/order/deleteOrder",
            type: "POST",
            data: {
                "deleteOrderId": deleteOrderId,
            },
            success: function (result) {
                if (result.code == 200) {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });

    //确认收货
    $("#user_confirm_order_btn").click(function () {
        var confirmOrderId = $("#confirmOrderId").val();
        $.ajax({
            url: "${APP_PATH}/order/confirmOrder",
            type: "POST",
            data: {
                "confirmOrderId": confirmOrderId,
            },
            success: function (result) {
                if (result.code == 200) {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });

    // 添加评论 // Integer addCommentId, String newComment
    $("#user_comment_order_btn").click(function (){
        var addCommentId = $("#addCommentId").val();
        var newComment = $("#textInput").val();
        console.log("id = " + addCommentId);
        console.log("内容 = " + newComment);

        $.ajax({
            url: "${APP_PATH}/order/addComment",
            type: "POST",
            data: {
                "addCommentId" : addCommentId,
                "newComment" : newComment,
            },
            success: function (result) {
                if (result.code == 200) {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });





    // 点击订单编号，跳转订单详情页面
    function toShowOrderDetails(orderNo) {
        location.href = "${APP_PATH}/order/toShowOrderDetails?orderNo=" + orderNo;
    }

    //支付订单
    function aliPayOrders(orderNumber) {
        location.href = "${APP_PATH}/order/showPayNowOrders?orderNumber=" + orderNumber;
    }

    // 显示未支付的订单列表
    function userOrderNotPay() {
        location.href = "${APP_PATH}/order/userOrderNotPay";
    }

    //显示未发货的订单列表
    function userOrderNotDeliver() {
        location.href = "${APP_PATH}/order/userOrderNotDeliver";
    }

    //显示待收货的订单列表
    function userOrderNotReceiver() {
        location.href = "${APP_PATH}/order/userOrderNotReceiver";
    }

    //显示已完成交易的订单列表
    function userOrderFinished() {
        location.href = "${APP_PATH}/order/userOrderFinished";
    }

    //显示已取消的订单列表
    function userOrderCancel() {
        location.href = "${APP_PATH}/order/userOrderCancel";
    }

    //显示回收站的订单列表
    function userOrderDelete() {
        location.href = "${APP_PATH}/order/userOrderDelete";
    }

    //展示商品详情
    function showProductDetail(productId) {
        location.href = "${APP_PATH}/product/showProductDetail?id=" + productId;
    }
</script>


</body>

</html>
