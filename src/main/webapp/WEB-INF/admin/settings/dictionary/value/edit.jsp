<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script type="text/javascript">
		$(function (){
			$("#updateBtn").click(function (){
				let id = '${requestScope.dicValue.id}';
				let value = $.trim($("#edit-dicValue").val());
				let text = $.trim($("#edit-text").val());
				let orderNo = $.trim($("#edit-orderNo").val());
				if(value==""||value==null){
					alert("字典值不能为空");
					return;
				}
				if(orderNo!=""&&orderNo!=null){
					if(!/^(0|[1-9][0-9]*)$/.test(orderNo)){
						alert("排序号格式错误");
						return;
					}
				}
				$.ajax({
					url:'settings/dictionary/value/update.do',
					type:'post',
					dataType:'josn',
					data:{
						id:id,
						value:value,
						text:text,
						orderNo:orderNo
					},
					success:function (responseText){
						if(responseText.code=="0"){
							alert("更新失败请稍后再试");
							return;
						}
						alert("更新成功");
					}
				});
			});
			$("#backBtn").click(function (){
				window.location.href='settings/dictionary/value/index.do';
			});
		});
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
			<button type="button" class="btn btn-default" id="backBtn">返回</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-dicTypeCode" style="width: 200%;" value="${requestScope.dicValue.typeCode}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-dicValue" style="width: 200%;" value="${requestScope.dicValue.value}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${requestScope.dicValue.text}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="${requestScope.dicValue.orderNo}">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>