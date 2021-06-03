<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>配送员登录</title>
        <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
      %>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/js/toastr.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/login/style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/login/reset.css">

    <style>
        #particles-js {
            width: 100%;
            height: 100%;
            position: relative;
            background-image: url(/static/images/login.jpg);
            background-position: 50% 50%;
            background-size: cover;
            background-repeat: no-repeat;
            margin-left: auto;
            margin-right: auto;
        }
        .modal-footer > button {
            margin-left: 7%;
        }
    </style>

<body>

<div id="particles-js">
    <div class="login" style="display: block;">
        <div class="login-top">
            配送员登录
        </div>
        <form id="deliverLogin" class="form-horizontal">
            <div class="login-center clearfix form-group">
                <div class="login-center-img"><img src="${APP_PATH}/static/images/login/name.png"></div>
                <div class="login-center-input">
                    <input type="text" name="deliverName" id="deliverName" value="" placeholder="请输入您的配送账号"
                           onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的配送账号'">
                </div>
            </div>
            <div class="login-center clearfix form-group">
                <div class="login-center-img"><img src="${APP_PATH}/static/images/login/password.png"></div>
                <div class="login-center-input">
                    <input type="password" name="deliverPassWord" id="deliverPassWord" value="" placeholder="请输入您的密码"
                           onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的密码'">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary col-sm-4" id="register_btn">注册</button>
                <button type="button" class="btn btn-primary col-sm-4" id="login_btn">登录</button>
            </div>
        </form>
</div>
<div class="sk-rotating-plane"></div>
<canvas class="particles-js-canvas-el" style="width: 100%; height: 100%;"></canvas>
</div>

<%-- 放在这里才生效 --%>
<script src="${APP_PATH}/static/js/particles.min.js"></script>
<script src="${APP_PATH}/static/js/app.js"></script>
<script type="text/javascript">

    // bootstrapValidator数据校验
    $(function () {
        // 配送员登录
        $("#deliverLogin").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                deliverName: {
                    validators: {
                        notEmpty: {
                            message: '配送账号不能为空'
                        },
                    }
                },
                deliverPassWord: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        },
                    }
                },
            }
        });
    });

    $("#login_btn").click(function (){
        $("#deliverLogin").data("bootstrapValidator").validate();
        var flag = $("#deliverLogin").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/deliver/checkDeliver",
                type: "POST",
                data: $("#deliverLogin").serialize(),
                success: function (result){
                    if(result.code == 200){
                        // 跳转到配送员订单接取大厅
                        window.parent.location = "getAllOrdersByDeliverAndDeliverIndex";
                    }else {
                        toastr.options = {
                            closeButton: false,       // 是否显示关闭按钮（提示框右上角关闭按钮）
                            debug: false,             // 是否为调试；
                            progressBar: true,        // 是否显示进度条（设置关闭的超时时间进度条）
                            positionClass: "toast-center-center",   // 消息框在页面显示的位置 toast-center-center我自定义的
                            onclick: null,            // 点击消息框自定义事件
                            showDuration: "300",      // 显示的动画时间
                            hideDuration: "1000",     // 消失的动画时间
                            timeOut: "2000",          // 自动关闭超时时间
                            extendedTimeOut: "1000",  // 加长展示时间
                            showEasing: "swing",      // 显示时的动画缓冲方式
                            hideEasing: "linear",     // 消失时的动画缓冲方式
                            showMethod: "fadeIn",     // 显示的动画方式
                            hideMethod: "fadeOut"     // 消失的动画方式
                        };
                        toastr.error(result.extend.error);   // 放入数据
                    }
                }
            });
        }
    });

    // 点击注册按钮
    $("#register_btn").click(function () {
        window.parent.location = "toRegisterDeliver";
    });



</script>
</body>
</html>