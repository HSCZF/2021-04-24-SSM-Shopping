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
        <h3 class="panel-title">用户管理</h3>
    </div>
    <div class="panel-body">
        <div class="userSearch">
            <form class="form-inline" action="${APP_PATH}/admin/getParamsByUserInput"
                  method="post" id="userSearch">
                <div class="form-group">
                    <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                    <label for="userName_input">用户名:</label>
                    <input type="text" class="form-control" id="userName_input" name="userName" placeholder="请输入用户名"
                           value="${params.userName}" size="15px">
                </div>
                <div class="form-group">
                    <label for="user_trueName">真实姓名:</label>
                    <input type="text" class="form-control" id="user_trueName" name="trueName" placeholder="请输入真实姓名"
                           value="${params.trueName}" size="15px">
                </div>
                <div class="form-group">
                    <label for="user_phone">电话:</label>
                    <input type="text" class="form-control" id="user_phone" name="phone" placeholder="请输入电话"
                           value="${params.phone}" size="15px">
                </div>
                <div class="form-group">
                    <label for="user_address">地址:</label>
                    <input type="text" class="form-control" id="user_address" name="address" placeholder="请输入地址"
                           value="${params.address}">
                </div>
                <input type="submit" value="查询" class="btn btn-primary" id="doSearch" style="margin-left: 1%;">
            </form>
            <button class="btn btn-primary" id="user_add_model_btn">新增</button>
        </div>

        <%-- table --%>
        <div class="show-list text-center" style="position: relative;top: 30px;">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">序号</th>
                    <th class="text-center">用户名</th>
                    <th class="text-center">真实姓名</th>
                    <th class="text-center">手机号</th>
                    <th class="text-center">性别</th>
                    <th class="text-center">用户地址</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${pageInfo.list}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.userName}</td>
                        <td>${user.trueName}</td>
                        <td>${user.phone}</td>
                        <td>${user.sex}</td>
                        <td>${user.address}</td>
                        <td class="text-center">
                            <input type="button" class="btn btn-primary btn-sm doModify"
                                   onclick="updateUser(${user.id})" value="修改">
                            <button class="btn btn-danger btn-sm" onclick="deleteUser(${user.id})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination">

            </ul>
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
                <h4 class="modal-title" style="color: #1E90FF" id="myModalLabel">用户注册</h4>
            </div>
            <form id="adminUserRegister" class="form-horizontal">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="userName_add_input" class="col-sm-3 control-label">登录账号:</label>
                        <div class="col-sm-6">
                            <input id="userName_add_input" class="form-control" type="text" name="userName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="tUserName_add_input" class="col-sm-3 control-label">真实姓名:</label>
                        <div class="col-sm-6">
                            <input id="tUserName_add_input" class="form-control" type="text" name="trueName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password_add_input" class="col-sm-3 control-label">登录密码:</label>
                        <div class="col-sm-6">
                            <input id="password_add_input" class="form-control" type="password" name="passWord">
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
                    <div class="form-group">
                        <label for="address_add_input" class="col-sm-3 control-label">联系地址:</label>
                        <div class="col-sm-6">
                            <input id="address_add_input" class="form-control" type="text" name="address">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" align="center">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">
                        关&nbsp;&nbsp;闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="resetRegisterForm()">重&nbsp;&nbsp;置</button>
                    <button type="button" class="btn btn-primary" onclick="userRegister()">注&nbsp;&nbsp;册</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 删除提示框 --%>
<div class="modal fade" id="adminDeleteUserModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
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
                <input type="hidden" name="adminDeleteUserId" id="adminDeleteUserId">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                </button>
                <button type="button" class="btn btn-primary" id="admin_delete_user_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<%-- 用户编辑信息模态框 --%>
<div class="modal fade" id="adminUpdateUserModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="updateModal">  <%-- 模态框（Modal）标题 --%>
                    信息编辑
                </h4>
            </div>
            <div class="modal-body user-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="admin_update_user_modal">
                    <div class="form-group">
                        <label for="update_userName" class="col-sm-4 control-label">用户名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_userName" name="userName" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_trueName" class="col-sm-4 control-label">真实姓名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_trueName" name="trueName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_phone" class="col-sm-4 control-label">联系电话</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_phone" name="phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_address" class="col-sm-4 control-label">联系地址</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_address" name="address">
                        </div>
                    </div>
                </form>
                <div class="modal-footer">
                    <input type="hidden" name="userId" id="userId" value="${user.id}">
                    <button type="button" class="btn btn-primary" data-dismiss="modal">
                        关闭
                    </button>
                    <button type="submit" class="btn btn-primary" id="admin_update_confirm_btn">
                        确认
                    </button>
                </div>
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
                $("#userSearch").submit();
            }
        });

        //TODO:用户注册数据校验
        $('#adminUserRegister').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userName: {
                    validators: {
                        notEmpty: {
                            message: '用户登录名不能为空'
                        },
                       /* stringLength: {
                            max: 18,
                            message: '长度最多18'
                        },*/
                        regexp: {
                            regexp: "(^[a-zA-Z0-9_-]{1,10}$)|(^[\\u2E80-\\u9FFF]{2,7})",
                            message: "用户名必须是2-7位中文或者1-10位数字和字母的组合"
                        },
                        remote: {
                            type: 'post',
                            delay: 2000,
                            url: '${APP_PATH}/user/checkRegisterUser1'
                        }
                    }
                },
                trueName: {
                    validators: {
                        notEmpty: {
                            message: '真实姓名不能为空'
                        },
                        stringLength: {
                            max: 15,
                            message: '长度最多15'
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
                },
                address: {
                    validators: {
                        notEmpty: {
                            message: '地址不能为空'
                        },
                        stringLength: {
                            max: 50,
                            message: '长度最多50'
                        }
                    }
                },
                passWord: {
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
                            field: 'passWord',
                            message: '两次输入的密码不一致'
                        }
                    }
                }
            }
        });

        //TODO:修改数据校验
        $('#admin_update_user_modal').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                trueName: {
                    validators: {
                        stringLength: {
                            max: 18,
                            message: '长度最多18'
                        },
                        notEmpty: {
                            message: '真实姓名不能为空'
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
                },
                address: {
                    validators: {
                        stringLength: {
                            max: 50,
                            message: '长度最多50'
                        },
                        notEmpty: {
                            message: '地址不能为空'
                        }
                    }
                },
            }
        });

        //清除表单校验信息
        $('#adminUpdateUserModal').on('hide.bs.modal',function () {
            $('#admin_update_user_modal').bootstrapValidator('resetForm');
            $('#admin_update_user_modal')[0].reset();
        });

        //TODO:模糊数据校验
        /*$("#userSearch").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userName: {
                    validators: {
                        stringLength: {
                            max: 18,
                            message: '长度最多18'
                        }
                    }
                },
                trueName: {
                    validators: {
                        stringLength: {
                            max: 18,
                            message: '长度最多18'
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
                },
                address: {
                    validators: {
                        stringLength: {
                            max: 50,
                            message: '长度最多50'
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
        $('#adminUserRegister').bootstrapValidator('resetForm');
        $('#adminUserRegister')[0].reset();
    }

    // 打开注册模态框
    $("#user_add_model_btn").click(function () {
        // 每次添加前都先清除上次的添加数据
        reset_form("#registerModal form");
        // 背景不删除
        $("#registerModal").modal({
            backdrop: "static"
        });
    });

    // 打开删除模态框
    function deleteUser(id) {
        $("#adminDeleteUserId").val(id);
        $("#adminDeleteUserModal").modal({
            backdrop: "static"
        });
    }

    // 修改模态框
    function updateUser(id) {
        $("#userId").val(id);
        getUser(id);
        $("#adminUpdateUserModal").modal({
            backdrop: "static"
        });
    }

    // 修改数据弄上去
    function getUser(id) {
        $.ajax({
            url: "${APP_PATH}/user/users/" + id,
            type: "GET",
            success: function (result) {
                // 用户数据
                var userData = result.extend.user;
                $("#update_userName").val(userData.userName);
                $("#update_phone").val(userData.phone);
                $("#update_trueName").val(userData.trueName);
                $("#update_address").val(userData.address);
            }
        });
    }

    /* 用户注册 */
    function userRegister() {
        $("#adminUserRegister").data("bootstrapValidator").validate();
        var flag = $("#adminUserRegister").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/admin/registerUser",
                type: "POST",
                data: $("#adminUserRegister").serialize(),
                success: function (result) {
                    if (result.code == 200) {
                        layer.msg("新增成功", {
                            time: 1500,
                            skin: "successMsg"
                        }, function () {
                            location.reload();
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
        }else {
            layer.msg("校验失败", {
                time: 1500,
                skin: "errorMsg"
            });
        }
    }

    // 删除用户
    $("#admin_delete_user_btn").click(function () {
        var id = $("#adminDeleteUserId").val();
        $.ajax({
            url: "${APP_PATH}/user/deleteUserById",
            data: "id=" + id,
            type: "POST",
            success: function (result) {
                if (result.code == 200) {
                    $("#adminDeleteUserModal").modal("hide");
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
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
    });

    // 更改用户信息
    $("#admin_update_confirm_btn").click(function () {
        var id = $("#userId").val();
        $("#admin_update_user_modal").data("bootstrapValidator").validate();
        var flag = $("#admin_update_user_modal").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/user/users/adminUpdateCenter",
                type: "PUT",
                data: {
                    "userId": id,
                    "trueName": $("#update_trueName").val(),
                    "phone": $("#update_phone").val(),
                    "address": $("#update_address").val(),
                },
                success: function (result) {
                    if (result.code == 200) {
                        $("#adminUpdateUserModal").modal("hide");
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