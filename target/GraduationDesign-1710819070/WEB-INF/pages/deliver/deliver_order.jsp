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

        .list2 {
            cursor: pointer;
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
        .cr{
            text-align: center;
        }
    </style>


</head>

<body >

<!-- 导航栏  -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="2"/>
</jsp:include>


<div class="container" style="margin-top: 50px;">
    <div class="row">
        <div class="col-sm-12">
            <div class="page-header" style="margin-top: 30px;">
                <h3>订单大厅</h3>
            </div>
        </div>
    </div>
    <div class="row cr">
        <div class="col-sm-3" style="background: #f7f7f7">
            <ul class="list-group">
                <li class="list-group-item" style=""><b><span style="color: #1E90FF;">全部订单</span></b>
                    <ul class="list-group second" style="margin-top: 10px">
                        <li class="list-group-item list2 ${activeSet}" onclick="deliverGetOrder()">
                            <span class="badge" style="color: #f0ad4e">${ManyDeliverOrderNumber.get("notToStart")}</span>
                            已接单
                        </li>
                        <li class="list-group-item list2 ${activeSet1}" onclick="deliverToReceiver()">
                            <span class="badge" style="color: #f0ad4e">${ManyDeliverOrderNumber.get("inDelivery")}</span>
                            配送中
                        </li>
                        <li class="list-group-item list2 ${activeSet2}" onclick="deliverOrderFinished()">
                            <span class="badge" style="color: #f0ad4e">${ManyDeliverOrderNumber.get("deliverFinished")}</span>
                            配送完成
                        </li>
                        <li class="list-group-item list2 ${activeSet3}" onclick="deliverOrderComment()">
                            <span class="badge" style="color: #f0ad4e">${ManyDeliverOrderNumber.get("commentItem")}</span>
                            查看评价
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
        <div class="col-sm-9">
            <table class="table table-hover orderDetail">
                <tr class="text-warning">
                    <th>商品图片</th>
                    <th>名称</th>
                    <th>数量</th>
                    <th>单价</th>
                    <th>实付款（元）</th>
                    <th>操作</th>
                </tr>
                <%-- ${orderVoList.size()}--%>
                <c:forEach items="${orderVoList}" var="orderVo">
                    <%--<c:if test="${orderVo.status == 1} && ${orderVo.status != 5} && ${orderVo.status != 4}">--%>
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
                            <c:if test="${orderVo.comment.commentStatus == 6 || orderVo.comment.commentStatus == 7}">
                                <span>接单时间：<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss"
                                                       value="${orderVo.comment.createTime}"/>
                                </span>
                            </c:if>
                            <c:if test="${orderVo.comment.commentStatus == 8 || orderVo.comment.commentStatus == 9}">
                                <span>送达时间：<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss"
                                                       value="${orderVo.comment.endTime}"/>
                                </span>
                            </c:if>


                            <span class="left" style="padding-left: 10%;">总计: <b><span
                                    style="color: #FF9D00; ">&yen; ${orderVo.price}</span></b>
                            </span>
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
                                    <%-- 5是订单取消 --%>
                                    <c:if test="${orderVo.comment.commentStatus == 6}">
                                        已接单待配送
                                    </c:if>
                                    <c:if test="${orderVo.comment.commentStatus == 7}">
                                        配送中...
                                    </c:if>
                                    <c:if test="${orderVo.comment.commentStatus == 8}">
                                        (配送完成)未评价
                                    </c:if>
                                    <c:if test="${orderVo.comment.commentStatus == 9}">
                                        已评价
                                    </c:if>
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr>
                        <td colspan="7">
                            <div align="left">
                                <c:if test="${orderVo.comment.commentStatus == 6}">
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <button class="btn btn-primary btn-info"
                                                onclick="confirmPickUpToDeliver(${orderVo.id})">
                                            确认已取货前往配送
                                        </button>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.comment.commentStatus == 7}">
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <button class="btn btn-primary btn-info"
                                                onclick="confirmToDeliverFinished(${orderVo.id})">
                                            确认已送达
                                        </button>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.comment.commentStatus == 8}">
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                        <%--<button class="btn btn-primary btn-danger"
                                                onclick="confirmToDeliverDelete(${orderVo.id})">
                                            删除订单
                                        </button>--%>
                                    </span>
                                </c:if>
                                <c:if test="${orderVo.comment.commentStatus == 9}">
                                    <span class="left">
                                        来自用户(
                                            <a href="#"
                                               style="color: #2e82ff; font-weight: bold">${orderVo.comment.userName}</a>
                                        )的评价：
                                        <textarea name="maybeDamage" class="comments" readonly
                                                  oninput="this.style.height=this.scrollHeight + 'px'">
                                                ${orderVo.comment.comment}
                                        </textarea>
                                    </span>
                                    <span class="pull-right">
                                        <!-- 按钮触发模态框 -->
                                       <button class="btn btn-primary btn-danger"
                                               onclick="confirmToDeliverDelete(${orderVo.id})">
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

<script>

    // 评论文本框自适应宽度和长度
    $('textarea').each(function () {
        this.setAttribute('style', 'height:' + (this.scrollHeight) + 'px;');
    })

    // 确认已取货前往配送
    function confirmPickUpToDeliver(pickUpOrderId){
        $.ajax({
            url: "${APP_PATH}/deliver/confirmPickUpToDeliver",
            type: "POST",
            data: {
                "pickUpOrderId" : pickUpOrderId,
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
    }

    // 确认已送达
    function confirmToDeliverFinished(finishedOrderId){
        $.ajax({
            url: "${APP_PATH}/deliver/confirmToDeliverFinished",
            type: "POST",
            data: {
                "finishedOrderId" : finishedOrderId,
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
    }

    // 删除订单
    function confirmToDeliverDelete(deleteOrderId){
        $.ajax({
            url: "${APP_PATH}/deliver/confirmToDeliverDelete",
            type: "POST",
            data: {
                "deleteOrderId" : deleteOrderId,
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
    }

    // 已接单
    function deliverGetOrder() {
        location.href = "${APP_PATH}/deliver/deliverGetOrder";
    }

    // 配送中
    function deliverToReceiver() {
        location.href = "${APP_PATH}/deliver/deliverToReceiver";
    }

    // 配送完成
    function deliverOrderFinished() {
        location.href = "${APP_PATH}/deliver/deliverOrderFinished";
    }

    // 查看评论
    function deliverOrderComment() {
        location.href = "${APP_PATH}/deliver/deliverOrderComment";
    }

</script>

</body>

</html>
