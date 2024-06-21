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
        showUsers = function (page, count) {
            $.ajax({
                url: "/workbench/log/list.do?count="+count+"&page="+page,
                type: "get",
                success: function (responseText) {
                    console.log(responseText);
                    let html = "";
                    $.each(responseText.activity, function (index, object) {
                        html+="<tr>";
                        html+="<td>"+index+"</td>";
                        html+="<td>"+object.describe+"</td>";
                        html+="<td>"+object.userName+"</td></tr>";
                    });
                    console.log(html);
                    $("#logForm").html(html);
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
            showUsers(1,10);
        })
    </script>
</head>
<body>
<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>动态列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">操作内容</div>
                <input id="name" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">操作人</div>
                <input id="role" class="form-control" type="text">
            </div>
        </div>

        <button id="queryUser" type="button" class="btn btn-default">查询</button>

    </form>
</div>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>操作动态</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox" /></td>
            <td>操作内容</td>
            <td>操作人</td>
        </tr>
        </thead>
        <tbody id="logForm">

        </tbody>
    </table>
    <div id="pagination"></div>
</div>

</body>
</html>