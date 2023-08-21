<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
		$("#searchActivity").click(function (){
			$.ajax({
				url:"workbench/clue/searchActivity.do",
				type:'get',
				data:{
					id:'${requestScope.clue.id}'
				},
				dataType:'json',
				success:function (responseText){
					html="";
					$.each(responseText,function (){
						html+="<tr><td><input value='"+this.id+"' activityName=\""+this.name+"\" type=\"radio\" name=\"activity\"/></td>"
						html+="<td id='td_"+this.id+"'>"+this.name+"</td>"
						html+="<td>"+this.startDate+"</td>"
						html+="<td>"+this.endDate+"</td>"
						html+="<td>"+this.owner+"</td></tr>"
					});
					$("#activityBody").html(html);
				}
			});
			$("#search-like").val("");
			$("#searchActivityModal").modal("show");
		});
		$("#search-like").keyup(function (){
			let name=$("#search-like").val();
			$.ajax({
				url:'workbench/clue/searchByNameAndId.do',
				data:{
					name:name,
					id:'${requestScope.clue.id}'
				},
				type:'post',
				dataType: 'json',
				success:function (responseText){
					html="";
					$.each(responseText,function (){
						html+="<tr><td><input value='"+this.id+"' activityName=\""+this.name+"\" type=\"radio\" name=\"activity\"/></td>"
						html+="<td id='td_"+this.id+"'>"+this.name+"</td>"
						html+="<td>"+this.startDate+"</td>"
						html+="<td>"+this.endDate+"</td>"
						html+="<td>"+this.owner+"</td></tr>"
					});
					$("#activityBody").html(html);
				}
			});
		});
		$("#activityBody").on('click',"input[type='radio']",function (){
			let id = this.value;
			$("#activityId").val(id);
			$("#activity").val($(this).attr("activityName"));
			$("#searchActivityModal").modal("hide");
		});
		$("#cancelBtn").click(function (){
			window.location.href='workbench/clue/index.do';
		});
		$("#transferBtn").click(function (){
			let clueId = '${requestScope.clue.id}';
			let money = $("#amountOfMoney").val();
			let tradeName = $.trim($("#tradeName").val());
			let expectDate = $("#expectedClosingDate").val();
			let stage = $("#stage").val();
			let activityId = $("#activityId").val();
			let tradeCheck = $("#isCreateTransaction").prop("checked");
			if(tradeName==""||tradeName==null){
				alert("请输入交易名");
				return
			}
			$.ajax({
				url:'workbench/clue/transfer.do',
				type:'post',
				dataType:'json',
				data:{
					clueId:clueId,
					money:money,
					tradeName:tradeName,
					expectDate:expectDate,
					stage:stage,
					activityId:activityId,
					tradeCheck:tradeCheck
				},
				success:function (responText){
					if(responText.code=="0"){
						alert("系统繁忙，请稍后再试");
						return;
					}
					alert(responText.message);
					window.location.href='workbench/clue/index.do';
				}
			});
		});
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="search-like" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityBody">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${requestScope.clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${requestScope.clue.fullname}${requestScope.clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${requestScope.clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control mydate" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${requestScope.dicValues}" var="dicValue">
					<option value="${dicValue.id}">${dicValue.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			<input type="hidden" id="activityId">
			<input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${requestScope.clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="transferBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input id="cancelBtn" class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>