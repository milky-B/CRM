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
<script type="text/javascript">
	showTransaction = function (page,count){
		let owner = $.trim($("#query-owner").val());
		let name = $.trim($("#query-name").val());
		let customerName = $("#query-customerName").val();
		let stage = $("#query-stage").val();
		let type = $("#query-type").val()
		let source = $("#query-clueSource").val();
		let contactsId = $.trim($("#query-fullname").val());
		$.ajax({
			url:'workbench/transaction/queryTransaction.do',
			data:{
				owner:owner,
				name:name,
				customerName:customerName,
				stage:stage,
				type:type,
				source:source,
				contactsId:contactsId,
				page:page,
				count:count
			},
			type:'post',
			dataType:'json',
			success:function (responseText){
				html=""
				$.each(responseText.transactions,function (index,transaction){
					html+="<tr><td><input value=\""+this.id+"\" type=\"checkbox\" /></td>"
					html+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/detail.do?id="+this.id+"';\">"+this.name+"</a></td>"
					html+="<td>"+this.customerId+"</td>"
					html+="<td>"+this.stage+"</td>"
					html+="<td>"+this.type+"</td>"
					html+="<td>"+this.owner+"</td>"
					html+="<td>"+this.source+"</td>"
					html+="<td>"+this.contactsId+"</td></tr>"
				});
				$("#tranBody").html(html);
				$("#allCheckbox").prop("checked",false);
				let totalpages;
				if(responseText.amount%count==0){
					totalpages=responseText.amount/count;
				}else {
					totalpages=parseInt(responseText.amount/count)+1;
				}
				$("#pagination").bs_pagination({
					currentPage: page,
					rowsPerPage: count,
					totalPages: totalpages,
					totalRows: responseText.amount,

					visiblePageLinks: 5,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,

					onChangePage: function(event,object) { // returns page_num and rows_per_page after a link has clicked
						//showActivities(object.currentPage,object.rowsPerPage);
						showTransaction(object.currentPage,object.rowsPerPage);
					}
				});
			}
		});

	}

	$(function(){
		showTransaction(1,10);
		$("#allCheckbox").click(function (){
			$("#tranBody input[type=checkbox]").prop("checked",$("#allCheckbox").prop("checked"));
		})
		$("#tranBody").on('click','input[type=checkbox]',function (){
			if($("#tranBody input[type=checkbox]").length==$("#tranBody input[type=checkbox]:checked")){
				$("#allCheckbox").prop("checked",true);
				return;
			}
			$("#allCheckbox").prop("checked",false);
		})

		$("#queryTransactionBtn").click(function (){
			showTransaction(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
		});
		$("#deleteTransactionBtn").click(function (){
			let checkedBox = $("#tranBody input[type=checkbox]:checked");
			if(checkedBox.length==0){
				alert("请选择要删除的交易");
				return;
			}
			if(window.confirm("确认删除吗?")){
				let id="";
				$.each(checkedBox,function (){
					id="id="+this.value+"&"
				});
				id=id.substring(0,id.length-1);
				$.ajax({
					url:'workbench/transaction/deleteTran.do',
					type:'post',
					dataType: 'json',
					data:id,
					success:function (responseText){
						if(responseText.code=="0"){
							alert("系统忙请稍后再试");
							return;
						}
						showTransaction(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}
				})
			}
		});
		$("#editTranBtn").click(function (){
			let checkedBox = $("#tranBody input[type=checkbox]:checked");
			if(checkedBox.length==0){
				alert("请选择要修改的交易");
				return;
			}
			let id = checkedBox.get(0).value;
			let path = 'workbench/transaction/edit.do?id='+id
			window.location.href=path;
		});
	});
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">所有者</div>
							<input id="query-owner" class="form-control" type="text">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">交易名称</div>
							<input id="query-name" class="form-control" type="text">
						</div>
					</div>

					<div class="form-group">
						<div class="input-group">
							<div class="input-group-addon">客户名称</div>
							<input id="query-customerName" class="form-control" type="text">
						</div>
					</div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="query-stage" class="form-control">
					  	<option></option>
						  <c:forEach items="${requestScope.stageList}" var="stage">
							  <option value="${stage.id}">${stage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select  id="query-type" class="form-control">
					  	<option></option>
						  <c:forEach items="${requestScope.tranTypeList}" var="tranType">
							  <option value="${tranType.id}">${tranType.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-clueSource">
						  <option></option>
						  <c:forEach items="${requestScope.clueStateList}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryTransactionBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.do?back=2';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editTranBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteTransactionBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheckbox" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tranBody">

					</tbody>

				</table>
				<div id="pagination"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>