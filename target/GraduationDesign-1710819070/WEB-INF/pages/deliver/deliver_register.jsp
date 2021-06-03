<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>配送员注册</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>


    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/js/toastr.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" >
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/login/style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/login/reset.css">

    <style type="text/css">
        .control-label:after{
            content: "*";
            color: red;
        }
        .modal-footer {
            padding-top: 7%;
            width: 100%;
        }
        .modal-footer > button {
            margin-right: 3%;
        }
        .login{
            margin-top: -20%;
            height: 85%;
        }
        #particles-js{
            width: 100%;
            height: 100%;
            position: relative;
            background-image: url(/static/images/login.jpg);
            background-position: 50% 50%;
            background-size: cover;
            background-repeat: no-repeat;
            margin: 0 auto;
        }
    </style>

</head>
<body>


<div id="particles-js">
    <div class="login" >
        <form id="deliverRegister" class="form-horizontal">
            <div class="login-top" style="margin-top: 10%;">
                配送员注册
            </div>
           <div class="login-center clearfix form-group">
                <label class="col-sm-3 control-label">账号名</label>
                <div class="col-sm-9 login-center-input">
                    <input type="text" name="deliverName" id="deliverName" value="" placeholder="中英文均可，最长14个英文或者7个汉字"
                           onfocus="this.placeholder=''" onblur="this.placeholder='中英文均可，最长14个英文或者7个汉字'">
                </div>
            </div>
            <div class="login-center clearfix form-group">
                <label class="col-sm-3 control-label">密码</label>
                <div class="col-sm-9 login-center-input">
                    <input type="password" name="deliverPassWord" id="deliverPassWord" value="" placeholder="密码长度必须大于6位或小于18位"
                           onfocus="this.placeholder=''" onblur="this.placeholder='密码长度必须大于6位或小于18位'">
                </div>
            </div>
            <div class="login-center clearfix form-group">
                <label class="col-sm-3 control-label">确认密码</label>
                <div class="col-sm-9 login-center-input">
                    <input type="password" name="confirm_passWord" id="confirm_passWord" value="" placeholder="确认密码">
                </div>
            </div>
            <div class="login-center clearfix form-group">
                <label class="col-sm-3 control-label">手机号</label>
                <div class="col-sm-9 login-center-input">
                    <input type="text" name="phone" id="phone" value="" placeholder="请输入您的手机号">
                </div>
            </div>
            <div class="login-center clearfix">
                <label class="col-sm-2 control-label">性别</label>
                <div class="col-sm-9">
                    <label class="radio-inline">
                        <input type="radio" name="sex" id="gender1_add_input" value="男" checked="checked"> 男
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="sex" id="gender2_add_input" value="女"> 女
                    </label>
                </div>
            </div>
            <div style="text-align: center;" class="modal-footer">
                <button type="button" class="btn btn-primary col-sm-4" id="register_btn">注册</button>
                <button type="button" class="btn btn-primary col-sm-4" id="login_btn">登录</button>
            </div>
        </form>
    </div>
</div>


<script type="text/javascript">

    // bootstrapValidator数据校验
    $(function (){
        // 配送员注册
        $("#deliverRegister").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                deliverName: {
                    validators: {
                        notEmpty: {
                            message: '账号不能为空'
                        },
                        regexp: {
                            regexp: /^[\u4e00-\u9fa5]{1,7}$|^[\a-zA-Z0-9]{1,14}$/,
                            message: '中英文均可，最长14个英文或者7个汉字'
                        },
                        remote: {
                            type: 'post',
                            delay: 2000,     // 缓解 前后端的压力
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
                            message: '手机号码不能为空'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                }
            }
        });
    });

    // 用户注册，首先先用bootstrapValidator校验一遍
    $("#register_btn").click(function (){
        $("#deliverRegister").data("bootstrapValidator").validate();
        var flag = $("#deliverRegister").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/deliver/registerDeliver",
                type: "POST",
                data: $("#deliverRegister").serialize(),
                success: function (result) {
                    if (result.code == 200) {
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
                        toastr.success("注册成功!");   // 放入数据
                    } else {
                        // 定义toastr相关数据函数
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
                        toastr.error(result.extend.va_msg);   // 放入数据
                    }
                }
            });
        }
    });

    // 跳转登录页面
    $("#login_btn").click(function () {
        window.parent.location = "toLoginDeliverToLogin";
    });


</script>
</body>
</html>
