<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<html>
<head>
    <title>转跳首页</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <jsp:forward page="${APP_PATH}/Home/pages"></jsp:forward>
</head>
<body>

    <h3>直接跳转到商城首页</h3>

</body>
</html>
