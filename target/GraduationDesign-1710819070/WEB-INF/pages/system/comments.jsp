<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>配送订单管理</title>
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
        <h3 class="panel-title">配送管理</h3>
    </div>
    <div class="panel-body">
        <div class="commentSearch">
            <form class="form-inline" action="${APP_PATH}/admin/comment/getParamsByCommentInput"
                  method="post" id="commentSearch">
                <div class="form-group">
                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                    <label for="commentName_input">订单编号:</label>
                    <input type="text" class="form-control" id="commentName_input" name="orderNumber"
                           placeholder="请输入订单编号"
                           value="${params.orderNumber}" size="15px">
                </div>
                <div class="form-group">
                    <label for="comment_phone">订单用户:</label>
                    <input type="text" class="form-control" id="comment_phone" name="userName" placeholder="请输入订单用户"
                           value="${params.userName}" size="15px">
                </div>
                <div class="form-group">
                    <label for="comment_phone1">配送人员(已接单):</label>
                    <input type="text" class="form-control" id="comment_phone1" name="deliverName" placeholder="请输入配送员名"
                           value="${params.deliverName}" size="15px">
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
                    <th class="text-center">用户手机号</th>
                    <th class="text-center">配送地址</th>
                    <th class="text-center">配送详情</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                ${comment.commentStatus}
                <c:forEach items="${pageInfo.list}" var="comment">
                    <tr>
                        <td>${comment.id}</td>
                        <td>${comment.orderNumber}</td>
                        <td>${comment.userName}</td>
                        <td>${comment.userPhone}</td>
                        <td>${comment.userAddress}</td>
                        <td>
                            <c:if test="${comment.commentStatus == 6}">
                                <a href="#" style="color: black">${comment.deliverName}</a>
                                 已接单
                            </c:if>
                            <c:if test="${comment.commentStatus == 7}">
                                <a href="#" style="color: black">${comment.deliverName}</a>
                                配送中
                            </c:if>
                            <c:if test="${comment.commentStatus == 8}">
                                <a href="#" style="color: black">${comment.deliverName}</a>
                                配送完成
                            </c:if>
                            <c:if test="${comment.commentStatus == 9}">
                                <a href="#" style="color: black">${comment.deliverName}</a>
                                配送完成
                            </c:if>
                            <c:if test="${comment.commentStatus == 10}">
                                <a href="#" style="color: black">${comment.deliverName}</a>
                                已删除完成订单
                            </c:if>
                        </td>
                        <td class="text-center">
                            <c:if test="${comment.commentStatus != 8 && comment.commentStatus != 9 && comment.commentStatus != 10}">
                                <input type="button" class="btn btn-primary btn-sm doModify"
                                       onclick="updateComment(${comment.id})" value="修改">
                            </c:if>
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
                        <label for="tuserName" class="col-sm-4 control-label">订单用户</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tuserName" name="userName" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tuserPhone" class="col-sm-4 control-label">用户手机号</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tuserPhone" name="userPhone" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tuserAddress" class="col-sm-4 control-label">配送地址</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="tuserAddress" name="userAddress" >
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="updateId" id="updateId" value="${comment.id}">
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
                $("#commentSearch").submit();
            }
        });

        //TODO: 修改数据校验
        $('#update_modal').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userAddress: {
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
        /*$('#commentSearch').bootstrapValidator({
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
                },
                userName: {
                    validators: {
                        stringLength:{
                            max: 18,
                            message: "长度不超过18"
                        }
                    }
                },
                deliverName: {
                    validators: {
                        stringLength:{
                            max: 14,
                            message: "长度不超过14"
                        }
                    }
                }
            }
        });*/

    });

    function updateComment(id){
        $("#updateId").val(id);
        getCommentId(id);
        $("#updateModal").modal({
            backdrop: "static"
        });
    }

    function getCommentId(id){
        $.ajax({
            url: "${APP_PATH}/admin/comment/getOneCommentById",
            type: "GET",
            data: "id=" + id,
            success: function (result){
                if (result.code == 200){
                    var orderData = result.extend.comment;
                    $("#torderNumber").val(orderData.orderNumber);
                    $("#tuserName").val(orderData.userName);
                    $("#tuserPhone").val(orderData.userPhone);
                    $("#tuserAddress").val(orderData.userAddress);

                }
            }
        })
    }

    $("#update_btn").click(function (){
        var address = $("#tuserAddress").val();
        var id = $("#updateId").val();
        $("#update_modal").data("bootstrapValidator").validate();
        var flag = $("#update_modal").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/admin/comment/updateComment",
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