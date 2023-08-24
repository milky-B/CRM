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




	<script type="text/javascript">
		$(function (){
			$("#edit-transactionStage").change(function (){
				let id = $("#edit-transactionStage").val();
				if(id==null||id==""){
					return;
				}
				$.ajax({
					url:'workbench/transaction/queryPossibility.do',
					type: 'post',
					data:{
						id:id
					},
					dataType: 'json',
					success:function (possible){
						if(possible.code=="0"){
							alert(possible.message)
							return;
						}
						$("#edit-possibility").val(possible.message);
					}
				});
			});
			$("#saveEditBtn").click(function (){
				let id = '${requestScope.transaction.id}'
				let owner = $("#edit-transactionOwner").val();
				let money = $("#edit-amountOfMoney").val();
				let name = $.trim($("#edit-transactionName").val());
				let expectedDate = $("#edit-expectedClosingDate").val();
				let customerId = $("#edit-accountName").val();
				let stage = $("#edit-transactionStage").val();
				let type = $("#edit-transactionType").val()
				let source = $("#edit-clueSource").val();
				let description = $.trim($("#edit-describe").val());
				let contactSummary = $.trim($("#edit-contactSummary").val());
				let nextContactTime = $("#edit-nextContactTime").val();
				let activityId = $("#activityId").val();
				let contactsId = $("#contactsId").val();
				//表单验证
				if(name==null || name==''){
					alert("名字不能为空");
					return;
				}
				if(expectedDate==null || expectedDate==''){
					alert("预计成交日期不能为空");
					return;
				}
				if(customerId==null || customerId==''){
					alert("客户名不能为空");
					return;
				}
				if(stage==null || stage==''){
					alert("阶段不能为空");
					return;
				}

				$.ajax({
					url:'workbench/transaction/editTransaction.do',
					data:{
						id:id,
						owner:owner,
						money:money,
						name:name,
						expectedDate:expectedDate,
						customerId:customerId,
						stage:stage,
						type:type,
						source:source,
						activityId:activityId,
						contactsId:contactsId,
						description:description,
						contactSummary:contactSummary,
						nextContactTime:nextContactTime
					},
					type:'post',
					dataType:'json',
					success:function (responseText){
						if(responseText.code=="0"){
							alert("系统繁忙,请稍后再试");
							return;
						}
						window.location.href='workbench/transaction/index.do';
					}
				})
			});
			/*从上往下加载就算，在select上直接赋值value,选不中,要加载完之后选*/
			$("#edit-transactionOwner").val("${requestScope.transaction.owner}");
			$("#edit-transactionStage").val('${requestScope.transaction.stage}');
			$("#edit-transactionStage").change();
			$("#edit-transactionType").val("${requestScope.transaction.type}");
			$("#edit-clueSource").val("${requestScope.transaction.source}");

			$("#findActivityBtn").click(function (){
				$("#search-like").val("");
				$("#search-like").keyup();
				$("#findMarketActivity").modal("show");
			});
			$("#activityBody").on('click',"input[type='radio']",function (){
				let id = this.value;
				$("#activityId").val(id);
				$("#edit-activitySrc").val($(this).attr("activityName"));
				$("#findMarketActivity").modal("hide");
			});
			$("#search-like").keyup(function (){
				let name=$("#search-like").val();
				$.ajax({
					url:'workbench/transaction/searchActivityByName.do',
					data:{
						name:name,
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

			$("#findContactsBtn").click(function (){
				$("#search-input").val("");
				$("#search-input").keyup();
				$("#findContacts").modal("show");
			});
			$("#contactsBody").on('click',"input[type='radio']",function (){
				let id = this.value;
				$("#contactsId").val(id);
				$("#edit-contactsName").val($(this).attr("contactName"));
				$("#findContacts").modal("hide");
			});
			$("#search-input").keyup(function (){
				let fullname=$("#search-input").val();
				$.ajax({
					url:'workbench/transaction/searchContactByName.do',
					data:{
						fullname:fullname,
					},
					type:'post',
					dataType: 'json',
					success:function (responseText){
						html="";
						$.each(responseText,function (){
							html+="<tr><td><input value='"+this.id+"' contactName=\""+this.fullname+"\" type=\"radio\" name=\"contact\"/></td>"
							html+="<td>"+this.fullname+this.appellation+"</td>"
							html+="<td>"+this.email+"</td>"
							html+="<td>"+this.mphone+"</td>"
						});
						$("#contactsBody").html(html);
					}
				});
			});

	})
	</script>
</head>
<body>
<!-- 查找市场活动 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找市场活动</h4>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>开始日期</td>
						<td>结束日期</td>
						<td>所有者</td>
					</tr>
					</thead>
					<tbody id="activityBody">


					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<!-- 查找联系人 -->
<div class="modal fade" id="findContacts" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">查找联系人</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input id="search-input" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td></td>
						<td>名称</td>
						<td>邮箱</td>
						<td>手机</td>
					</tr>
					</thead>
					<tbody id="contactsBody">


					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
<div style="position:  relative; left: 30px;">
	<h3>修改交易</h3>
	<div style="position: relative; top: -40px; left: 70%;">
		<button id="saveEditBtn" type="button" class="btn btn-primary">保存</button>
		<button type="button" class="btn btn-default">取消</button>
	</div>
	<hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
	<div class="form-group">
		<label for="edit-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select value="${requestScope.transaction.owner}" class="form-control" id="edit-transactionOwner">
				<c:forEach items="${requestScope.users}" var="user">
					<option value="${user.id}">${user.name}</option>
				</c:forEach>
			</select>
		</div>
		<label for="edit-amountOfMoney" class="col-sm-2 control-label">金额</label>
		<div class="col-sm-10" style="width: 300px;">
			<input value="${requestScope.transaction.money}" type="text" class="form-control" id="edit-amountOfMoney">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" value="${requestScope.transaction.name}" class="form-control" id="edit-transactionName">
		</div>
		<label for="edit-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input value="${requestScope.transaction.expectedDate}" type="text" class="form-control" id="edit-expectedClosingDate">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="text" value="${requestScope.transaction.customerId}" class="form-control" id="edit-accountName" placeholder="支持自动补全，输入客户不存在则新建">
		</div>
		<label for="edit-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
		<div class="col-sm-10" style="width: 300px;">
			<select value="${requestScope.transaction.stage}" class="form-control" id="edit-transactionStage">
				<option></option>
				<c:forEach items="${requestScope.stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="edit-transactionType" class="col-sm-2 control-label">类型</label>
		<div class="col-sm-10" style="width: 300px;">
			<select value="${requestScope.transaction.type}" class="form-control" id="edit-transactionType">
				<option></option>
				<c:forEach items="${requestScope.tranTypeList}" var="tranType">
					<option value="${tranType.id}">${tranType.value}</option>
				</c:forEach>
			</select>
		</div>
		<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
		<div class="col-sm-10" style="width: 300px;">
			<input  type="text" class="form-control" id="edit-possibility">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
		<div class="col-sm-10" style="width: 300px;">
			<select value="${requestScope.transaction.source}" class="form-control" id="edit-clueSource">
				<option></option>
				<c:forEach items="${requestScope.clueStateList}" var="clueState">
					<option value="${clueState.id}">${clueState.value}</option>
				</c:forEach>
			</select>
		</div>
		<label for="edit-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="findActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="hidden" id="activityId"  value="${requestScope.transaction.activityId}">
			<input value="${requestScope.transactionActivityName}" type="text" class="form-control" id="edit-activitySrc">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="findContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
		<div class="col-sm-10" style="width: 300px;">
			<input type="hidden" id="contactsId" value="${requestScope.transaction.contactsId}">
			<input  value="${requestScope.transactionContactsName}" type="text" class="form-control" id="edit-contactsName">
		</div>
	</div>

	<div class="form-group">
		<label for="edit-describe" class="col-sm-2 control-label">描述</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea  class="form-control" rows="3" id="edit-describe">${requestScope.transaction.description}</textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
		<div class="col-sm-10" style="width: 70%;">
			<textarea   class="form-control" rows="3" id="edit-contactSummary">${requestScope.transaction.contactSummary}</textarea>
		</div>
	</div>

	<div class="form-group">
		<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
		<div class="col-sm-10" style="width: 300px;">
			<input  value="${requestScope.transaction.nextContactTime}" type="text" class="form-control" id="edit-nextContactTime">
		</div>
	</div>


</form>

</body>
</html>