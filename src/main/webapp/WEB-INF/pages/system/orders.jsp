<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>果蔬配送后台首页</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/layer/layer.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/bootstrap-paginator.js"></script>
    <script src="${APP_PATH}/static/js/template.js"></script>
    <script src="${APP_PATH}/static/js/toastr.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/sweetalert.css"/>

</head>

<body>

<%--  模糊查询功能已经实现--%>
<div class="panel panel-default" style="width: auto;height: 100%">
    <div class="panel-heading">
        <h3 class="panel-title">订单管理</h3>
    </div>
    <div class="panel-body">
        <div class="orderSearch">
            <form class="form-inline" action="${APP_PATH}/admin/order/getParamsByOrderInput"
                  method="post" id="orderSearch">
                <div class="form-group">
                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                    <label for="orderName_input">订单编号:</label>
                    <input type="text" class="form-control" id="orderName_input" name="orderNumber" placeholder="请输入订单编号"
                           value="${params.orderNumber}" size="15px">
                </div>
                <input type="submit" value="查询" class="btn btn-primary" id="doSearch" style="margin-left: 1%;">
            </form>

        </div>

        <%-- table --%>
        <div class="show-list text-center" style="position: relative;top: 30px;">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">订单序号</th>
                    <th class="text-center">订单编号</th>
                    <th class="text-center">订单用户</th>
                    <th class="text-center">订单总数量</th>
                    <th class="text-center">订单总付款</th>
                    <th class="text-center">订单地址</th>
                    <th class="text-center">订单状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${pageInfo.list}" var="order">
                    <tr>
                        <td>${order.id}</td>
                        <td>${order.orderNumber}</td>
                        <td>${order.user.getUserName()}</td>
                        <td>${order.productNumber}</td>
                        <td>${order.price}</td>
                        <td>${order.address}</td>
                        <td>
                            <c:if test="${order.status == 0}">待支付</c:if>
                            <c:if test="${order.status == 1}">已支付待发货</c:if>
                            <c:if test="${order.status == 2 && order.comment.commentStatus == 6}">已发货待收货</c:if>
                            <c:if test="${order.status == 2 && order.comment.commentStatus == 7}">取货中</c:if>
                            <c:if test="${order.status == 2 && order.comment.commentStatus == 8}">已送达待收货</c:if>
                            <c:if test="${order.status == 3}">交易完成</c:if>
                            <c:if test="${order.status == 4}">订单已取消</c:if>
                            <c:if test="${order.status == 5}">用户已删除该订单</c:if>
                        </td>
                        <td class="text-center">
                            <c:if test="${order.status == 0 || order.status == 1 || order.status == 2 && (order.comment.commentStatus == 6 || order.comment.commentStatus == 7) }">
                                <input type="button" class="btn btn-primary btn-sm doModify"
                                       onclick="updateOrder(${order.id})" value="修改">
                            </c:if>
                            <%--<c:if test="${order.comment.commentStatus == 6 || order.comment.commentStatus == 7 || order.status == 0 || order.status == 1 }">
                                <input type="button" class="btn btn-primary btn-sm doModify"
                                       onclick="updateOrder(${order.id})" value="修改">
                            </c:if>--%>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination"></ul>
        </div>
    </div>
</div>

<%-- 编辑信息模态框 --%>
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="confirmModalLabel">  <%-- 模态框（Modal）标题 --%>
                    信息编辑
                </h4>
            </div>
            <div class="modal-body user-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="update_modal">
                    <div class="form-group">
                        <label for="torderNumber" class="col-sm-4 control-label">订单编号</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="torderNumber" name="orderNumber" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tuserName" class="col-sm-4 control-label">用户</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tuserName" name="userName" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tprice" class="col-sm-4 control-label">总价格</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tprice" name="price" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tproductNumber" class="col-sm-4 control-label">订单总数量</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tproductNumber" name="productNumber" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="taddress" class="col-sm-4 control-label">订单地址</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="taddress" name="address" >
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="updateId" id="updateId" value="${order.id}">
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            关闭
                        </button>
                        <button type="submit" class="btn btn-primary" id="update_btn">
                            确认
                        </button>
                    </div>
                </form>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>


<%-- js --%>
<script>

    $(function () {
        /*bootstrapMajorVersio:
       搭配使用的bootstrap版本，
       如果bootstrap的版本是2.X的分页必须使用div元素。 3.X分页的必须使用ul>li元素。
       注意与bootstrap版本对应上。*/
        $("#pagination").bootstrapPaginator({
            bootstrapMajorVersion: 3,
            currentPage: ${pageInfo.pageNum},   // 设置当前页。
            totalPages: ${pageInfo.pages},      // 设置总页数。
            numberOfPages: ${pageInfo.pageSize}, // 设置控件显示的页码数。即：类型为“page”的操作按钮数量。
            itemTexts: function (type, page, current) {
                switch (type) {
                    case 'first':
                        return '首页';
                    case 'prev':
                        return '上一页';
                    case 'next':
                        return '下一页';
                    case 'last':
                        return '末页';
                    case 'page':
                        return page;
                }
            }, onPageClicked: function (event, originalEvent, type, page) {
                $("#pageNum").val(page);
                $("#orderSearch").submit();
            }
        });
        /*orderSearch*/
        //TODO: 修改数据校验
        $('#update_modal').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                address: {
                    validators: {
                        notEmpty: {
                            message: '地址不能为空'
                        },
                        stringLength:{
                            max: 50,
                            message: "长度不超过50"
                        }
                    }
                }
            }
        });

        //清除表单校验信息
        $('#updateModal').on('hide.bs.modal',function () {
            $('#update_modal').bootstrapValidator('resetForm');
            $('#update_modal')[0].reset();
        });

        //TODO: 模糊数据校验
        /*$('#orderSearch').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                orderNumber: {
                    validators: {
                        digits: {
                            message: '该值只能包含数字'
                        },
                        stringLength:{
                            max: 30,
                            message: "长度不超过30"
                        }
                    }
                }
            }
        });*/

    });

    // 修改模态框
    function updateOrder(id){
        $("#updateId").val(id);
        getOrderById(id);
        $("#updateModal").modal({
            backdrop: "static"
        });
    }

    // 获取编辑信息
    function getOrderById(id){
        $.ajax({
            url: "${APP_PATH}/admin/order/getOneOrderById",
            type: "GET",
            data: "id=" + id,
            success: function (result){
                if (result.code == 200){
                    var orderData = result.extend.order;
                    $("#torderNumber").val(orderData.orderNumber);
                    $("#tuserName").val(orderData.user.userName);
                    $("#tprice").val(orderData.price);
                    $("#tproductNumber").val(orderData.productNumber);
                    $("#taddress").val(orderData.address);
                }
            }
        })
    }

    // 更新
    $("#update_btn").click(function (){
        var address = $("#taddress").val();
        var id = $("#updateId").val();
        $("#update_modal").data("bootstrapValidator").validate();
        var flag = $("#update_modal").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/admin/order/updateOrderByAdmin",
                type: "GET",
                data: {
                    "id" : id,
                    "address" : address
                },
                success: function (result){
                    if (result.code == 200) {
                        $("#updateModal").modal("hide");
                        layer.msg("编辑成功", {
                            time: 1500,
                            skin: "successMsg"
                        }, function () {
                            location.reload();
                        });
                    } else {
                        // 定义toastr相关数据函数
                        layer.msg("编辑失败", {
                            time: 1500,
                            skin: "errorMsg"
                        });
                    }
                }
            })
        }

    })


</script>
</body>

</html>