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

<div class="panel panel-default" style="width: auto;height: 100%">
    <div class="panel-heading">
        <h3 class="panel-title">商品类型管理</h3>
    </div>
    <div class="panel-body">
        <div class="deliverSearch">
            <button class="btn btn-primary" id="admin_add_model_btn" style="margin-left: 2%; text-align: center">
                新增商品类型
            </button>
        </div>

        <%-- table --%>
        <div class="show-list text-center" style="position: relative;top: 30px;">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">编号</th>
                    <th class="text-center">类型名称</th>
                    <th class="text-center">状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                <c:forEach items="${pageInfo.list}" var="productType">
                    <tr>
                        <td>${productType.id}</td>
                        <td>${productType.name}</td>
                        <td>
                            <c:if test="${productType.status == 1}">启用</c:if>
                            <c:if test="${productType.status == 0}">禁用</c:if>
                        </td>
                        <td class="text-center">
                            <input type="button" class="btn btn-primary btn-sm doProTypeModify"
                                   onclick="updateProductType(${productType.id})" value="修改">
                            <input type="button" class="btn btn-danger btn-sm doProTypeDelete"
                                   onclick="deleteModal(${productType.id})" value="删除">
                            <c:if test="${productType.status == 1}">
                                <input type="button" class="btn btn-danger btn-sm doProTypeDisable" value="禁用"
                                       onclick="disableStatus(${productType.id})">
                            </c:if>
                            <c:if test="${productType.status == 0}">
                                <input type="button" class="btn btn-success btn-sm doProTypeDisable" value="启用"
                                       onclick="enableStatus(${productType.id})">
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

<%-- 删除提示框 --%>
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
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
                确认要删除吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="deleteId" id="deleteId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="delete_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<%-- 禁用提示框 --%>
<div class="modal fade" id="disableModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="disableModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认要禁用吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="disableId" id="disableId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="disable_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<%-- 启用提示框 --%>
<div class="modal fade" id="enableModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 250px;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="enableModalLabel">  <%-- 模态框（Modal）标题 --%>
                    提示消息
                </h4>
            </div>
            <div class="modal-body">   <%--  在这里添加一些文本 --%>
                确认要启用吗？
            </div>
            <div class="modal-footer">
                <input type="hidden" name="enableId" id="enableId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="enable_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
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
                    编辑
                </h4>
            </div>
            <div class="modal-body Deliver-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="updateForm">
                    <div class="form-group">
                        <label for="update_name" class="col-sm-4 control-label">类型</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_name" name="name">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="updateId" id="updateId">
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

<%-- 新增模态框 --%>
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="addModalLabel">  <%-- 模态框（Modal）标题 --%>
                    新增
                </h4>
            </div>
            <div class="modal-body Deliver-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="addForm">
                    <div class="form-group">
                        <label for="add_name" class="col-sm-4 control-label">类型</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="add_name" name="name">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <input type="hidden" name="addId" id="addId">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    关闭
                </button>
                <button type="button" class="btn btn-primary" id="add_btn">
                    添加
                </button>
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
        $('#pagination').bootstrapPaginator({
            bootstrapMajorVersion: 3,
            currentPage:${pageInfo.pageNum},
            totalPages:${pageInfo.pages},
            numberOfPages:${pageInfo.pageSize},
            pageUrl: function (type, page, current) {
                return '${APP_PATH}/admin/productType/getAllProductType?pageNum=' + page;
            },
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
            }
        });

        // 编辑
        $('#updateForm').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    validators: {
                        notEmpty: {
                            message: '商品类型不能为空'
                        }
                    }
                }
            }
        });

        // 添加
        $('#addForm').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    validators: {
                        notEmpty: {
                            message: '商品类型不能为空'
                        }
                    }
                }
            }
        });

        //清除表单校验信息
        $('#updateModal').on('hide.bs.modal',function () {
            $('#updateForm').bootstrapValidator('resetForm');
            $('#updateForm')[0].reset();
        });

    });

    //更新模态框
    function updateProductType(id) {
        $("#updateId").val(id);
        getOneProductType(id);
        $("#updateModal").modal({
            backdrop: "static"
        });
    }

    // 删除模态框 deleteProductTypeByAdmin
    function deleteModal(id) {
        $("#deleteId").val(id);
        $("#deleteModal").modal({
            backdrop: "static"
        });
    }

    // 禁用模态框
    function disableStatus(id) {
        $("#disableId").val(id);
        $("#disableModal").modal({
            backdrop: "static"
        });
    }

    // 启用模特框
    function enableStatus(id) {
        $("#enableId").val(id);
        $("#enableModal").modal({
            backdrop: "static"
        });
    }

    // 增加模态框
    $("#admin_add_model_btn").click(function () {
        $("#addModal").modal({
            backdrop: "static"
        });
    })

    // 添加函数
    $("#add_btn").click(function () {
        var name = $("#add_name").val();
        $('#addForm').data('bootstrapValidator').validate();//启用验证
        var flag = $('#addForm').data('bootstrapValidator').isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/admin/productType/insertIntoByAdmin",
                type: "POST",
                data: "name=" + name,
                success: function (result) {
                    if (result.code == 200) {
                        layer.msg("添加成功", {
                            time: 1500,
                            skin: 'successMsg'
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


    });

    // 禁用状态 updateProductTypeStatusByAdmin
    $("#enable_btn").click(function () {
        var id = $("#enableId").val();
        $.ajax({
            url: "${APP_PATH}/admin/productType/updateProductTypeStatusByAdminToDisable",
            data: "id=" + id,
            type: "POST",
            success: function (result) {
                if (result.code == 200) {
                    layer.msg("已启用", {
                        time: 1500,
                        skin: 'successMsg'
                    }, function () {
                        location.reload();
                    });
                } else {
                    // 定义toastr相关数据函数
                    layer.msg("启用失败", {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });

    // 启用状态
    $("#disable_btn").click(function () {
        var id = $("#disableId").val();
        $.ajax({
            url: "${APP_PATH}/admin/productType/updateProductTypeStatusByAdminToEnable",
            data: "id=" + id,
            type: "POST",
            success: function (result) {
                if (result.code == 200) {
                    layer.msg("已禁用", {
                        time: 1500,
                        skin: 'successMsg'
                    }, function () {
                        location.reload();
                    });
                } else {
                    // 定义toastr相关数据函数
                    layer.msg("禁用失败", {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    });

    // 拿数据
    function getOneProductType(id) {
        $.ajax({
            url: "${APP_PATH}/admin/productType/updateProductType",
            type: "GET",
            data: "id=" + id,
            success: function (result) {
                // 用户数据
                var tData = result.extend.productType;
                $("#update_name").val(tData.name);
            }
        });
    }

    // 编辑
    $("#update_btn").click(function () {
        var id = $("#updateId").val();
        var name = $("#update_name").val();
        $('#updateForm').data('bootstrapValidator').validate();//启用验证
        var flag = $('#updateForm').data('bootstrapValidator').isValid()//验证是否通过true/false
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/admin/productType/updateProductTypeByAdmin",
                type: "POST",
                data: {
                    "id": id,
                    "name": name,
                },
                success: function (result) {
                    if (result.code == 200) {
                        $("#adminUpdateDeliverModal").modal("hide");
                        layer.msg("编辑成功", {
                            time: 1500,
                            skin: 'successMsg'
                        }, function () { //回调方法,当弹出框消失后执行
                            //刷新页面重新加载数据，重新查找商品类型类表
                            location.href = '${APP_PATH}/admin/productType/getAllProductType?pageNum=' +${pageInfo.pageNum};
                        });
                    } else {
                        // 定义toastr相关数据函数
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: "errorMsg"
                        });
                    }
                }
            });
        }
    });

    // 删除
    $("#delete_btn").click(function () {
        var id = $("#deleteId").val();
        $.ajax({
            url: "${APP_PATH}/admin/productType/deleteProductTypeByAdmin",
            type: "POST",
            data: {
                "id": id
            },
            success: function (result) {
                if (result.code == 200) {
                    $("#adminUpdateDeliverModal").modal("hide");
                    layer.msg("删除成功", {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    // 定义toastr相关数据函数
                    layer.msg("删除失败", {
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