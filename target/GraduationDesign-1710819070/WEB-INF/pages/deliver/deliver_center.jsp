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
    <script src="${APP_PATH}/static/js/template.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>

</head>

<body class="animated fadeIn">

<jsp:include page="head.jsp">
    <jsp:param name="num" value="3"/>
</jsp:include>

<div class="container" style="margin-top:100px;margin-left: 350px">
    <div class="row">
        <div class="col-sm-6">
            <div class="page-header" style="margin-bottom: 0px;">
                <h3>基本资料
                    <button style="float: right;" class="btn btn-primary deliver_edit_btn" id="deliver_center_update_btn">编辑
                    </button>
                </h3>
            </div>
        </div>
    </div>
</div>
<div class="container" style="margin-left: 350px">
    <form class="form-horizontal">
        <div class="form-group">
            <label for="get_deliverName" class="col-sm-2 control-label">配送员名:</label>
            <div class="col-sm-3">
                <input type="hidden" id="hiddenId" value="${deliver.id}">
                <input type="text" class="form-control" id="get_deliverName" placeholder="配送员名" readonly="readonly"
                       value="${deliver.deliverName}">
            </div>
        </div>
        <div class="form-group">
            <label for="get_phone" class="col-md-2  col-sm-2 control-label">联系电话:</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="get_phone" placeholder="联系电话" value="${deliver.phone}"
                       readonly>
            </div>
        </div>
    </form>
</div>

<%-- 配送员编辑信息模态框 --%>
<div class="modal fade" id="deliver_center_update_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                    &times;
                </button>
                <h4 class="modal-title" id="confirmModalLabel">  <%-- 模态框（Modal）标题 --%>
                    配送员信息修改
                </h4>
            </div>
            <div class="modal-body deliver-modal-body" style="overflow: auto">   <%--  在这里添加一些文本 --%>
                <form class="form-horizontal col-sm-11" id="updateDeliverCenter">
                    <div class="form-group">
                        <label for="update_deliverName" class="col-sm-4 control-label">配送员名</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_deliverName" name="deliverName" readonly
                                   value="${deliver.deliverName}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="update_phone" class="col-sm-4 control-label">联系电话</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" id="update_phone" name="phone"
                                   value="${deliver.phone}">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <input type="hidden" name="deliverId" id="deliverId" value="${deliver.id}">
                <button type="button" class="btn btn-default" data-dismiss="modal">
                    关闭
                </button>
                <button type="button" class="btn btn-primary" id="deliver_center_confirm_btn">
                    确认
                </button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<script>

    // 编辑信息校验框
    $(function (){
        $("#updateDeliverCenter").bootstrapValidator({
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
                            regexp: '^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\\d{8}$',
                            message: '无效的手机号码'
                        }
                    }
                }
            }
        });
    });
    
    /**
     * 打开配送员编辑的模态框
     */
    $(document).on("click", ".deliver_edit_btn", function () {
        $("#deliver_center_update_modal").modal({
            backdrop: "static"
        });
    });

    // 配送员编辑信息更新
    $("#deliver_center_confirm_btn").click(function () {
        var id = $("#deliverId").val();
        console.log("id = " + id);
        $("#updateDeliverCenter").data("bootstrapValidator").validate();
        var flag = $("#updateDeliverCenter").data("bootstrapValidator").isValid();
        if(flag){
            $.ajax({
                url: "${APP_PATH}/deliver/updateCenter",
                type: "POST",
                //data: $(".deliver-modal-body form").serialize(),
                data: {
                    "deliverId" : id,
                    "deliverName" : $("#update_deliverName").val(),
                    "phone" : $("#update_phone").val(),
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
        }

    });


</script>


</body>

</html>
