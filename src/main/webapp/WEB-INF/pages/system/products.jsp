<%@ page contentType="text/html;charset=UTF-8" language="java"
         pageEncoding="utf-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>果蔬配送后台首页</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <script src="${APP_PATH}/static/js/jquery/jquery-3.3.1.js"></script>
    <script src="${APP_PATH}/static/front-jquery/jquery.min.js"></script>
    <script src="${APP_PATH}/static/layer/layer.js"></script>
    <script src="${APP_PATH}/static/js/bootstrapValidator.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script src="${APP_PATH}/static/js/bootstrap-paginator.js"></script>
    <script src="${APP_PATH}/static/js/template.js"></script>
    <script src="${APP_PATH}/static/js/toastr.js"></script>

    <link rel="stylesheet" href="${APP_PATH}/static/css/bootstrap/bootstrapValidator.min.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${APP_PATH}/static/css/layer-style.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/toastr.css"/>
    <link rel="stylesheet" href="${APP_PATH}/static/css/sweetalert.css"/>


</head>

<body>

<%--  模糊查询功能已经实现--%>
<div class="panel panel-default" style="width: auto;height: 100%">
    <div class="panel-heading">
        <h3 class="panel-title">商品管理</h3>
    </div>
    <div class="panel-body">
        <div class="deliverSearch">
            <button class="btn btn-primary" id="add_model_btn" style="margin-left: 2%; text-align: center">新增商品</button>
        </div>
        <%-- table --%>
        <div class="show-list text-center" style="position: relative;top: 30px;">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">商品编号</th>
                    <th class="text-center">商品名称</th>
                    <th class="text-center">商品价格</th>
                    <th class="text-center">商品类型</th>
                    <th class="text-center">商品状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${pageInfo.list}" var="product">
                    <tr>
                        <td>${product.id}</td>
                        <td>${product.name}</td>
                        <td>${product.price}</td>
                        <td>${product.productType.name}</td>
                        <td>
                            <c:if test="${product.productType.status == 1}">有效商品</c:if>
                            <c:if test="${product.productType.status == 0}">无效商品</c:if>
                        </td>
                        <td class="text-center">
                            <input type="button" class="btn btn-primary btn-sm doModify"
                                   onclick="updateProduct(${product.id})" value="修改">
                            <button class="btn btn-danger btn-sm" onclick="deleteProduct(${product.id})">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pagination">

            </ul>
        </div>
    </div>
</div>

<%-- 新增模态框 --%>
<div class="modal fade" tabindex="-1" id="Product">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="${APP_PATH}/admin/product/upload" method="post" class="form-horizontal"
              enctype="multipart/form-data" id="addProductForm">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">添加商品</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-8">
                        <div class="form-group">
                            <%--TODO:隐藏域存放当前页码--%>
                            <input type="hidden" name="pageNum" value="${pageInfo.pageNum}">
                            <label for="product-name" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-name" name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-price" name="price">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-image" class="col-sm-4 control-label">商品图片：</label>
                            <div class="col-sm-8">
                                <a href="javascript:;" class="file">  <%-- accept: 限制文件上传类型 --%>
                                    <input type="file" name="file" id="product-image"
                                           accept="image/jpeg,image/png,image/jpg">
                                </a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-info" class="col-sm-4 control-label">商品描述：</label>
                            <div class="col-sm-8">
                                <textarea id="product-info" class="form-control" name="info"
                                          style="height: 55px;width: 370px;resize: none"
                                          placeholder="请输入商品简介"></textarea>
                                <p class="text  text-warning"><span id="add-count">30</span>/30</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-info" class="col-sm-4 control-label">商品数量：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-number" name="shopNumber">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-type" class="col-sm-4 control-label">商品类型：</label>
                            <div class="col-sm-8">
                                <select class="form-control" name="productTypeId" id="product-type">
                                    <option value="">--请选择--</option>
                                    <c:forEach items="${productTypes}" var="productType">
                                        <option value="${productType.id}">${productType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <!-- 显示图像预览 -->
                        <img style="width: 160px;height: 180px;" id="img">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" type="submit">添加</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 修改  -->
<div class="modal fade" tabindex="-1" id="myProduct">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="${APP_PATH}/admin/product/modifyProduct" method="post"
              enctype="multipart/form-data" class="form-horizontal" id="modifyProductForm">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">修改商品</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-8">
                        <div class="form-group">
                            <%--TODO:隐藏域存放当前页码--%>
                            <input type="hidden" name="pageNum" value="${pageInfo.pageNum}">
                            <label for="pro-num" class="col-sm-4 control-label">商品编号：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-num" name="id" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-name" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-name" readonly name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-price" name="price">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品数量：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-shopNumber" name="shopNumber">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-image" class="col-sm-4 control-label">商品图片：</label>
                            <div class="col-sm-8">
                                <a class="file">
                                    <input type="file" name="file" id="pro-image" accept="image/jpeg,image/png,image/jpg">
                                </a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-info" class="col-sm-4 control-label">商品描述：</label>
                            <div class="col-sm-8">
                                <textarea id="info" class="form-control" name="info"
                                          style="height: 55px;width: 370px;resize: none"
                                          placeholder="请输入商品简介"></textarea>
                                <p class="text text-warning"><span id="modify-count">30</span>/30</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-type" class="col-sm-4 control-label">商品类型：</label>
                            <div class="col-sm-8">
                                <select class="form-control" id="pro-TypeId" name="productTypeId">
                                    <option value="">--请选择--</option>
                                    <c:forEach items="${productTypes}" var="productType">
                                        <option value="${productType.id}">${productType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <!-- 显示图像预览 -->
                        <img style="width: 160px;height: 180px;" id="img2">
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="hidden" id="updateId" value="${product.id}">
                    <button type="submit" class="btn btn-primary">确认</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- 确认删除商品  -->
<div class="modal fade" tabindex="-1" id="deleteProductModal">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-sm">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">提示消息</h4>
            </div>
            <div class="modal-body text-center row">
                <h5 class="text-center text-warning">确认要删除该商品吗？</h5>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="deleteProductId">
                <button class="btn btn-primary" data-dismiss="modal" id="delete_btn">确认</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<%-- js --%>
<script>

    $(function () {
        /*bootstrapMajorVersio:
       搭配使用的bootstrap版本，
       如果bootstrap的版本是2.X的分页必须使用div元素。 3.X分页的必须使用ul>li元素。
       注意与bootstrap版本对应上。*/
        $('#pagination').bootstrapPaginator({
            bootstrapMajorVersion: 3,
            currentPage:${pageInfo.pageNum},
            totalPages:${pageInfo.pages},
            numberOfPages:${pageInfo.pageSize},
            pageUrl: function (type, page, current) {
                return '${APP_PATH}/admin/product/getAllProducts?pageNum=' + page;
            },
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
            }
        });

        // 新增商品
        $('#addProductForm').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    validators: {
                        notEmpty: {
                            message: '商品名称不能为空'
                        },
                        //TODO:bootstrapValidator 校验 插件 remote 校验会自己读取响应的 valid 的值 和message的
                        remote: {   //校测名称是否存在
                            type: 'post',   //注意，请求方式一定要指定，默认为put,当参数传中文的时候会出现乱码
                            url: '${APP_PATH}/admin/product/checkProductName'
                        }
                    }
                },
                price: {
                    validators: {
                        notEmpty: {
                            message: '商品价格不能为空'
                        },
                        regexp: {
                            //商品价格校验的正则表达式
                            regexp: /(^[1-9]\d*(\.\d{1,2})?$)|(^0(\.\d{1,2})?$)/,
                            message: '商品价格不正确'
                        }
                    }
                },
                file: {
                    validators: {
                        notEmpty: {
                            message: '请选择商品的图片'
                        }
                    }
                },
                info: {
                    validators: {
                        notEmpty: {
                            message: '商品简介信息不能为空'
                        },
                        stringLength: {
                            min: 15,
                            message: '建议字数不少于15字数'
                        }
                    }
                },
                productTypeId: {
                    validators: {
                        notEmpty: {
                            message: '请选择一种商品类型'
                        }
                    }
                }
            }
        });

        // 更新
        $('#modifyProductForm').bootstrapValidator({
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                price: {
                    validators: {
                        notEmpty: {
                            message: '商品价格不能为空'
                        },
                        regexp: {
                            //商品价格校验的正则表达式
                            regexp: /(^[1-9]\d*(\.\d{1,2})?$)|(^0(\.\d{1,2})?$)/,
                            message: '商品价格不正确'
                        }
                    }
                },
                info: {
                    validators: {
                        notEmpty: {
                            message: '商品简介信息不能为空'
                        },
                        stringLength: {
                            min: 15,
                            message: '建议字数不少于15字数'
                        }
                    }
                },
                shopNumber: {
                    validators: {
                        notEmpty: {
                            message: '数量不能空'
                        }
                    }
                },
                productTypeId: {
                    validators: {
                        notEmpty: {
                            message: '请选择一种商品类型'
                        }
                    }
                }
            }
        });


        //上传图像预览
        $('#product-image').on('change', function () {
            $('#img').attr('src', window.URL.createObjectURL(this.files[0]));
        });
        $('#pro-image').on('change', function () {
            $('#img2').attr('src', window.URL.createObjectURL(this.files[0]));
        });

        //清除校验信息
        $('#Product').on('hide.bs.modal', function () {
            $('#addProductForm')[0].reset();
            $('#addProductForm').bootstrapValidator('resetForm');
        });

        //显示服务端的提示消息
        var successMsg = '${successMsg}';
        var failMsg = '${failMsg}';
        var errorMsg = '${errorMsg}';
        //成功保存商品信息提示
        if (successMsg != '') {
            layer.msg(successMsg, {
                time: 1000,
                area: '100px',
                skin: 'successMsg'
            });
        }
        //保存商品信息失败提示
        if (failMsg != '') {
            layer.msg(failMsg, {
                time: 1500,
                area: '100px',
                skin: 'errorMsg'
            });
        }
        //文件上传失败提示
        if (errorMsg != '') {
            layer.msg(errorMsg, {
                time: 1500,
                area: '100px',
                skin: 'errorMsg'
            });
        }

        //控制添加商品的 textarea 的字数
        $('#product-info').on('input propertychange', function () {
            var $this = $(this),
                _val = $this.val(),
                count = "";
            if (_val.length > 30) {
                $this.val(_val.substring(0, 30));
            }
            count = 30 - $this.val().length;
            $("#add-count").text(count);
        });

        //控制修改商品的 textarea 的字数
        $('#info').on('input propertychange', function () {
            var $this = $(this),
                _val = $this.val(),
                count = "";
            if (_val.length > 30) {
                //超过的字数截取掉
                $this.val(_val.substring(0, 30));
            }
            //计算剩余的字数
            count = 30 - $this.val().length;
            //显示剩余的字数
            $("#modify-count").text(count);
        });

    });

    // 打开新增模态框
    $("#add_model_btn").click(function () {
        $("#Product").modal({
            backdrop: "static"
        });
    })

    // 删除模态框
    function deleteProduct(id) {
        $("#deleteProductId").val(id);
        $("#deleteProductModal").modal({
            backdrop: "static"
        });
    }

    // 修改
    function updateProduct(id) {
        $("#updateId").val(id);
        // 放数据到编辑框
        getProduct(id);
        console.log("id="+id);
        $("#myProduct").modal({
            backdrop: "static"
        });
    }

    // 显示编辑信息
    function getProduct(id) {
        console.log("id="+id);
        $.ajax({
            url: "${APP_PATH}/admin/product/findProductById",
            type: "GET",
            data: "id=" + id,
            success: function (result) {
                if (result.code == 200) {
                    var productData = result.extend.product;
                    $('#pro-num').val(productData.id);
                    $('#pro-name').val(productData.name);
                    $('#pro-price').val(productData.price);
                    $("#pro-shopNumber").val(productData.shopNumber);
                    $('#info').val(productData.info);
                    $('#pro-TypeId').val(productData.productType.id);
                    $('#img2').attr('src', productData.image);

                }
            }
        });
    }


    // 删除执行
    $("#delete_btn").click(function () {
        var id = $("#deleteProductId").val();
        $.ajax({
            url: "${APP_PATH}/admin/product/removeProductById",
            type: "POST",
            data: "id=" + id,
            success: function (result) {
                if (result.code == 200) {
                    $("#deleteProductModal").modal("hide");
                    layer.msg(result.extend.v_vag, {
                        time: 1500,
                        skin: "successMsg"
                    }, function () {
                        location.reload();
                    });
                } else {
                   /* layer.msg(result.extend.v_vag, {
                        time: 1500,
                        skin: "errorMsg"
                    });*/
                }
            }
        });
    });

</script>
</body>

</html>