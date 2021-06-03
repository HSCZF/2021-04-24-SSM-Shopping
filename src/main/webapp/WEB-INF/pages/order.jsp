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

    <style>

        .list-add-address li {
            border: 0;
            list-style: none;
            margin-right: 20px;
            background: url("/static/images/address.jpg") no-repeat;
            height: 162px;
            width: 240px;
            background-position: -240px 0;
        }

        .list-address li {
            border: 0;
            list-style: none;
            margin-right: 20px;
            background: url("/static/images/address.jpg") no-repeat;
            height: 162px;
            width: 240px;
            background-position: -240px 0;
        }

        .coot{
            background-color: #00FFFF;
        }
    </style>





</head>




<body class="animated fadeIn">
<!-- 导航栏  -->
<jsp:include page="head.jsp">
    <jsp:param name="num" value="7"/>
</jsp:include>

<%-- 收货地址确认 --%>
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <div class="page-header" style="margin-top: 100px;">
                <h3>确认收货地址</h3>
                <p class="text-right">
                    <a class="btn btn-xs btn-info" href="javascript:void(0);" data-toggle="modal"
                       data-target="#myAddressModal" onclick="openAddressModal()">
                        修改地址
                    </a>
                </p>
            </div>
            <c:choose>
                <c:when test="${empty shopList}">
                    <!--新增收货地址卡片-->
                    <div class="list-add-address right">
                        <li class="col-sm-3" style="cursor: pointer;margin-top: 10px;margin-left: 5px"
                            onclick="showAddAddress()">
                            <div style="text-align: center;margin-top: 60px;">
                                <span><img src="${APP_PATH}/static/images/add_cart.jpg"></span>
                            </div>
                        </li>
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="list-address list_address1">
                        <c:forEach items="${shopList}" var="shop">
                            <li class="col-sm-3" style="margin-top: 10px">
                                <h4>用户：${shop.receiverName}</h4>
                                <div class="delete-btn" style="padding-top:8px">
                                    <p><strong>总地址：</strong>${shop.receiverProvince}${shop.receiverCity}${shop.receiverDistrict}</p>
                                    <p><strong>分地址：</strong>${shop.addressDetail}</p>
                                    <p><strong>手机号：</strong>${shop.receiverMobile}</p>
                                    <input type="hidden" name="shopId" value="${shop.id}">
                                    <span class="btn btn-xs"
                                          style="color: red;font-size: 10px;margin-bottom: 5px;padding: 0"
                                          onclick="showDelModal(${shop.id})">删除</span>
                                </div>
                            </li>
                            <input type="hidden" name="shopId" value="${shop.id}">
                        </c:forEach>
                    </ul>
                    <div class="list-add-address right">
                        <li class="col-sm-3" style="cursor: pointer;margin-top: 10px;"
                            onclick="showAddAddress()">
                            <div style="text-align: center;margin-top: 60px;">
                                <span><img src="${APP_PATH}/static/images/add_cart.jpg"></span>
                            </div>
                        </li>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <table class="table table-hover table-striped table-bordered text-center" style="margin-top: 20px">
        <tr class="success">
            <th>序号</th>
            <th>商品名称</th>
            <th>商品图片</th>
            <th>商品数量</th>
            <th>商品总价</th>
        </tr>
        <c:forEach items="${orderList}" var="order">
            <tr>
                <td>${order.id}</td>
                <td>${order.product.name}</td>
                <td><img src="${order.product.image}" alt="" width="60" height="60"></td>
                <td>${order.productNum}</td>
                <td>&yen; ${order.totalPrice}</td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="5" class="foot-msg" align="left">
                <span>共有 <b><span id="totalCount" name="totalCount">${count}</span></b> 件商品 ,&nbsp;</span>
                总计：<b> <span>&yen; ${price}</span></b> 元
            </td>
        </tr>
        <tr>
            <td colspan="5" class="right">
                <%--<a href="javascript:history.go(-1);">--%>
                <a href="javascript:void(0);">
                    <button class="btn btn-primary pull-right" onclick="backCart()">返回</button>
                </a>
                <input type="hidden" name="orderAddress" id="orderAddress">
                <button class="btn btn-primary pull-right margin-right-15" data-toggle="modal"
                        onclick="submitOrders()">提交订单 
                </button>
            </td>
        </tr>
    </table>
</div>

<!--订单生成-->
<div class="modal fade" id="buildOrderModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     style="top: 10%;">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title text-center" id="myModalLabel">提示消息</h4>
            </div>
            <div class="modal-body text-center">
                <div class="orderMsg">
                    <h5 style="margin-top: 5px;font-size: 16px" class="text-success">订单提交成功！</h5>
                    <h5 class="text-info">订单号：<span id="orderNo">121314546</span></h5>
                    <h5 class="text-warning">是否立即支付？</h5>
                </div>
                <div class="">
                    <input type="hidden" id="orderNumber">
                    <button style="margin-left: 5px" class="btn btn-success" onclick="toPlayOrder()">前往支付
                    </button>
                    <button style="padding: 6px 30px" class="btn btn-warning" onclick="cancelPlayOrder()">取消</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!--添加地址模态框-->
<div class="modal fade" id="myAddressAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">添加收货地址</h4>
            </div>
            <form class="form-horizontal" style="width: 85%" id="confirmAddressShop">
                <div class="modal-body" style="overflow: auto">
                    <div class="form-group">
                        <label for="add_name" class="col-sm-3 control-label">姓名</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="add_name" name="receiverName"
                                   placeholder="收货人姓名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_phone" class="col-sm-3 control-label">座机</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="add_phone" name="receiverPhone"
                                   placeholder="座机号码,选填。如：07737160999">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_mobile" class="col-sm-3 control-label">手机号码</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="add_mobile" name="receiverMobile"
                                   placeholder="11位手机号">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">收货地址</label>
                        <div class="col-sm-9">
                            <select id="add_s_province" name="receiverProvince"></select>
                            <select id="add_s_city" name="receiverCity"></select>
                            <select id="add_s_county" name="receiverDistrict"></select>
                            <script class="resources library" src="${APP_PATH}/static/js/area.js"
                                    type="text/javascript"></script>
                            <script type="text/javascript">_init_area('add_s_province', 'add_s_city', 'add_s_county');</script>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_addressDetail" class="col-sm-3 control-label">详细地址</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="add_addressDetail" name="addressDetail"
                                   placeholder="路名或街道地址，门牌号...">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="add_zipCode" class="col-sm-3 control-label">邮政编码</label>
                        <div class="col-sm-9">
                            <input id="add_zipCode" class="form-control" type="text" name="zipCode"
                                   placeholder="邮政编码,选填。如：3646633...">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" id="addShopBtn" class="btn btn-primary" onclick="confirmToAdd()">确认添加
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!--修改地址模态框-->
<div class="modal fade" id="myAddressModifyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">修改收货地址</h4>
            </div>
            <div class="modal-body" style="overflow: auto">
                <form class="form-horizontal col-sm-10" id="updateModalShop">
                    <div class="form-group">
                        <input type="hidden" name="id" id="updateId"/>
                        <label for="modify_name" class="col-sm-3 control-label">姓名</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="modify_name" name="receiverName"
                                   placeholder="收货人姓名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modify_phone" class="col-sm-3 control-label">座机</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="modify_phone" name="receiverPhone"
                                   placeholder="座机,选填。如：07737160999">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modify_mobile" class="col-sm-3 control-label">手机号码</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="modify_mobile" name="receiverMobile"
                                   placeholder="11位手机号">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">收货地址</label>
                        <div class="col-sm-9">
                            <%--TODO:临时方案使用input代替select，回显值--%>
                            <div class="col-sm-3" style="padding: 0;width: 30%">
                                <input class="form-control" type="text" name="receiverProvince" id="s_province">
                            </div>
                            <div class="col-sm-3" style="padding: 0;margin-left: 15px;width: 30%">
                                <input class="form-control" type="text" name="receiverCity" id="s_city">
                            </div>
                            <div class="col-sm-3" style="padding: 0;margin-left: 15px;width: 30%">
                                <input class="form-control" type="text" name="receiverDistrict" id="s_county">
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modify_addressDetail" class="col-sm-3 control-label">详细地址</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="modify_addressDetail" name="addressDetail"
                                   placeholder="路名或街道地址，门牌号...">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modify_zipCode" class="col-sm-3 control-label">邮政编码</label>
                        <div class="col-sm-9">
                            <input id="modify_zipCode" class="form-control" type="text" name="zipCode"
                                   placeholder="邮政编码,选填。如：3646633...">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <input type="hidden" name="shopId" id="modifyId">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="updateShopAddress()">确认修改</button>
            </div>
        </div>
    </div>
</div>

<%--弹出提示确认框--%>
<div class="modal fade" tabindex="-1" id="removeShoppingModal" style="top: 10%">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-sm">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">提示消息</h4>
            </div>
            <div class="modal-body text-center">
                <h5 class="text-warning">确认删除此收货地址吗？</h5>
            </div>
            <div class="modal-footer">
                <%--TODO:设置一个隐藏域来存放所要删除商品的id--%>
                <input type="hidden" id="shopId">
                <button class="btn btn-primary updateProType" onclick="deleteShopAddress()" data-dismiss="modal">确认
                </button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(function () {
        // 默认选中第一个地址卡片
        $(".list-address li:first-child").addClass("active");
        // 拿到默认选中的 地址id
        $("#modifyId").val($(".list-address li:first-child").next().val());
        $("#updateId").val($(".list-address li:first-child").next().val());
        $("#orderAddress").val($(".list-address li:first-child").next().val());

        //点击则选中点击的地址卡片
        $(".list-address li").click(function () {
            $('.list-address li').removeClass('active');
            $(this).addClass('active coot');
            $('#modifyId').val($(this).next().val());
            //给修改模态框中隐藏域保存id
            $('#updateId').val($(this).next().val());
            // 给提交订单中隐藏保存id
            $('#orderAddress').val($(this).next().val());
            
        });

        //新增地址表单校验
        $("#confirmAddressShop").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                receiverName: {
                    validators: {
                        notEmpty: {
                            message: '收件人姓名不能为空'
                        }
                    }
                },
                receiverMobile: {
                    validators: {
                        notEmpty: {
                            message: '手机号不能为空'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$',
                            message: '无效的手机号'
                        }
                    }
                },
                receiverProvince: {
                    validators: {
                        remote: {
                            type: "post",
                            url: "${APP_PATH}/shop/checkValidateProvince"
                        }
                    }
                },
                receiverCity: {
                    validators: {
                        remote: {
                            type: "post",
                            url: "${APP_PATH}/shop/checkValidateCity"
                        }
                    }
                },
                receiverDistrict: {
                    validators: {
                        remote: {
                            type: "post",
                            url: "${APP_PATH}/shop/checkValidateDistrict"
                        }
                    }
                },
                addressDetail: {
                    validators: {
                        notEmpty: {
                            message: '详细地址不能为空'
                        }
                    }
                }
            }
        });

        //修改地址表单校验
        $("#updateModalShop").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                receiverName: {
                    validators: {
                        notEmpty: {
                            message: '收件人姓名不能为空'
                        }
                    }
                },
                receiverMobile: {
                    validators: {
                        notEmpty: {
                            message: '手机号不能为空'
                        },
                        regexp: {
                            regexp: '^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$',
                            message: '无效的手机号'
                        }
                    }
                },
                receiverProvince: {
                    validators: {
                        notEmpty: {
                            message: '请填写省份信息'
                        }
                    }
                },
                receiverCity: {
                    validators: {
                        notEmpty: {
                            message: '请填写市信息'
                        }
                    }
                },
                receiverDistrict: {
                    validators: {
                        notEmpty: {
                            message: '请填写区或县信息'
                        }
                    }
                },
                addressDetail: {
                    validators: {
                        notEmpty: {
                            message: '详细地址不能为空'
                        }
                    }
                }
            }
        });

        //当是否立即支付提示框消息后，即客户不跳转到支付页面，则跳转到订单详情页
        $("#buildOrderModal").on("hide.bs.modal", function () {
            location.replace("${APP_PATH}/order/showOrderDetails");
        });

    });

    // 清除表单样式函数
    function reset_form(ele) {
        $(ele)[0].reset();
        // 清除表单样式
        $(ele).bootstrapValidator("resetForm");
    }

    // 添加新地址、确认框、清空原来模态框中校验的数据
   /* $("#myAddressAddModal").click(function (){
        reset_form("#myAddressAddModal form");
    });*/

    //点击添加新地址弹出框、清除校验数据
    function showAddAddress() {
        //$("#myAddressAddModal").modal("show");
        reset_form("#myAddressAddModal form");
        // 背景不删除
        $("#myAddressAddModal").modal("show");
    }

    //点击删除地址，弹出提示框
    function showDelModal(id) {
        $("#shopId").val(id);
        $("#removeShoppingModal").modal({
            backCart: "static"
        });
    }

    //新增收货地址  confirmToAdd
    function  confirmToAdd() {
        //先进行表单校验
        $("#confirmAddressShop").data("bootstrapValidator").validate();
        var flag = $("#confirmAddressShop").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
                url: "${APP_PATH}/shop/toAddShop",
                type: "POST",
                data: $("#confirmAddressShop").serialize(),  //表格序列化
                success: function (result){
                    if(result.code == 200){
                        //地址新增成功
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: "successMsg"
                        },function () {
                            //刷新页面
                            location.reload();
                        });
                    }else {
                        //地址新增失败
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: "errorMsg"
                        });
                    }
                }
            });
        }
    }

    //点击修改地址弹出框（显示用户的一个地址信息）
    function openAddressModal() {
        var spanId = $("#modifyId").val(); $("#modifyId")
        if (spanId == "") {
            layer.msg("您还未添加地址，请先添加",{
                time: 1500,
                skin: 'warningMsg'
            });
        } else {
            $.ajax({
                url: "${APP_PATH}/shop/getOneAddressShop", // 显示用户的一个地址信息
                data: {
                    "shopId" : $("#modifyId").val(),
                },
                success: function (result){
                    if(result.code == 200){

                        // 显示地址信息到静态模态框上
                        var userData = result.extend.shop;
                        $("#modify_name").val(userData.receiverName);
                        $("#modify_phone").val(userData.receiverPhone);
                        $("#modify_mobile").val(userData.receiverMobile);
                        $("#modify_addressDetail").val(userData.addressDetail);
                        $("#modify_zipCode").val(userData.zipCode);
                        $("#s_province").val(userData.receiverProvince);
                        $("#s_city").val(userData.receiverCity);
                        $("#s_county").val(userData.receiverDistrict);
                        // 打开修改模态框
                        $("#myAddressModifyModal").modal("show");
                    }else {
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: 'errorMsg'
                        });
                    }
                }
            });
        }
    }

    // 修改用户配送地址
    function updateShopAddress() {
        $("#updateModalShop").data("bootstrapValidator").validate();
        var flag = $("#updateModalShop").data("bootstrapValidator").isValid();
        if (flag) {
            $.ajax({
               url: "${APP_PATH}/shop/updateShopAddress",
               type: "POST",
               data: $("#myAddressModifyModal form").serialize(),  // 表格序列化
               success: function (result){
                   if(result.code == 200){
                       layer.msg(result.extend.vag, {
                           time: 1500,
                           skin: "successMsg"
                       },function () {
                           location.reload();
                       });
                   }else {
                       layer.msg(result.extend.vag, {
                           time: 1500,
                           skin: "errorMsg"
                       });
                   }
               }
            });
        }
    }

    // 删除一个用户的配送地址
    function deleteShopAddress() {
        $.ajax({
            url: "${APP_PATH}/shop/deleteShopAddress",
            type: "POST",
            data: {
                "shopId" :  $("#shopId").val(),
            },
            success: function (result){
                if(result.code == 200){
                    location.reload();
                }else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });
                }
            }
        });
    }

    //提交订单
    function submitOrders() {
        var shopId = $("#orderAddress").val();
        var status = "${orderList.get(0).status}";  // 获取购物车中缓存的第一个状态码
        var addressNull =  "${shopList.size()}";
        if(addressNull == 0){
            layer.msg("未存在地址，请添加地址", {
                time: 1500,
                skin: "errorMsg"
            });
            return false;
        }else {
            $.ajax({
                url: "${APP_PATH}/order/addOrder",
                type: "POST",
                data: {
                    "shopId" : shopId,
                    "status" : status,
                },
                success: function (result){
                    if(result.code == 200){
                        // 订单号
                        var orderData = result.extend.orderNo_vag;
                        $("#orderNo").text(orderData);
                        $("#orderNumber").val(orderData);
                        // 打开生成订单模态框
                        $("#buildOrderModal").modal("show");
                    }else {
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: "errorMsg"
                        });
                    }
                }
            });
        }
    }

    // 未点击立即支付，则自动跳转到订单明细页面
    function cancelPlayOrder() {
        location.replace("${APP_PATH}/order/showOrderDetails");
    }

    //点击返回
    function backCart() {
        //刷新上一级页面
        self.location = document.referrer;
        //判断是否是直接直接购买产生的购物车
        var status = "${orderList.get(0).status}";
        var cartId = "${orderList.get(0).id}";
        if (status == 2) {
            //把这个购物车清空
            $.ajax({
                url: "${APP_PATH}/cart/removeOneProduct",
                type: "POST",
                data: {
                    "cartId" : cartId,
                },
                success: function (result){
                    if(result.code == 200){

                    }else {
                        layer.msg("临时购物车清空失败", {
                            time: 1500,
                            skin: 'errorMsg'
                        });
                    }
                }
            });
        }
    }

    //立即支付
    function toPlayOrder() {
        var orderNumber = $("#orderNumber").val();
        location.href = "${APP_PATH}/order/showPayNowOrders?orderNumber=" + orderNumber;
    }
</script>


</body>

</html>
