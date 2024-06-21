<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String path = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<link rel="shortcut icon" href="image/favicon.ico">
<script>
	$(function (){
		$("#username").keydown(function (event){
			if(event.key == "Enter"){
				$("#password").focus();
			}
		});
		$("#password").keydown(function (event){
			if(event.key == "Enter"){
				$("#loginButton").click();
			}
		});
		var inputElement = document.getElementById("password");
		/*inputElement.addEventListener("input", function() {
			if (this.value.length > 10) {
				this.value = this.value.slice(0, 10); // 限制输入框内容为前 10 个字符
			}
		});*/
		inputElement.oninput = function() {
			if (this.value.length > 10) {
				this.value = this.value.slice(0, 10); // 限制输入框内容为前 10 个字符
			}
		};
		$(window).keydown(function (event){
			if(event.key == "Enter" && $("#username").val()!="" && $("#password").val()!=""){
				$("#loginButton").click();
			}else if(event.key == "Enter" && $("#username").val()==""){
				$("#username").focus();
			}else if(event.key == "Enter" && $("#password").val()==""){
				$("#password").focus();
			}
		});
		$("#loginButton").click(function (){
			var username = $.trim($("#username").val());
			var password = $.trim($("#password").val());
			var checked = $("#check").prop("checked");
			if(username==""){
				alert("用户名不能为空");
				return;
			}
			if(password==""){
				alert("密码不能为空");
				return;
			}
			$.ajax({
				url:"settings/qx/user/login.do",
				data:{
					username:username,
					password:password,
					check:checked
				},
				type:"post",
				dataType:"json",
				success:function (responseText){
					if("0"==responseText.code){
						$("#msg").html(responseText.message);
					}else{
						window.location.href="workbench/index.do";
					}
				},
				beforeSend:function (){
					$("#msg").html("稍等，正在验证中...");
					return true;
				}
			})
		});
	});
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/login.jpg" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;milky</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="username" value="${cookie.username.value}" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="password" value="${cookie.holder.value}" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.username}">
								<input id="check" checked type="checkbox">
							</c:if>
							<c:if test="${empty cookie.username}">
								<input id="check" type="checkbox">
							</c:if>
							  十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
					<button type="button" id="loginButton" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>