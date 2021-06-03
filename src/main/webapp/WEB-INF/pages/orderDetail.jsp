<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>订单详情</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">


    <style>
        /*让表格中的数据居中*/
        .table tbody tr td {
            vertical-align: middle;
        }

        .table th {
            text-align: center !important;
        }
    </style>
    <script>
    </script>
</head>

<body class="animated fadeIn">
<!-- 导航栏 start -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="8"/>
</jsp:include>
<!-- 导航栏 end -->

<!-- content start -->
<div class="container" style="margin-top: 50px">
    <c:choose>
        <c:when test="${empty order}">
            <h3 class="text-success" style="text-align: center;margin-top: 200px">
                该订单已删除, <a class="btn-link" href="${APP_PATH}/order/userOrderDelete">前往回收站查看~</a>
            </h3>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:if test="${order.status != 4}">
                    <div class="col-xs-12">
                        <div class="page-header" style="margin-bottom: 0px;">
                            <h3>收货地址</h3>
                        </div>
                        <div class="">
                            <b><span style="letter-spacing: 1px;font-size: 15px; color: #f0ad4e">${order.address}</span></b>
                        </div>
                    </div>
                </c:if>
                <div class="col-xs-12">
                    <div class="page-header" style="margin-bottom: 0px;">
                        <h3>订单详情</h3>
                    </div>
                </div>
            </div>
            <div class="row head-msg">
                <div class="col-xs-12">
                    <span style="font-size: 15px">用户: </span><b><span
                        style="font-size: 14px">${order.user.userName}</span></b>
                    <span style="margin-left: 15px;font-size: 15px">订单号: </span><b><span
                        style="font-size: 14px">${order.orderNumber}</span></b>
                    <span style="margin-left: 15px;font-size: 15px">订单状态:</span>
                    <b>
                <span style="font-size: 14px">
                    <c:if test="${order.status == 0}">待支付</c:if>
                    <c:if test="${order.status == 1}">买家已支付待发货</c:if>
                    <c:if test="${order.status == 2}">卖家已发货待收货</c:if>
                    <c:if test="${order.status == 3}">交易已完成</c:if>
                    <c:if test="${order.status == 4}">订单已取消</c:if>
                </span>
                    </b>
                </div>
            </div>
            <table class="table table-hover table-striped table-bordered text-center" style="margin-top: 5px">
                <tr class="text-success">
                    <th>序号</th>
                    <th>商品名称</th>
                    <th>商品图片</th>
                    <th>商品数量</th>
                    <th>商品总价</th>
                </tr>
                <c:forEach items="${orderItems}" var="orderItem">
                    <tr>
                        <td>${orderItem.id}</td>
                        <td><span style="cursor: pointer" onclick="showProductDetail(${orderItem.product.id})">${orderItem.product.name}</span></td>
                        <td><img src="${orderItem.product.image}" alt="" width="60" height="60" style="cursor: pointer" onclick="showProductDetail(${orderItem.product.id})"></td>
                        <td>${orderItem.num}</td>
                        <td>${orderItem.price}</td>
                    </tr>
                </c:forEach>
                <tr>
                    <td colspan="5" class="foot-msg" align="left">
                    <span>共有 <b><span id="totalCount"
                                      name="totalCount">${order.productNumber}</span></b> 件商品 ,&nbsp;</span>
                        总计：<b> <span>&yen; ${order.price}</span></b> 元
                    </td>
                </tr>
                <tr>
                    <td colspan="5" align="right">
                        <c:if test="${order.status == 0}">
                            <button type="button" class="btn btn-success" onclick="aliPayOrders()">支付订单</button>
                            <button class="btn btn-warning" style="padding: 6px 12px"
                                    onclick="userCancelOrder(${order.id})">取消订单
                            </button>
                        </c:if>
                        <c:if test="${order.status == 1}">
                            <button type="button" class="btn btn-primary" onclick="remindSeller()">提醒发货</button>
                        </c:if>
                        <c:if test="${order.status == 2}">
                            <button class="btn btn-info" onclick="showConfirmModal(${order.id})">确认收货</button>
                        </c:if>
                        <c:if test="${order.status == 3}">
                            <button style="padding: 6px 12px" class="btn btn-danger"
                                    onclick="userOrderDeleteOrderModal(${order.id})">删除订单
                            </button>
                        </c:if>
                        <c:if test="${order.status == 4}">
                            <button style="padding: 6px 12px" class="btn btn-danger"
                                    onclick="userOrderDeleteOrderModal(${order.id})">删除订单
                            </button>
                        </c:if>
                    </td>
                </tr>
            </table>

        </c:otherwise>
    </c:choose>
</div>

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


<script>

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

    //显示提醒卖家发货modal
    function remindSeller() {
        layer.msg("已提醒卖家发货", {
            time: 1500,
            skin: 'warningMsg'
        });
    }

    //支付订单
    function aliPayOrders() {
        location.href = "${APP_PATH}/order/showPayNowOrders?orderNumber=" + "${order.orderNumber}";
    }

    //展示商品详情
    function showProductDetail(productId) {
        location.href = "${APP_PATH}/product/showProductDetail?id=" + productId;
    }
    
</script>

</body>

</html>
