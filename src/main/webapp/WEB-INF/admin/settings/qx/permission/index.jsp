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

	<SCRIPT type="text/javascript">

		showEnums = function (page, count) {
			$.ajax({
				url: "/settings/qx/enum/list",
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
						html+="<td style='width: 50px' ><input type=\"checkbox\" /></td>"
						html+="<td style='width: 50px' >"+index+"</td>";
						html+="<td style='width: 100px'><a href=\"javascript:void(0);\" style=\"text-decoration: none;\">"+object.name+"</a></td>";
						html+="<td style='width: 100px'>"+object.parentName+"</td>";
						html+="<td style='width: 230px'>"+object.path+"</td>";
						html+="<td style='width: 150px'>"+object.icon+"</td>";
						html+="<td style='width: 100px'>"+object.perms+"</td></tr>";
					});
					console.log(html);
					$("#enumForm").html(html);
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
							showEnums(object.currentPage, object.rowsPerPage);
						}
					});
				}
			});
		}
		$(function (){
			showEnums(1,10);
		})
	var setting = {
		edit: {
			enable : true,
			showRenameBtn : false,
			showRemoveBtn : true
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};

	var zNodes =[
		{ id:0, name:"CRM" , open : true},
		{ id:1, pId:0, name:"市场活动" , open : true},
		{ id:11, pId:1, name:"创建市场活动"},
		{ id:12, pId:1, name:"修改市场活动"},
		{ id:13, pId:1, name:"删除市场活动"},
		{ id:2, pId:0, name:"线索"},
		{ id:21, pId:2, name:"创建线索"},
		{ id:22, pId:2, name:"修改线索"},
		{ id:23, pId:2, name:"删除线索"},
		{ id:3, pId:0, name:"客户"},
		{ id:31, pId:3, name:"创建客户"},
		{ id:32, pId:3, name:"修改客户"},
		{ id:33, pId:3, name:"删除客户"},
		{ id:4, pId:0, name:"联系人"},
		{ id:41, pId:4, name:"创建联系人"},
		{ id:42, pId:4, name:"修改联系人"},
		{ id:43, pId:4, name:"删除联系人"},
		{ id:5, pId:0, name:"交易"},
		{ id:51, pId:5, name:"创建交易"},
		{ id:52, pId:5, name:"修改交易"},
		{ id:53, pId:5, name:"删除交易"},
		{ id:6, pId:0, name:"售后回访"},
		{ id:61, pId:6, name:"创建任务"},
		{ id:62, pId:6, name:"修改任务"},
		{ id:63, pId:6, name:"删除任务"},
		{ id:7, pId:0, name:"统计图表"},
		{ id:71, pId:7, name:"市场活动统计图表"},
		{ id:72, pId:7, name:"线索统计图表"},
		{ id:73, pId:7, name:"客户和联系人统计图表"},
		{ id:74, pId:7, name:"交易统计图表"},
		{ id:8, pId:0, name:"系统设置"},
		{ id:81, pId:8, name:"权限管理"},
		{ id:811, pId:81, name:"许可维护"},
		{ id:8111, pId:811, name:"新增许可"},
		{ id:8112, pId:811, name:"修改许可"},
		{ id:8113, pId:811, name:"删除许可"},
		{ id:812, pId:81, name:"角色维护"},
		{ id:8121, pId:812, name:"新增角色"},
		{ id:8122, pId:812, name:"修改角色"},
		{ id:8123, pId:812, name:"删除角色"},
		{ id:813, pId:81, name:"用户维护"},
		{ id:8131, pId:813, name:"新增用户"},
		{ id:8132, pId:813, name:"修改用户"},
		{ id:8133, pId:813, name:"删除用户"}
		
	];
	
	$(document).ready(function(){
		$.fn.zTree.init($("#treeDemo"), setting, zNodes);
	});
	
</SCRIPT>
	
</head>
<body>

<div>
	<div style="position: relative; left: 30px; top: -10px;">
		<div class="page-header">
			<h3>菜单列表</h3>
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
			<td style='width: 50px'><input type="checkbox" /></td>
			<td style='width: 50px'>序号</td>
			<td style='width: 100px'>名称</td>
			<td style='width: 100px'>父标签名称</td>
			<td style='width: 230px'>url</td>
			<td style='width: 150px'>icon</td>
			<td style='width: 100px'>perms</td>
		</tr>
		</thead>
		<tbody id="enumForm">

		</tbody>
	</table>
	<div id="pagination"></div>
</div>
</body>
</html>