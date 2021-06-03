<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>确认订单</title>
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
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/order-style.css"/>

</head>

<body class="animated fadeIn">

<jsp:include page="head.jsp">
    <jsp:param name="num" value="4"/>
</jsp:include>

<div class="container" style="margin-top:100px;margin-left: 350px">
    <div class="row">
        <div class="col-sm-6">
            <div class="page-header" style="margin-bottom: 0px;">
                <h3>基本资料
                    <button style="float: right;" class="btn btn-primary user_edit_btn" id="user_center_update_btn">编辑
                    </button>
                </h3>
            </div>
        </div>
    </div>
</div>
<div class="container" style="margin-left: 350px">
    <form class="form-horizontal">
        <div class="form-group">
            <label for="get_userName" class="col-sm-2 control-label">用户名:</label>
            <div class="col-sm-3">
                <input type="hidden" id="hiddenId" value="${user.id}">
                <input type="text" class="form-control" id="get_userName" placeholder="用户名" readonly="readonly"
                       value="${user.userName}">
            </div>
        </div>
        <div class="form-group">
            <label for="get_trueName" class="col-md-2  col-sm-2 control-label">真实姓名:</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="get_trueName" placeholder="真实姓名" value="${user.trueName}"
                       readonly>
            </div>
        </div>
        <div class="form-group">
            <label for="get_phone" class="col-md-2  col-sm-2 control-label">联系电话:</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="get_phone" placeholder="联系电话" value="${user.phone}"
                       readonly>
            </div>
        </div>
        <div class="form-group">
            <label for="get_address" class="col-md-2   col-sm-2  control-label">联系地址:</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="get_address" placeholder="详细地址" value="${user.address}"
                       readonly>
            </div>
        </div>
    </form>
</div>

<%-- 用户编辑信息模态框 --%>
<div class="modal fade" id="user_center_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="confirmModalLabel">  <%-- 模态框（Modal）标题 --%>
                    个人信息修改
                </h4>
            </div>
            <div class="modal-body user-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="frmModifyCustomer">
                    <div class="form-group">
                        <label for="update_userName" class="col-sm-4 control-label">用户名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_userName" name="userName" readonly
                                   value="${user.userName}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_trueName" class="col-sm-4 control-label">真实姓名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_trueName" name="trueName"
                                   value="${user.trueName}" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_phone" class="col-sm-4 control-label">联系电话</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_phone" name="phone"
                                   value="${user.phone}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_address" class="col-sm-4 control-label">联系地址</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_address" name="address"
                                   value="${user.address}">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="userId" id="userId" value="${user.id}">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">
                            关闭
                        </button>
                        <button type="submit" class="btn btn-primary" id="user_center_confirm_btn">
                            确认
                        </button>
                    </div>
                </form>
            </div>

        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<script>

    // 获取用户对应编辑id的信息，显示在编辑模态框中
    /* $(function (){
         var id = $("#user_center_update_modal .modal-footer input[type='hidden']").val();
         alert(id);
         console.log("id = " + id);
         console.log("id1 = " + "${user.id}");
        $.ajax({
            url: "${APP_PATH}/user/users/" + id,
            type: "GET",
            success: function (result) {
                // 用户数据
                var userData = result.extend.user;
                $("#get_userName").text(userData.userName);
                $("#get_trueName").text(userData.trueName);
                $("#get_phone").text(userData.phone);
                $("#get_address").text(userData.address);

                $("#update_userName").text(userData.userName);
                $("#update_trueName").val(userData.trueName);
                $("#update_phone").val(userData.phone);
                $("#update_address").val(userData.address);
            }
        });
    })*/

    // 编辑信息校验框
    $(function (){
        $("#frmModifyCustomer").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                phone: {
                    validators: {
                        notEmpty: {
                            message: '手机号码不能为空'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                },
                address: {
                    validators: {
                        notEmpty: {
                            message: '地址不能为空'
                        }
                    }
                }
            }
        });
    });

    /**
     * 打开用户编辑的模态框
     */
    $(document).on("click", ".user_edit_btn", function () {
        $("#user_center_update_modal").modal({
            backdrop: "static"
        });
    });

    // 用户编辑信息更新
    $("#user_center_confirm_btn").click(function () {
        var id = $("#userId").val();
        console.log("id = " + id);
        $.ajax({
            url: "${APP_PATH}/user/users/updateCenter",
            type: "POST",
            //data: $(".user-modal-body form").serialize(),
            data: {
                "userId" : id,
                "userName" : $("#update_userName").val(),
                "phone" : $("#update_phone").val(),
                "address" : $("#update_address").val(),
            },
            success: function (result) {
                if (result.code == 200) {
                    layer.msg("编辑成功", {
                        time: 1000,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                    layer.msg("编辑失败", {
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
