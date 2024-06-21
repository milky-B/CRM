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
				url: "/settings/qx/role/list",
				type: "get",
				data:{
					page:page,
					pageSize:count
				},
				success: function (responseText) {
					console.log(responseText.data);
					let html = "";
					$.each(responseText.data, function (index, object) {
						html+="<tr>";
						html+="<td><input type=\"checkbox\" /></td>"
						html+="<td>"+index+"</td>";
						html+="<td><a href=\"javascript:void(0);\" style=\"text-decoration: none;\">"+object.unionId+"</a></td>";
						html+="<td>"+object.name+"</td>";
						html+="<td>"+object.description+"</td></tr>";
					});
					console.log(html);
					$("#roleForm").html(html);
					let total = 1;
					if (responseText.total % count == 0) {
						total = responseText.total / count;
					} else {
						total = parseInt(responseText.total / count) + 1;
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

	<!-- 创建角色的模态窗口 -->
	<div class="modal fade" id="createRoleModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增角色</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-roleCode" class="col-sm-2 control-label">代码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-roleCode" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-roleName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-roleName" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 65%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>角色列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createRoleModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>序号</td>
					<td>代码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="roleForm">

			</tbody>
		</table>
		<div id="pagination"></div>
	</div>
			
</body>
</html>