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
    <title>配送订单大厅</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/bootstrap-paginator.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/js/template.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">

    <style>
        .table tbody tr td {
            vertical-align: middle;
        }

        .table th {
            text-align: center !important;
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

        .page-header {
            margin-bottom: 20px !important;
        }

        .page-header h3 {
            border-left: 5px solid #ff9d00;
            padding-left: 10px;
        }
    </style>


</head>

<body class="animated fadeIn">

<!-- 导航栏  -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="1"/>
</jsp:include>


<div class="container" style="margin-top: 50px">
    <div class="row">
        <div class="col-sm-12">
            <div class="page-header" style="margin-top: 30px;">
                <h3>订单大厅</h3>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <table class="table table-hover orderDetail">
                <tr class="text-warning">
                    <th>商品图片</th>
                    <th>名称</th>
                    <th>数量</th>
                    <th>单价</th>
                    <th>实付款（元）</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${pageInfo}" var="orderVo">
                    <c:if test="${orderVo.status == 1}">
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
                            </td>
                        </tr>
                    </c:forEach>
                        <tr>
                            <td colspan="7">
                                <div align="left">
                                    <span class="left">总计: <b><span
                                            style="color: #FF9D00;">&yen; ${orderVo.price}</span></b></span>
                                    <span class="pull-right">
                                            <button class="btn btn-primary"
                                                    onclick="DeliverGetOrderModal(${orderVo.customerId}, ${orderVo.id})">
                                                接取订单
                                                <%-- Integer userId , Integer orderId, String orderNumber --%>
                                            </button>
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
            </table>
        </div>
    </div>
</div>

<!-- 接取订单模态框（Modal） -->
<div class="modal fade" id="getOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="getModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认要接取该笔订单吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="getOrderUserId" id="getOrderUserId">
                <input type="hidden" name="getOrderId" id="getOrderId">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消
                </button>
                <button type="button" class="btn btn-primary" id="deliver_get_order_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>


<script>


    /**
     * 传id值给模态框的隐藏id，并打开模态框
     * @param orderId
     * @constructor
     */
    function DeliverGetOrderModal(userId, orderId){
        $("#getOrderUserId").val(userId);
        $("#getOrderId").val(orderId);
        console.log("模态框弹出赋值的值: " + userId + "," +  orderId);
        // 背景不删除
        $("#getOrderModal").modal({
            backdrop: "static"
        });
    }

    /**
     * 接取订单
     */
    $("#deliver_get_order_btn").click(function () {
        // Integer userId , Integer orderId)
        var userId = $("#getOrderUserId").val();
        var orderId = $("#getOrderId").val();
        console.log("接取订单拿到的值: " + userId + "," +  orderId);
        $.ajax({
            url: "${APP_PATH}/deliver/toGetOrderByDeliver",
            type: "POST",
            data: {
                "userId": userId,
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


</script>

</body>

</html>
