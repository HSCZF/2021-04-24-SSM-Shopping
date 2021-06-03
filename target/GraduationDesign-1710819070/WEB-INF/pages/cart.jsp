<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>我的购物车</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/front-shop.js"></script>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">

    <style>

        .table tbody tr td {
            vertical-align: middle;
        }

        .table th {
            text-align: center !important;
        }

    </style>

</head>

<body class="animated fadeIn">

<jsp:include page="head.jsp">
    <jsp:param name="num" value="2"/>
</jsp:include>

<div class="container">
    <div class="row">
        <div class="col-xs-12" style="margin-top: 60px">
            <div class="page-header">
                <h3>我的购物车</h3>
            </div>
        </div>
    </div>
    <c:choose>
        <c:when test="${empty cartList}">
            <h3 class="text-success" style="text-align: center;margin-top: 180px">
                购物车没有任何存物, <a class="btn-link" href="${APP_PATH}/product/searchAllProducts">立即前往购物~</a>
            </h3>
        </c:when>
        <c:otherwise>
            <table class="table table-hover table-striped table-bordered table-condensed text-center">
                <tr class="success">
                    <th>
                        <input type="checkbox" id="checkAll" name="checkAll">
                        <label for="checkAll"/>
                        <span class="text-danger">全选</span>
                    </th>
                    <th>序号</th>
                    <th>商品名称</th>
                    <th>商品图片</th>
                    <th>商品单价</th>
                    <th>商品数量</th>
                    <th>商品小计</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${cartList}" var="cart">
                    <tr class="single-item" name="clearBtn">
                        <td>
                            <input type="checkbox" class="check_item" id="check_item" name="check_item"
                                   value="${cart.id}">
                            <label for="check_item"/>
                        </td>
                        <td>${cart.id}</td>
                        <td>${cart.product.name}</td>
                            <%--Cart封装了Product --%>
                        <td>
                            <img src="${APP_PATH}${cart.product.image}" alt="" style="width: 60px; height: 60px;">
                        </td>
                        <td>
                            <span id="single-price" class="price">${cart.product.price}</span>
                        </td>
                        <td>     <%-- 不显示,用于修改商品数量，局部刷新 --%>
                            <div class="cartCount1" style="align-content: center">
                                <input type="hidden" id="inputCartId" name="inputCartId" value="${cart.id}">
                                <input type="hidden" id="reduceNum" name="reduce" value="-">
                                    <%-- <input class="textBox" name="textBox" type="hidden"
                                            value="${cart.productNum}">--%>
                                <span class="textBox" name="textBox">${cart.productNum}</span>
                                <input id="addNum" name="add" type="hidden" value="+">
                            </div>
                        </td>
                        <td>&yen; ${cart.totalPrice}</td>
                        <td>
                            <a class="btn btn-danger btn-sm" type="button"
                               onclick="clearOneProduct(${cart.id})">
                                    <%--<button class="btn btn-primary btn-sm delete_btn glyphicon glyphicon-pencil" del-id="${cart.id}"><span></span>删除</button>--%>
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <tr>
                    <td colspan="8" align="right" style="height: 60px">
                        <button class="btn btn-primary margin-right-15" id="clearCartBtn" type="button"
                                onclick="removeCart()">删除多个
                        </button>
                        <button class="btn btn-primary margin-right-15" type="button" onclick="clearAll()"> 清空购物车
                        </button>
                        <button class="btn btn-primary margin-right-15" type="button" onclick="goToShopping()"> 继续购物
                        </button>
                        <button class="btn btn-primary" type="button" onclick="calculationAccounts()">结算</button>
                    </td>
                </tr>
                <tr>
                    <td colspan="8" align="right" class="foot-msg" style="height: 50px">
                        <span>总共选中了 <b><span id="totalCount" name="totalCount">0</span></b> 件商品</span>
                        <span>总计: &yen;<b><span id="totalPrices" name="totalPrices"> 0.00</span></b> 元</span>
                    </td>
                </tr>
            </table>
        </c:otherwise>
    </c:choose>
</div>


<!-- 从购物车中删除某一项商品-->
<div class="modal fade" tabindex="-1" id="removeOneProductModal" style="top: 10%;">
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
                <h5 class="text-warning">确认从购物车中移除此商品吗？</h5>
            </div>
            <div class="modal-footer">
                <%--TODO:设置一个隐藏域来存放所要删除商品的id--%>
                <input type="hidden" id="cartId">
                <button class="btn btn-primary updateProType" onclick="removeOneProduct()" data-dismiss="modal">确认
                </button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 移除购物车中选中的商品  -->
<div class="modal fade" tabindex="-1" id="removeMoreProductModal" style="top: 10%;">
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
                <h5 class="text-warning">确认从购物车中移除所选商品吗？</h5>
            </div>
            <div class="modal-footer">
                <%--TODO:设置一个隐藏域来存放所要删除商品的id--%>
                <input type="hidden" id="cartIds">
                <button class="btn btn-primary updateProType" onclick="removeMoreProduct()" data-dismiss="modal">确认
                </button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!-- 清空购物车  -->
<div class="modal fade" tabindex="-1" id="removeAllProductModal" style="top: 10%;">
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
                <h5 class="text-warning">确认从购物车中移除所有商品吗？</h5>
            </div>
            <div class="modal-footer">
                <%--TODO:设置一个隐藏域来存放所要删除商品的id--%>
                <input type="hidden" id="cartId">
                <button class="btn btn-primary updateProType" onclick="removeAllProduct()" data-dismiss="modal">确认
                </button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="refreshed" value="no">

</body>

<script>

    $(function () {

        //TODO: 确认模态框弹出的时候，返回本页面
        var refresh = document.getElementById("refreshed");
        if (refresh.value == "no") refresh.value = "yes";
        else {
            refresh.value = "no";
            location.reload();
        }

        // 刷新页面，重新计算
        calcTotal();

        // 全选/全不选
        $("#checkAll").click(function () {
            // attr获取checked是undefined；
            if ($(this).prop("checked")) {
                // $(this).prop("checked") = true, 全选勾上
                $(".check_item").prop("checked", $(this).prop("checked"));
                calcTotal();
            } else {
                $(".check_item").prop("checked", false);
                $("#totalCount").text("0");
                $("#totalPrices").text("0.00");
            }
        });

        // check_item: 全部单击选上，全选也自动勾上
        $(document).on("click", ".check_item", function () {
            // 勾选的长度
            var checkItem = $("input[name='check_item']");  // 数组
            var sum = 0;
            for (var i = 0; i < checkItem.length; i += 1) {
                // 复选框被勾中的购物车项才进行计算
                if ($(checkItem[i]).prop("checked")) {
                    calcTotal();
                    sum++;
                }
            }
            // 全部点击勾选上，全选也要勾选上
            if (sum == checkItem.length) {
                $("#checkAll").prop("checked", true);
            } else {
                $("#checkAll").prop("checked", false);
            }
        });

        // 为减少和添加商品数量的按钮绑定事件回调
        $(".single-item input[type='button']").on("click", function () {
            //遍历查找被选中的元素，这里的this 为 +  - 两个按钮
            $(this).parent().parent().find("input[name='check_item']").prop("checked", true);
            // 获取 type="hidden" 的 购物车 不能用 id属性值获取，这样只能获取到第一个商品的id值
            if ($(this).val().trim() == "-") {
                //计算商品数量减
                var count = parseInt($(this).next().val());
                if (count > 1) {
                    count -= 1;
                    $(this).next().val(count);
                } else {
                    layer.msg("商品数量最少为1", {
                        time: 1500,
                        skin: 'warningMsg'
                    });
                }
                // ”-“ 往上退2格，包括自身，拿到隐藏的id
                var id = $(this).prev().val();
                console.log("改变数量商品数量id =  " + id);
                console.log("商品数量count = " + count);
                //发送ajax 请求，更新商品数量
                updateProductNum(id, count);
            } else {
                var count = parseInt($(this).prev().val());
                if (count < 99) {
                    count += 1;
                    $(this).prev().val(count);
                } else {
                    layer.msg("库存不足", {
                        time: 1500,
                        skin: 'warningMsg'
                    });
                }
                var id = $(this).prev().prev().prev().val();
                console.log("改变数量商品数量id =  " + id);
                console.log("商品数量count = " + count);
                updateProductNum(id, count);
            }
            // 单价
            var price = parseFloat($("#single-price").text());
            console.log("单价 = " + price);
            var price = parseFloat($(this).parent().parent().prev().find('span').text());
            //toFixed() 方法可把 Number 四舍五入为指定小数位数的数字。
            $(this).parent().parent().next().html('&yen; ' + (price * count).toFixed(2));
            // 计算总价格
            calcTotal();
        });

        // 为商品数量文本框绑定改变事件回调
        $(".single-item input[type='text']").on("change", function () {
            //这里的this为 商品数量的输入框
            $(this).parent().parent().find("input[name='check_item']").prop("checked", true);
            var count = parseInt($(this).val());
            if (count != $(this).val() || count < 1 || count > 99) {
                layer.msg("无效的商品数量", {
                    time: 1500,
                    skin: 'warningMsg'
                });
                count = 1;
                $(this).val(count);
                //TODO:从文本框找到隐藏域的元素，拿到对应的cart id值
                var id = $(this).prev().prev().val();
                //发送ajax 请求，更新商品数量
                updateProductNum(id, count);
            }

            //TODO:从文本框找到隐藏域的元素，拿到对应的cart id值
            var id = $(this).prev().prev().val();
            //发送ajax 请求，更新商品数量
            updateProductNum(id, count);

            var price = parseFloat($(this).parent().parent().prev().find('span').text());
            $(this).parent().parent().next().html('&yen;' + (price * count).toFixed(2));
            calcTotal();
        });
    });

    //显示移除选中商品的提示框，并且计算选择的cartId
    function removeCart() {
        //找到被选中的所有的项，这里需要注意排除 checkAll的那个 checkbox
        var selects = $(".single-item input:checked");
        var cartIds = [];
        for (var i = 0; i < selects.length; i++) {
            cartIds.push(selects[i].value);
        }
        cartIds = cartIds.join(",");
        // console.log(cartIds);
        //将cartIds 给 modal
        $("#cartIds").val(cartIds);
        $("#removeMoreProductModal").modal("show");
    }

    // 只删除一个商品
    function removeOneProduct() {
        var cartId = $("#cartId").val();
        $.ajax({
            url: "${APP_PATH}/cart/removeOneProduct",
            type: "POST",
            data: "cartId=" + cartId,
            success: function (result) {
                if (result.code == 200) {
                    location.reload();   // 刷新页面
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: 'errorMsg'
                    });
                }
            }
        });
    }

    // 删除多个商品，多个id，需要封装 cartId
    // <foreach collection="array" item="ids" index="no" open="(" separator="," close=")">
    // join(","), mapper文件用 separator="," 切割
    function removeCart() {
        var chooseChecks = $(".single-item input:checked");
        var cartIds = [];
        for (var i = 0; i < chooseChecks.length; i++) {
            cartIds.push(chooseChecks[i].value);
        }
        cartIds = cartIds.join(",");
        // 把选中的 id 拼接值赋值给这个id，拿到后传入后端处理
        $("#cartIds").val(cartIds);
        $("#removeMoreProductModal").modal("show");
    }

    // 删除选中的商品
    function removeMoreProduct() {
        // 多个id传值，需要先封装数据，无法使用 id 绑定属性，会丢失数据，只能拿到第一个
        var cartIds = $("#cartIds").val();
        var len = cartIds.length;
        if (len > 0) {
            $.ajax({
                url: "${APP_PATH}/cart/removeMoreProduct",
                type: "POST",
                data: "cartIds=" + cartIds,
                success: function (result) {
                    if (result.code == 200) {
                        location.reload();
                    } else {
                        layer.msg(result.extend.vag, {
                            time: 1500,
                            skin: 'errorMsg'
                        });
                    }
                }
            });
        } else {
            layer.msg("请选择要删除的商品", {
                time: 1500,
                skin: 'warningMsg'
            });
        }
    }

    //购物车页面商品数量改变则更新商品数量
    function updateProductNum(cartId, productNum) {
        //发送ajax 异步请求，更新购物车中最终的商品数量
        $.ajax({
            url: "${APP_PATH}/cart/updateProductNum",
            data: {
                "cartId": cartId,
                "productNum": productNum
            },
            success: function (result) {
                if (result.code == 200) {
                    /* layer.msg(result.extend.vag, {
                         time: 1500,
                         skin: 'successMsg'
                     });*/
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: 'errorMsg'
                    });
                }
            }
        });
    }

    //清空购物车中所有的商品
    function removeAllProduct() {
        $.ajax({
            url: "${APP_PATH}/cart/removeAllProduct",
            type: "POST",
            success: function (result) {
                if (result.code == 200) {
                    location.href = "${APP_PATH}/cart/showShopCarts";
                } else {
                    layer.msg(result.extend.vag, {
                        time: 1500,
                        skin: 'errorMsg'
                    });
                }
            }
        });
    }

    //结算购物车
    function calculationAccounts() {
        var orderCartIds = [];
        var selects = $(".single-item input:checked");

        for (var i = 0; i < selects.length; i++) {
            orderCartIds.push(selects[i].value);
        }
        //获取选中的cartid 数组 24,26,15...
        orderCartIds = orderCartIds.join(",");

        var count = $("#totalCount").text();
        console.log("count="+count);

        // 价格后台需要把 ”￥“切割
        var price = $("#totalPrices").text();
        console.log("price="+price);
        //alert("price = " + price);

        if (selects.length == 0) {
            layer.msg("请选择要购买的商品", {
                time: 1500,
                skin: 'warningMsg'
            });
        } else {
            $.ajax({
                url: "${APP_PATH}/cart/addOrderItem",
                type: "POST",
                data: {
                    "count": count,
                    "price": price,
                    "orderCartIds": orderCartIds
                },
                success: function (result) {
                    if (result.code == 200) {
                        location.href = "${APP_PATH}/order/myCartOrder";
                    }
                }
            });
        }
    }

    // 计算总的价格
    function calcTotal() {
        var checkBoxes = $("input[name='check_item']");
        var priceSpans = $(".single-item .price");
        var countInputs = $(".single-item .textBox");
        var totalCount = 0;
        var totalPrice = 0;
        for (var i = 0; i < priceSpans.length; i += 1) {
            // 复选框被勾中的购物车项才进行计算
            if ($(checkBoxes[i]).prop("checked")) {
                var price = parseFloat($(priceSpans[i]).text());
                var count = parseInt($(countInputs[i]).text());
                totalCount += count;
                totalPrice += price * count;
                console.log("i=" + i + ",price=" + price + ",count=" + count);
            }
        }
        //显示计算后的总价以及选中的商品总数量
        $('#totalCount').text(totalCount);
        $('#totalPrices').html(totalPrice.toFixed(2));
    }

    //继续 购物，跳转到商品主页面
    function goToShopping() {
        location.href = "${APP_PATH}/product/searchAllProducts";
    }

    //显示清空购物车确认框
    function clearAll() {
        $("#removeAllProductModal").modal("show");
    }

    //显示从购物车删除某一个商品确认框
    function clearOneProduct(id) {
        $("#cartId").val(id);
        $("#removeOneProductModal").modal("show");
    }

</script>

</html>