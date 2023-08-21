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
	<script type="text/javascript">
		$(function (){
			$("#saveBtn").click(function (){
				let typeCode = $("#create-dicTypeCode").val();
				let value = $.trim($("#create-dicValue").val());
				let text = $.trim($("#create-text").val());
				let orderNo = $.trim($("#create-orderNo").val());
				if(typeCode==""||typeCode==null){
					alert("类型不能为空");
					return;
				}
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
					url:"settings/dictionary/value/save.do",
					type:'post',
					dataType:'json',
					data:{
						typeCode : typeCode,
						value:value,
						text:text,
						orderNo:orderNo
					},
					success:function (responseText){
						if(responseText.code=="0"){
							alert("创建失败");
							return;
						}
						$("#dicValueForm").get(0).reset();
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
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button id="backBtn" type="button" class="btn btn-default" >返回</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="dicValueForm" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-dicTypeCode" style="width: 200%;">
				  <option></option>
				  <c:forEach items="${requestScope.dicTypes}" var="dicType">
					  <option value="${dicType.code}">${dicType.name}</option>
				  </c:forEach>
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-dicValue" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" style="width: 200%;"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" style="width: 200%;"/>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>