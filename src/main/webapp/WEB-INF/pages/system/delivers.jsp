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
        <h3 class="panel-title">配送员管理</h3>
    </div>
    <div class="panel-body">
        <div class="deliverSearch">
            <form class="form-inline" action="${APP_PATH}/admin/getParamsByDeliverInput"
                  method="post" id="deliverSearch">
                <div class="form-group">
                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                    <label for="deliverName_input">配送员名:</label>
                    <input type="text" class="form-control" id="deliverName_input" name="deliverName" placeholder="请输入配送员名"
                           value="${params.deliverName}" size="15px">
                </div>
                <div class="form-group">
                    <label for="deliver_phone">电话:</label>
                    <input type="text" class="form-control" id="deliver_phone" name="phone" placeholder="请输入电话"
                           value="${params.phone}" size="15px">
                </div>
                <input type="submit" value="查询" class="btn btn-primary" id="doSearch" style="margin-left: 1%;">
            </form>
            <button class="btn btn-primary" id="deliver_add_model_btn" style="margin-left: 2%; text-align: center">新增</button>
        </div>

        <%-- table --%>
        <div class="show-list text-center" style="position: relative;top: 30px;">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">序号</th>
                    <th class="text-center">配送员名</th>
                    <th class="text-center">手机号</th>
                    <th class="text-center">性别</th>
                    <th class="text-center">订单总数量</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${pageInfo.list}" var="deliver">
                    <tr>
                        <td>${deliver.id}</td>
                        <td>${deliver.deliverName}</td>
                        <td>${deliver.phone}</td>
                        <td>${deliver.sex}</td>
                        <td>${deliver.totalName}</td>
                        <td class="text-center">
                            <input type="button" class="btn btn-primary btn-sm doModify"
                                   onclick="updateDeliver(${deliver.id})" value="修改">
                            <button class="btn btn-danger btn-sm" onclick="deleteDeliver(${deliver.id})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination"></ul>
        </div>
    </div>
</div>

<!-- 注册模态框 -->
<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" style="top: 10%;">
    <div class="modal-dialog" role="document">
        <div class="modal-content" style="width: 80%">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" style="color: #1E90FF" id="myModalLabel">配送员注册</h4>
            </div>
            <form id="adminDeliverRegister" class="form-horizontal">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="DeliverName_add_input" class="col-sm-3 control-label">登录账号:</label>
                        <div class="col-sm-6">
                            <input id="DeliverName_add_input" class="form-control" type="text" name="deliverName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password_add_input" class="col-sm-3 control-label">登录密码:</label>
                        <div class="col-sm-6">
                            <input id="password_add_input" class="form-control" type="password" name="deliverPassWord">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirm_password_add_input" class="col-sm-3 control-label">确认密码:</label>
                        <div class="col-sm-6">
                            <input id="confirm_password_add_input" class="form-control" type="password"
                                   name="confirm_passWord">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password_add_input" class="col-sm-3 control-label">性&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别:</label>
                        <div class="col-sm-6">
                            <label class="radio-inline">
                                <input type="radio" name="sex" id="gender1_add_input" value="男" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="sex" id="gender2_add_input" value="女"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="phone_add_input" class="col-sm-3 control-label">联系电话:</label>
                        <div class="col-sm-6">
                            <input id="phone_add_input" class="form-control" type="text" name="phone">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" align="center">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">
                        关&nbsp;&nbsp;闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="resetRegisterForm()">重&nbsp;&nbsp;置</button>
                    <button type="button" class="btn btn-primary" onclick="deliverRegister()">注&nbsp;&nbsp;册</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 删除提示框 --%>
<div class="modal fade" id="adminDeleteDeliverModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
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
                <input type="hidden" name="adminDeleteDeliverId" id="adminDeleteDeliverId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="admin_delete_deliver_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<%-- 编辑信息模态框 --%>
<div class="modal fade" id="adminUpdateDeliverModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
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
            <div class="modal-body Deliver-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="admin_update_Deliver_modal">
                    <div class="form-group">
                        <label for="update_deliverName_admin" class="col-sm-4 control-label">账号名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_deliverName_admin" name="deliverName" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_phone_admin" class="col-sm-4 control-label">联系电话</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_phone_admin" name="phone" >
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="DeliverId" id="updateDeliverId">
                        <button type="button" class="btn btn-default" data-dismiss="modal">
                            关闭
                        </button>
                        <button type="submit" class="btn btn-primary" id="update_admin_btn">
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
                $("#deliverSearch").submit();
            }
        });

        //TODO:注册数据校验
        $('#adminDeliverRegister').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                deliverName: {
                    validators: {
                        notEmpty: {
                            message: '配送员账号名不能为空'
                        },
                        regexp: {
                            regexp: /^[\u4e00-\u9fa5]{1,7}$|^[\a-zA-Z0-9]{1,14}$/,
                            message: '中英文均可，最长14个英文或者7个汉字'
                        },
                        remote: {
                            type: 'post',
                            delay: 2000,
                            url: '${APP_PATH}/deliver/checkDeliverName'
                        }
                    }
                },
                deliverPassWord: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        },
                        stringLength: {
                            min: 6,
                            max: 18,
                            message: '密码长度必须大于6位或小于18位'
                        }
                    }
                },
                confirm_passWord: {
                    validators: {
                        notEmpty: {
                            message: '确认密码不能为空'
                        },
                        identical: {
                            field: 'deliverPassWord',
                            message: '两次输入的密码不一致'
                        }
                    }
                },
                phone: {
                    validators: {
                        notEmpty: {
                            message: '请输入手机号'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                }
            }
        });

        //TODO:修改数据校验
        $('#admin_update_Deliver_modal').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                phone: {
                    validators: {
                        notEmpty: {
                            message: '请输入手机号'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                }
            }
        });

        //清除表单校验信息
        $('#adminUpdateDeliverModal').on('hide.bs.modal',function () {
            $('#admin_update_Deliver_modal').bootstrapValidator('resetForm');
            $('#admin_update_Deliver_modal')[0].reset();
        });

        //TODO:模糊数据校验
        /*$('#deliverSearch').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                deliverName: {
                    validators: {
                        stringLength: {
                            max: 14,
                            message: "长度不超过14"
                        }
                    }
                },
                phone: {
                    validators: {
                        regexp: {
                            regexp: '^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                }
            }
        });*/
    });

    /* 清除表单样式 */
    function reset_form(ele) {
        $(ele)[0].reset();
        // 清除表单样式
        $(ele).bootstrapValidator("resetForm");
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    /* 注册重置按钮，清空表单数据 */
    function resetRegisterForm() {
        $('#adminDeliverRegister').bootstrapValidator('resetForm');
        $('#adminDeliverRegister')[0].reset();
    }

    // 打开注册模态框
    $("#deliver_add_model_btn").click(function () {
        // 每次添加前都先清除上次的添加数据
        reset_form("#registerModal form");
        // 背景不删除
        $("#registerModal").modal({
            backdrop: "static"
        });
    });

    // 删除模态框
    function deleteDeliver(id){
        $("#adminDeleteDeliverId").val(id);
        $("#adminDeleteDeliverModal").modal({
            backdrop: "static"
        });
    }

    // 更新模态框
    function updateDeliver(id){
        $("#updateDeliverId").val(id);
        getOneDeliver(id);
        $("#adminUpdateDeliverModal").modal({
            backdrop: "static"
        });
    }

    // 修改数据弄上去
    function getOneDeliver(id) {
        $.ajax({
            url: "${APP_PATH}/admin/delivers/" + id,
            type: "GET",
            success: function (result) {
                // 用户数据
                var tData = result.extend.deliver;
                $("#update_deliverName_admin").val(tData.deliverName);
                $("#update_phone_admin").val(tData.phone);
            }
        });
    }

    // 注册
    function deliverRegister() {
        $("#adminDeliverRegister").data("bootstrapValidator").validate();
        var flag = $("#adminDeliverRegister").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/deliver/registerDeliver",
                type: "POST",
                data: $("#adminDeliverRegister").serialize(),
                success: function (result) {
                    if (result.code == 200) {
                        layer.msg("新增成功", {
                            time: 1500,
                            skin: "successMsg"
                        });
                        $("#registerModal").modal("hide");
                    } else {
                        layer.msg("注册失败", {
                            time: 1500,
                            skin: "errorMsg"
                        });
                    }
                }
            });
        }
    }

    // 删除
    $("#admin_delete_deliver_btn").click(function (){
        var id = $("#adminDeleteDeliverId").val();
        $.ajax({
            url: "${APP_PATH}/admin/delivers/" + id,
            type: "DELETE",
            success: function (result) {
                if (result.code == 200) {
                    $("#adminDeleteDeliverModal").modal("hide");
                    layer.msg("删除成功", {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg("删除失败", {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });

    });

    // 更改信息
    $("#update_admin_btn").click(function () {
        var id = $("#updateDeliverId").val();
        var phone = $("#update_phone_admin").val();
        $("#admin_update_Deliver_modal").data("bootstrapValidator").validate();
        var flag = $("#admin_update_Deliver_modal").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/admin/updateDeliverByAdmin",
                type: "POST",
                data: {
                    "id" : id,
                    "phone" : phone,
                },
                success: function (result) {
                    if (result.code == 200) {
                        $("#adminUpdateDeliverModal").modal("hide");
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
            });
        }

    });

</script>
</body>

</html>