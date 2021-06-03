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
    .img-circle{
        width: 100%;
        background-color: red;
    }
    .page-header h3{
        border-left:5px solid #ff9d00;
        padding-left: 10px;
    }

</style>


<script>

    // TODO：使用bootstrapValidator数据校验
    $(function () {
        //TODO:用户账户密码登录数据校验
        $("#userLogin").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userName: {
                    validators: {
                        notEmpty: {
                            message: '用户名不能为空'
                        }
                    }
                },
                passWord: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        }
                    }
                }
            }
        });

        //TODO:修改密码数据校验
        $('#updatePassWord').bootstrapValidator({
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
                            url: '${APP_PATH}/user/checkOriginalPassWord'
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
                            message: '用户密码长度不能少于6位或大于18位'
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

        //TODO:用户注册数据校验
        $('#userRegister').bootstrapValidator({
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
                        }
                    }
                },
                phone: {
                    validators: {
                        notEmpty: {
                            message: '请输入手机号'
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

    });

    //TODO：校验函数，为了解决账号和密码都为空，错误登录提示信息会弹出来
    function validate_add_form() {
        var username = $("#loginName").val();
        var password = $("#loginPassword").val();
        if (username == "" || password == "") {
            return false;
        }
        return true;
    }

    /* 清除表单样式 */
    function reset_form(ele) {
        $(ele)[0].reset();
        // 清除表单样式
        $(ele).bootstrapValidator("resetForm");
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    /*打开登录模态框背景不删除*/
    $("#userLoginModal").click(function () {
        // 每次添加前都先清除上次的添加数据
        reset_form("#userLoginModal form");
        // 背景不删除
        $("#userLoginModal").modal({
            backdrop: "static"
        });
    });

    /*打开注册模态框背景不删除*/
    $("#registerModal").click(function () {
        // 每次添加前都先清除上次的添加数据
        reset_form("#registerModal form");
        // 背景不删除
        $("#registerModal").modal({
            backdrop: "static"
        });
    });

    /*打开修改模态框背景不删除*/
    $("#updatePassWordModal").click(function () {
        // 每次添加前都先清除上次的添加数据
        reset_form("#updatePassWord");
        // 背景不删除
        $("#updatePassWordModal").modal({
            backdrop: "static"
        });
    });

    /*根据账户名密码登录*/
    function loginByAccount() {
        $("#userLogin").data("bootstrapValidator").validate();
        var flag = $("#userLogin").data("bootstrapValidator").isValid();
        if (flag) {
            //校验通过发送ajax请求
            $.ajax({
                url: "${APP_PATH}/user/checkUser",
                type: "POST",
                //data: "userName=" + username,  // 单个传输的时候
                data: $('#userLogin').serialize(),
                success: function (result) {
                    if (result.code == 200) {
                        // 登录成功跳转
                        location.href = '${APP_PATH}/product/searchAllProducts';
                        $('#userLoginModal').modal('hide');
                    } else {
                        // 校验，全部填完才提示
                        if (validate_add_form()) {
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
                            toastr.error("登录失败，用户名或密码错误!");   // 放入数据
                        }
                    }
                }
            });
        }
    }

    /*location.href = "${APP_PATH}/product/logout";*/
    /* 退出登录，并清除session_user缓存 */
    function logout() {
        $.ajax({
            url: "${APP_PATH}/product/logout",
            type: "GET",
            success: function (result) {
                if (result.code == 200) {
                    // 登录成功跳转
                    location.href = '${APP_PATH}/product/searchAllProducts';
                }
            }
        });
    }

    /* 注册重置按钮，清空表单数据 */
    function resetRegisterForm() {
        $('#userRegister').bootstrapValidator('resetForm');
        $('#userRegister')[0].reset();
    }

    /* 用户注册 */
    function userRegister() {
        $("#userRegister").data("bootstrapValidator").validate();
        var flag = $("#userRegister").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/user/loginIndex",
                type: "POST",
                data: $("#userRegister").serialize(),
                success: function (result) {
                    if (result.code == 200) {
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
                        toastr.success("注册成功!");   // 放入数据
                        $("#registerModal").modal("hide");
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
                        toastr.error("注册失败!");   // 放入数据
                    }
                }
            });
        }
    }

    /* 用户修改密码 */
    function updatePassWord() {
        //启动前校验
        $("#updatePassWord").data("bootstrapValidator").validate();
        var flag = $("#updatePassWord").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/user/updatePassWord",
                type: "POST",
                data: $("#updatePassWord").serialize(),
                success: function (result) {
                    if (result.code == 200) {
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
                        toastr.success("密码修改成功，请重新登录!");
                        setTimeout(function() {
                            location.reload();// 2s后重新刷新页面
                        }, 2000);
                        $("#updatePassWordModal").modal("hide");
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
                        toastr.error("密码修改失败!");   // 放入数据
                    }
                }
            });
        }
    }

    // 拦截未登录页面，弹出登录框
    function showLoginModal() {
        $('#userLoginModal').modal('show');
    }

    /*登录则展示客户购物车*/
    function showShopCarts() {
        location.href = '${APP_PATH}/cart/showShopCarts';
    }

    /*展示用户所有订单列表*/
    function showOrderDetails() {
        location.href = '${APP_PATH}/order/myOrders';
    }

    /*展示用户个人中心*/
    function showUserInfo() {
        location.href = '${APP_PATH}/user/userCenter';
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
                    <a href="${APP_PATH}/product/searchAllProducts">首页</a>
                </li>
                <li class="${param.num == 2 ? 'active' : ''}" style="cursor: pointer;">
                    <a id="shopCart"
                       onclick="${sessionScope.get('session_user') == null ? 'showLoginModal()' :'showShopCarts()'}">
                        <span>购物车</span>
                    </a>
                </li>
                <li class="${param.num == 3 ? 'active' : ''}">
                    <a href="javascript:void(0)"
                       onclick="${sessionScope.get('session_user') == null ? 'showLoginModal()' :'showOrderDetails()'}">我的订单</a>
                </li>
                <li class="${param.num == 4 ? 'active' : ''}">
                    <a href="javascript:void(0)"
                       onclick="${sessionScope.get('session_user') == null ? 'showLoginModal()' :'showUserInfo()'}">个人中心</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right" id="navbarInfo">
                <c:choose>
                    <%--TODO:如果session中用户为空则走 when 中--%>
                    <c:when test="${empty session_user}">
                        <li>
                            <a href="#" data-toggle="modal" data-target="#userLoginModal">登录</a>
                        </li>
                        <li>
                            <a href="#" data-toggle="modal" data-target="#registerModal">注册</a>
                        </li>
                        <li>
                            <a href="${APP_PATH}/deliver/toLoginDeliverToLogin">骑手入口</a>
                        </li>
                        <li>
                            <a href="${APP_PATH}/admin/adminLogin">后台入口</a>
                        </li>
                    </c:when>
                    <%--TODO:否则走 otherwise 中--%>
                    <c:otherwise>
                        <li class="userName">
                            欢迎您 : <span class="text text-success">${session_user.userName} !</span>
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
                <h4 class="modal-title" id="update_passWord">修改密码</h4>
            </div>
            <form id="updatePassWord" class="form-horizontal">
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
                            <input class="form-control" type="password" name="newPassWord">
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
                        取&nbsp;&nbsp;消
                    </button>
                    <button type="button" class="btn btn-warning" onclick="updatePassWord()">确&nbsp;&nbsp;认</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 登录模态框 -->
<div class="modal fade" id="userLoginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     style="top: 10%;">
    <div class="modal-dialog" role="document" style="width: 34%">
        <!-- 用户名密码登录 start -->
        <div class="modal-content" id="login-account">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" style="color: #1E90FF">用户名密码登录
                    <small class="text-danger"></small>
                </h4>
            </div>
            <form id="userLogin" class="form-horizontal">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户名：</label>
                        <div class="col-sm-6">
                            <input id="loginName" class="form-control" type="text" placeholder="请输入用户名" name="userName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
                        <div class="col-sm-6">
                            <input id="loginPassword" class="form-control" type="password" placeholder="请输入密码"
                                   name="passWord">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center">
                    <button type="button" class="btn btn-primary" data-dismiss="modal" aria-label="Close">
                        关&nbsp;&nbsp;闭
                    </button>
                    <button type="button" class="btn btn-primary" onclick="loginByAccount()">登&nbsp;&nbsp;录</button>
                </div>
            </form>
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
            <form id="userRegister" class="form-horizontal">
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
                            <input id="password_add_input" class="form-control" lay-verify="required" type="password"
                                   name="passWord">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirm_password_add_input" class="col-sm-3 control-label">确认密码:</label>
                        <div class="col-sm-6">
                            <input id="confirm_password_add_input" class="form-control"
                                   lay-verify="required|confirmPass" type="password" name="confirm_passWord">
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
