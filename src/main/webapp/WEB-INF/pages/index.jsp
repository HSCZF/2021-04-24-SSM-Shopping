<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>SSM商城前台首页</title>    
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/js/bootstrap-paginator.js"></script>
    <script src="${APP_PATH}/static/js/front-shop.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/style1.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/iconfont/icon_font/iconfont.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/cl-style.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/animate.min.css">

    <style type="text/css">
        #cl {
            width: auto;
            height: auto;
        }
        .product-controller{
            height: 300px;
        }
    </style>

<script>
    $(function () {
        $('#cl').carousel({
            interval: '1500',   //设置自动播放的间隔时间
            pause: null,        //当鼠标悬停在图片上时是否暂停播放
            wrap: true          //设置是否循环播放
        });

        /*bootstrapMajorVersio:
          搭配使用的bootstrap版本，
          如果bootstrap的版本是2.X的分页必须使用div元素。 3.X分页的必须使用ul>li元素。
          注意与bootstrap版本对应上。*/
        /*$("#pagination").bootstrapPaginator({
            bootstrapMajorVersion: 3,
            currentPage: ${pageInfo.pageNum},   // 设置当前页。
            totalPages: ${pageInfo.pages},      // 设置总页数。
            numberOfPages: ${pageInfo.pageSize}, // 设置控件显示的页码数。即：类型为“page”的操作按钮数量。
            itemTexts: function (type, page, current) {
                switch (type) {
                    case 'first':
                        return '首页';
                    case 'prev':
                        return '上一页';
                    case 'next':
                        return '下一页';
                    case 'last':
                        return '末页';
                    case 'page':
                        return page;
                }
            }, onPageClicked: function (event, originalEvent, type, page) {
                $("#pageNum").val(page);
                $("#userFormSearch").submit();
            }
        });
*/

    // 搜索校验
    $("#userFormSearch").bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    validators: {
                        stringLength: {
                            max: 20,
                            message: '长度最多20'
                        }
                    }
                },
                minPrice: {
                    validators: {
                        stringLength: {
                            max: 5,
                            message: '超出价格长度'  /* /^[+-]?\d+(\.\d+)?$|^$|^(\d+|\-){7,}$/  */
                        },
                        regexp: {
                            regexp: '(^([1-9][0-9]*)$)|(^\\d+(\\.\\d+)?$)',
                            message: '只能是整数或完整的小数'
                        }
                        /*digits: {
                            message: '该值只能包含数字'
                        }*/
                    }
                },
                maxPrice: {
                    validators: {
                        stringLength: {
                            max: 5,
                            message: '输入长度超出'
                        },
                        regexp: {
                            regexp: '(^([1-9][0-9]*)$)|(^\\d+(\\.\\d+)?$)',
                            message: '只能是整数或完整的小数'
                        }
                    }
                }
            }
        });

    });

    //展示商品详情
    function showProductDetail(id) {
        location.href = '${APP_PATH}/product/showProductDetail?id=' + id;
    }
</script>

</head>
<body class="animated fadeIn">
<div id="wrapper" style="margin-top: 50px">
    <!-- 导航栏  -->
    <jsp:include page="head.jsp">
        <jsp:param name="num" value="1"/>
    </jsp:include>

    <%--轮播图--%>
   <%-- <div style="background-color: #fafafa">--%>

        <%-- 不好看倒是真的 --%>
        <%--<div class="container" style="margin-top: 67px;">
            <div id="cl" class="carousel col-sm-3" data-ride="carousel">
                <ul class="carousel-indicators">
                    <li data-target="#cl" data-slide-to="0" class="active"></li>
                    <li data-target="#cl" data-slide-to="1"></li>
                    <li data-target="#cl" data-slide-to="2"></li>
                    <li data-target="#cl" data-slide-to="3"></li>
                </ul>
                <!--滑块-->
                <div class="carousel-inner" style="height: 220px">
                    <div class="item active">
                        <img src="${APP_PATH}/static/images/p1.jpg" style="width: 1320px; height: 280px" alt="">
                    </div>
                    <div class="item">
                        <img src="${APP_PATH}/static/images/p2.jpg" style="width: 1320px; height: 280px" alt="">
                    </div>
                    <div class="item">
                        <img src="${APP_PATH}/static/images/p3.jpg" style="width: 1320px; height: 280px" alt="">
                    </div>
                    <div class="item">
                        <img src="${APP_PATH}/static/images/banner4.jpg" style="width: 1320px; height: 280px" alt="">
                    </div>
                </div>
                <a href="#cl" class="carousel-control left" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                </a>
                <a href="#cl" class="carousel-control right" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                </a>
            </div>
        </div>--%>
<div class="panel panel-default" style="width: auto;height: 100%">
        <div class="panel-heading">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="page-header" style="margin-bottom: 0px;">
                            <h3 style="color: #48900F">贺州市果蔬热卖中</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    <div class="panel-body">
        <%-- 查询条件部分 --%>
        <div class="container" >
            <div class="container" >
                <div class="row">
                    <div class="col-xs-12">
                        <form class="form-inline hot-search"
                              action="${APP_PATH}/product/getAllParams"
                              method="post" id="userFormSearch">
                            <div class="form-group">
                                <label class="control-label">商品：</label>
                                <input type="text" class="form-control" placeholder="商品名称" name="name" value="${params.name}">
                                <input type="hidden" name="pageNum" value="${pageInfo.pageNum}" id="pageNum">
                            </div>
                            &nbsp;
                            <div class="form-group">
                                <label class="control-label">价格：</label>
                                <input type="text" class="form-control" placeholder="最低价格" name="minPrice" value="${params.minPrice}" > --
                                <input type="text" class="form-control" placeholder="最高价格" name="maxPrice" value="${params.maxPrice}">
                            </div>
                            &nbsp;
                            <div class="form-group">
                                <label class="control-label">种类：</label>
                                <select class="form-control input-sm" name="productTypeId">
                                    <option value="-1" selected="selected">查询全部</option>
                                    <c:forEach items="${productTypes}" var="productType">
                                        <option value="${productType.id}">${productType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            &nbsp;
                            <div class="form-group">
                                <button type="submit" class="btn btn-warning">
                                    <i class="glyphicon glyphicon-search"></i> 查询
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <%--</div>--%>
        <div class="content-back">
            <div class="container" id="a">
                <div class="row">
                    <c:forEach items="${pageInfo.list}" var="product">
                        <div class="col-xs-3  hot-item" id="showDetail" onclick="showProductDetail(${product.id})"
                             style="cursor: pointer;">
                            <div class="panel clear-panel">
                                <div class="panel-body">
                                    <div class="art-back clear-back product-controller">
                                        <div class="add-padding-bottom">
                                            <img src="${APP_PATH}${product.image}" class="shopImg">
                                        </div>
                                        <h4 class="myH4"><a href="#">${product.name}</a></h4>
                                        <div class="user clearfix pull-right"><span>¥ </span>${product.price}</div>
                                        <div>
                                            <a class="my" href="#">${product.info}</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <ul id="pagination">

            </ul>
        </div>
    </div>
</div>
</div>


</body>
</html>
