<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />


    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <!--  PAGINATION plugin jquery/bs_pagination-master/css/-->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <script>
        showProducts = function (page, count) {
            let urlParams = "?page="+page+"&count="+count;

            $.ajax({
                url: "workbench/product/list.do"+urlParams,
                type: "get",
                success: function (responseText) {
                    console.log(responseText);
                    let html = "";
                    $.each(responseText.activity, function (index, object) {
                        html += "<tr><td><input type=\"checkbox\" value=\""+object.id+"\"/></td>";
                        html += "<td><a  href=\"/settings/qx/user/detail.do?id=" + object.id + "\">" + object.name + "</a></td>";
                        html += "<td>" + object.price + "</td>";
                        html += "<td>" + object.describe + "</td>";
                        html += "<td>" + object.createBy + "</td>";
                    });
                    console.log(html);
                    $("#productForm").html(html);
                    $("#allCheck").prop("checked", false);
                    let total = 1;
                    if (responseText.amount % count == 0) {
                        total = responseText.amount / count;
                    } else {
                        total = parseInt(responseText.amount / count) + 1;
                    }
                    $("#pagination").bs_pagination({
                        currentPage: page,
                        rowsPerPage: count,
                        totalPages: total,
                        totalRows: responseText.amount,

                        visiblePageLinks: 5,

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,

                        onChangePage: function (event, object) { // returns page_num and rows_per_page after a link has clicked
                            showUsers(object.currentPage, object.rowsPerPage);
                        }
                    });
                }
            });
        }


        $(function (){
            showProducts(1,10);
            $(".mydate").datetimepicker({
                language:'zh-CN',
                format:'yyyy-mm-dd',
                minView:'month',
                initialDate:new Date(),
                autoclose:true,
                todayBtn:true
            });
        })
    </script>

</head>
<body>

<!-- 创建用户的模态窗口 -->
<div class="modal fade" id="createUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">新增用户</h4>
            </div>
            <div class="modal-body">

                <form id="createUserForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-loginActNo">
                        </div>
                        <label for="create-username" class="col-sm-2 control-label">用户姓名</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-username">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-loginPwd">
                        </div>
                        <label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-confirmPwd">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-expireTime">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-lockStatus">
                                <option></option>
                                <option value="1">启用</option>
                                <option value="0">锁定</option>
                            </select>
                        </div>
                        <label for="create-org" class="col-sm-2 control-label">部门<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-org">
                                <option></option>
                                <c:forEach items="${requestScope.roles}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-allowIps" style="width: 280%"
                                   placeholder="多个用逗号隔开">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveButton" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>产品列表</h3>
        </div>
    </div>
</div>

<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">产品名称</div>
                <input id="name" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">创建人</div>
                <input id="role" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;

        <button id="queryUser" type="button" class="btn btn-default">查询</button>

    </form>
</div>


<div class="btn-toolbar" role="toolbar"
     style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="addButton" type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="deleteButton" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
    <div class="btn-group" style="position: relative; top: 18%; left: 5px;">
        <button type="button" class="btn btn-default">设置显示字段</button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul id="definedColumns" class="dropdown-menu" role="menu">
            <li><a href="javascript:void(0);"><input type="checkbox"/> 产品名称</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 创建人</a></li>
        </ul>
    </div>
</div>

<div style="position: relative; left: 30px; top: 40px; width: 110%">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox"/></td>
            <td>序号</td>
            <td>产品名称</td>
            <td>价格</td>
            <td>描述</td>
            <td>创建人</td>
        </tr>
        </thead>
        <tbody id="productForm">

        </tbody>
    </table>
    <div id="pagination"></div>
</div>
</body>
</html>