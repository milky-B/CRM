<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function (){
			$("#editBtn").click(function (){
				if($("#dic_valueTable input[type='checkbox']:checked").length==0){
					alert("请选择你要编辑的元素");
					return;
				}
				let id = $("#dic_valueTable input[type='checkbox']:checked").get(0).value;
				window.location.href='settings/dictionary/value/edit.do?id='+id;
			});
			$("#allcheckbox").click(function (){
				$("#dic_valueTable input[type='checkbox']").prop('checked',$("#allcheckbox").prop('checked'));
			});
			$("#dic_valueTable").on('click','input[type="checkbox"]',function (){
				if($("#dic_valueTable input[type='checkbox']").length==$("#dic_valueTable input[type='checkbox']:checked").length){
					$("#allcheckbox").prop("checked",true);
					return;
				}
				$("#allcheckbox").prop("checked",false);
			});
			$("#deleteBtn").click(function (){
				let checkedbox = $("#dic_valueTable input[type=checkbox]:checked");
				if(checkedbox.length==0){
					alert("请选择你要删除的字典值");
					return;
				}
				if(window.confirm("确定删除吗?")){
					let ids="";
					checkedbox.each(function (){
						ids+="ids="+this.value+"&";
					});
					ids=ids.substring(0,ids.length-1);
					$.ajax({
						url:"settings/dictionary/value/delete.do",
						data :ids,
						dataType: 'json',
						type:'post',
						success:function (responseText){
							if("0"==responseText.code){
								alert("系统忙请稍后再试");
								return;
							}
							let html="";
							$.each(responseText.dicValueList,function (index,object){
								html+="<tr class=\"active\">"
								html+="<td><input value=\""+this.id+" \"type=\"checkbox\"/></td>"
								html+="<td>"+index+"</td>"
								html+="<td>"+this.value+"</td>"
								html+="<td>"+this.text+"</td>"
								html+="<td>"+this.orderNo+"</td>"
								html+="<td>"+this.typeCode+"</td>"
								html+="</tr>"
							});
							$("#dic_valueTable").html(html);
						}
					})
				}
			});
		});
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/create.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input id="allcheckbox" type="checkbox" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="dic_valueTable">
				<c:forEach items="${requestScope.dicValueList}" var="dicValue" varStatus="status">
					<tr class="active">
						<td><input value="${dicValue.id}" type="checkbox"/></td>
						<td>${status.count}</td>
						<td>${dicValue.value}</td>
						<td>${dicValue.text}</td>
						<td>${dicValue.orderNo}</td>
						<td>${dicValue.typeCode}</td>
					</tr>
				</c:forEach>

			</tbody>
		</table>
	</div>
	
</body>
</html>