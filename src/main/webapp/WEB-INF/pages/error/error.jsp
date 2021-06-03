<%@page import="java.io.PrintStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isErrorPage="true"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>500 服务器内部错误</title>
</head>
<body>
<div class="ui-alert-panel">
    <h1>服务器内部错误</h1>
    <p>处理您的请求时发生错误！请确认您通过正确途径操作。</p>
</div>
<div style="display:none;">
    <%  //此处输出异常信息
        exception.printStackTrace();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        exception.printStackTrace(new PrintStream(byteArrayOutputStream));
        out.print(byteArrayOutputStream);
    %>
</div>
</body>
</html>