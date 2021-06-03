<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
<script src="${APP_PATH}/static/iconfont/icon_font/iconfont.js"></script>
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css"/>

<!-- 注销登陆js -->
<script>
    function logout() {
        window.parent.location = "logout";
    }
</script>

<style>
    #in-nav{
        margin: 0 auto;
        width: 100%;
        height: 10%;
        background-color: #33CCFF;
    }

</style>

<!-- 页面头部 -->
<div id="in-nav">
    <div class="container">
        <div class="row">
            <div class="span12">
                <ul class="pull-right">
                    <s:choose>
                        <s:when test="${not empty session_admin}">
                            <li>
                                <a href="#" style="color: white">欢迎[${session_admin.adminName}]访问！</a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" style="color: white" onclick="logout()">退出</a>
                            </li>
                        </s:when>
                        <s:otherwise>
                            <li>
                                <a href="adminLogin" style="color: white;">登录</a>
                            </li>
                        </s:otherwise>
                    </s:choose>
                </ul>
                <h4>
                    <a id="logo" href="index"> 果蔬配送后台<strong>管理</strong>
                    </a>
                </h4>
            </div>
        </div>
    </div>
</div>


