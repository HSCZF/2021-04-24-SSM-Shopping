
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>SSM贺州市果蔬系统后台管理员登录</title>
      <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
      %>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="stylesheet" media="screen" href="${APP_PATH}/static/css/login/style.css">
    <link rel="stylesheet" media="screen" href="${APP_PATH}/static/css/login/reset.css">
</head>
<body>

<div id="particles-js">
    <div class="login" style="display: block;">
        <div class="login-top">
            管理员登录
        </div>
        <div class="login-center clearfix">
            <div class="login-center-img"><img src="${APP_PATH}/static/images/login/name.png"></div>
            <div class="login-center-input">
                <input type="text" name="userName" id="username" value="" placeholder="请输入您的账号"
                       onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的账号'">
                <div class="login-center-input-text">账号</div>
            </div>
        </div>
        <div class="login-center clearfix">
            <div class="login-center-img"><img src="${APP_PATH}/static/images/login/password.png"></div>
            <div class="login-center-input">
                <input type="password" name="passWord" id="password" value="" placeholder="请输入您的密码"
                       onfocus="this.placeholder=''" onblur="this.placeholder='请输入您的密码'">
                <div class="login-center-input-text">密码</div>
            </div>
        </div>
        <div class="login-button">
            登录
        </div>
    </div>
    <div class="sk-rotating-plane"></div>
    <canvas class="particles-js-canvas-el" style="width: 100%; height: 100%;"></canvas>
</div>


<!-- scripts -->
<script src="${APP_PATH}/static/js/particles.min.js"></script>
<%-- app.js背景图片动画演示 --%>
<script src="${APP_PATH}/static/js/app.js"></script>
<script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript">

    /*解决登录页面嵌套问题*/
    if (window != top){
        top.location.href = "${APP_PATH}/admin/adminLogin";
    }

    document.querySelector(".login-button").onclick = function () {
        var username = $("#username").val();
        var password = $("#password").val();
        if (username == '' || username == 'undefined') {
            alert("请填写用户名！");
            return;
        }
        if (password == '' || password == 'undefined') {
            alert("请填写密码！");
            return;
        }
        // 数据库校验账号和密码
        $.ajax({
            url: '${APP_PATH}/admin/checkAdmin',
            type: 'POST',
            //data: "userName=" + username,  // 单个传输的时候
            data: {userName: username, passWord: password},
            success: function (data) {
                if (data.code == 200) {
                    //alert("账号密码正确！");
                    // 登录成功跳转
                    window.parent.location = "index";
                } else {
                    alert("账号或密码错误，请重新输入！");
                }
            }
        });
    }


</script>
</body>
</html>