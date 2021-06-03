<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>

<%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<script src="${APP_PATH}/static/layer/layer.js"></script>
<script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
<script src="${APP_PATH}/static/js/template.js"></script>
<script src="${APP_PATH}/static/js/toastr.js"></script>

<link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
<link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
<link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>

<style>
    .navbar-default .navbar-nav > .active > a,
    .navbar-default .navbar-nav > .active > a:hover,
    .navbar-default .navbar-nav > .active > a:focus{
        background-color: #00FFFF;
        color: #fff!important;
        text-decoration: none;
        border-bottom: 2px solid #00FFFF;
    }
    .navbar-default .navbar-nav > li > a{
        color: black;
        border-bottom: 2px solid white;
    }
    .navbar-default .navbar-nav > li > a:hover{
        color: #1E90FF;
        border-bottom: 2px solid #1E90FF;
    }
    .navbar-nav > li > a{
        line-height: 34px;
    }
    .img-circle{
        width: 100%;
        background-color: red;
    }
    .logo-style{
        padding: 0px 20px 0px 0px;
        line-height: 34px;
    }
    .page-header h3{
        border-left:5px solid #ff9d00;
        padding-left: 10px;
    }

    .deliverName{
        height: 66px;
        padding: 15px;
        line-height: 34px;
        color: black;

    }

</style>


<script>

    $(function (){
        // 配送员密码修改
        $("#updateDeliverPassWord").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                originalPassWord: {
                    validators: {
                        notEmpty: {
                            message: "原始密码不能为空"
                        },
                        remote: {
                            type: 'post',
                            data: '',       // 默认返回当前数据
                            delay: 2000,    // 设置1秒发送一次ajax（默认输入一个字符，提交一次，服务器压力太大）
                            url: '${APP_PATH}/deliver/checkDeliverOriginalPassWord'
                        }
                    }
                },
                newPassWord: {
                    validators: {
                        notEmpty: {
                            message: '新密码不能为空'
                        },
                        identical: {
                            filed: 'originalPassWord',
                            message: '新密码与旧密码一致'
                        },
                        stringLength: {
                            min: 6,
                            max: 18,
                            message: '密码长度必须大于6位或小于18位'
                        }

                    }
                },
                rePassWord: {
                    validators: {
                        notEmpty: {
                            message: '确认密码不能为空'
                        },
                        identical: {
                            field: 'newPassWord',
                            message: '两次输入的密码不一致'
                        }
                    }
                }
            }
        });
    });

    // 修改配送员密码
    function updatePassWord(){
        var newPassWord = $("#newPassWord").val();
        $.ajax({
            url: "${APP_PATH}/deliver/updateDeliverPassWord",
            type: "POST",
            data: "newPassWord=" + newPassWord,
            success: function (result){
                if(result.code == 200){
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
                    toastr.success(result.extend.vag);   // 放入数据
                    setTimeout(function() {
                        location.href = "${APP_PATH}/deliver/toLoginDeliverToLogin";// 2s后重新刷新页面
                    }, 2000);
                    $("#updatePassWordModal").modal("hide");
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
                    toastr.error(result.extend.vag);   // 放入数据
                }
            }
        });
    }

    // 退出登录
    function logout(){
        $.ajax({
            url: "${APP_PATH}/deliver/logout",
            type: "POST",
            success: function (result) {
                if (result.code == 200) {
                    // 登录成功跳转
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
                    toastr.success("正在注销...");   // 放入数据
                    setTimeout(function () {
                        location.href = "${APP_PATH}/deliver/toLoginDeliverToLogin";// 2s后重新刷新页面
                    }, 2000);
                }
            }
        });
    }

    // 拦截未登录页面，跳转登录
    function showLoginModal() {
        location.href = "${APP_PATH}/deliver/toLoginDeliverToLogin";
    }

    function showDeliverOrders() {
        location.href = "${APP_PATH}/deliver/getDeliverToDeliver";
    }

    function showDeliverInfo() {
        location.href = "${APP_PATH}/deliver/toDeliverCenter";
    }

</script>
<!-- 导航栏 -->
<div class="navbar navbar-default navbar-fixed-top clear-bottom">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand logo-style" target="_blank">
                <img style="width: 50px;height: 55px" class="brand-img" src="${APP_PATH}/static/images/shop-logo.png"
                     alt="logo">
            </a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="${param.num == 1 ? 'active' : ''}">
                    <a href="${APP_PATH}/deliver/getAllOrdersByDeliverAndDeliverIndex">订单大厅</a>
                </li>
                <li class="${param.num == 2 ? 'active' : ''}" style="cursor: pointer;">
                    <a id="shopCart"
                       onclick="${sessionScope.get('session_deliver') == null ? 'showLoginModal()' :'showDeliverOrders()'}">
                        <span>配送订单</span>
                    </a>
                </li>
                <li class="${param.num == 3 ? 'active' : ''}">
                    <a href="javascript:void(0)"
                       onclick="${sessionScope.get('session_deliver') == null ? 'showLoginModal()' :'showDeliverInfo()'}">个人中心</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right" id="navbarInfo">
                <c:choose>
                    <%--TODO:如果session中用户为空则走 when 中--%>
                    <c:when test="${empty session_deliver}">
                        <li>
                            <a href="${APP_PATH}/deliver/toLoginDeliverToLogin" >登录</a>
                        </li>
                        <li>
                            <a href="${APP_PATH}/deliver/toRegisterDeliver" >注册</a>
                        </li>
                    </c:when>
                    <%--TODO:否则走 otherwise 中--%>
                    <c:otherwise>
                        <li class="deliverName">
                           欢迎您 : <span class="text text-success">${session_deliver.deliverName} !</span>
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle user-active" data-toggle="dropdown" role="button">
                                <img style="width: 25px;height: 25px" class="img-circle"
                                     src="${APP_PATH}/static/images/login-font.jpg"/>
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#" data-toggle="modal" data-target="#updatePassWordModal">
                                        <i class="glyphicon glyphicon-cog"></i>修改密码
                                    </a>
                                </li>
                                <li>
                                    <a href="#" onclick="logout()">
                                        <i class="glyphicon glyphicon-off"></i> 退出
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</div>

<!-- 修改密码模态框 -->
<div class="modal fade" id="updatePassWordModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     style="top: 10%;">
    <div class="modal-dialog" role="document" style="width: 30%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="update_passWord" style="color: #1E90FF;">修改密码</h4>
            </div>
            <form id="updateDeliverPassWord" class="form-horizontal">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">原密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="originalPassWord">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">新密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="newPassWord" id="newPassWord">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">重复密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="rePassWord">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">
                        取消
                    </button>
                    <button type="button" class="btn btn-primary" onclick="updatePassWord()">确认</button>
                </div>
            </form>
        </div>
    </div>
</div>
