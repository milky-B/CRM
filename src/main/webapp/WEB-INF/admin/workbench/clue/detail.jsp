<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	$(function(){
		$("#showAndSaveRemark").on("focus","#remark",function (){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		$("#showAndSaveRemark").on("click","#cancelBtn",function (){
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		$("#showAndSaveRemark").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});

		$("#showAndSaveRemark").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});

		$("#showAndSaveRemark").on("mouseover",".myHref",function(){
			$(this).children("span").css("color","red");
		});

		$("#showAndSaveRemark").on("mouseout",".myHref",function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#saveBtn").click(function (){
			let remark =$.trim($("#remark").val());
			if(remark==null||remark==""){
				alert("备注不能为空");
				return;
			}
			let id = '${requestScope.clue.id}';
			$.ajax({
				url:"workbench/clue/saveRemark.do",
				data:{
					clueId:id,
					noteContent:remark
				},
				type:'post',
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert("评论失败");
						return;
					}
					let html = "";
					let clueRemark = responseText.clueRemark;
					html+="<div id=\"div_"+clueRemark.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">"
				    html+="<img title=\""+clueRemark.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
				    html+="<div style=\"position: relative; top: -40px; left: 40px;\" >"
					html+="<h5 id=\"h_"+clueRemark.id+"\">"+clueRemark.noteContent+"</h5>"
					html+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small id=\"s_"+clueRemark.id+"\" style=\"color: gray;\">"+clueRemark.createTime+" 由${sessionScope.user.name}创建</small>"
					html+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
					html+="<a class=\"myHref\" btn-id=\"editRemark\" value=\""+clueRemark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
					html+="&nbsp;&nbsp;&nbsp;&nbsp;"
					html+="<a class=\"myHref\" btn-id=\"deleteRemark\" value=\""+clueRemark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a></div></div></div>"
					$("#remarkHead").after(html);
					$("#remarkForm").get(0).reset();
				}
			});
		});
		$("#cancelBtn").click(function (){
			$("#remarkForm").get(0).reset();
		});
		$("#showAndSaveRemark").on("click",".myHref[btn-id='deleteRemark']",function (){
			let id = $(this).attr("value");
			$.ajax({
				url:"workbench/clue/deleteRemark.do",
				type:'post',
				data:{
					id:id
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert("删除失败");
						return;
					}
					$("#div_"+id).remove();
				}
			});
		});
		$("#showAndSaveRemark").on("click",".myHref[btn-id='editRemark']",function (){
			$("#editForm").get(0).reset();
			$("#editRemarkModal").modal("show");
			let id = $(this).attr("value");
			$("#remarkId").val(id);
		});
		$("#updateRemarkBtn").click(function (){
			let id = $("#remarkId").val();
			let noteContent = $.trim($("#noteContent").val());
			if(noteContent==""){
				alert("不能为空");
				return;
			}
			$.ajax({
				url:'workbench/clue/editRemark.do',
				type:'post',
				dataType:'json',
				data:{
					id:id,
					noteContent:noteContent
				},
				success:function (responseText){
					if(responseText.code=="0"||responseText.code==null){
						alert("修改失败");
						return;
					}
					$("#h_"+id).text(noteContent);
					$("#s_"+id).text(responseText.message+" 由${sessionScope.user.name}修改");
					$("#editRemarkModal").modal("hide");
				}
			});
		});
		$("#activityList").on('click','a',function (){
			let id = $(this).attr("a-id");
			$.ajax({
				url:"workbench/clue/deleteActivity.do",
				type:'post',
				data:{
					id:id
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert("删除失败");
						return;
					}
					$("#tr_"+id).remove();
				}
			});
		});
		$("#bindBtn").click(function (){
			//查询未关联的市场活动
			let id = '${requestScope.clue.id}';
			$.ajax({
				url:'workbench/clue/queryActivity.do',
				type:'post',
				data:{
					id:id
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.amount==0){
						alert("暂无活动,敬请期待");
						return;
					}
					let html="";
					$.each(responseText.activity,function (){
						html+="<tr><td><input value=\""+this.id+"\" type=\"checkbox\"/></td>"
						html+="<td>"+this.name+"</td>"
						html+="<td>"+this.startDate+"</td>"
						html+="<td>"+this.endDate+"</td>"
						html+="<td>"+this.owner+"</td></tr>"
					});
					$("#activityBody").html(html);
				}
			});
			$("#allCheckbox").prop("checked",false);
			$("")
			$("#boundModal").modal("show");
		});
		$("#allCheckbox").click(function (){
			$("#activityBody input[type=checkbox]").prop("checked",$("#allCheckbox").prop("checked"));
		});
		$("#activityBody").on('click','input[type=checkbox]',function (){
			if($("#activityBody input[type=checkbox]").length==$("#activityBody input[type=checkbox]:checked").length){
				$("#allCheckbox").prop("checked",true);
				return;
			}
			$("#allCheckbox").prop("checked",false);
		});
		$("#association").click(function (){
			let checkedActivity = $("#activityBody input[type=checkbox]:checked");
			if(checkedActivity.length==0){
				alert("请选择要关联的活动");
				return;
			}
			let id="";
			$.each(checkedActivity,function (){
				id+="id="+this.value+"&"
			});
			id+='clueId='+'${requestScope.clue.id}';
			$.ajax({
				url:'workbench/clue/associate.do',
				type:'post',
				data:id,
				dataType:'json',
				success:function (responseText){
					if(responseText.amount==0){
						alert("添加失败，请稍后再试");
						return;
					}
					let html="";
					$.each(responseText.activity,function (){
						html+="<tr id=\"tr_"+this.id+"\">"
						html+="<td>"+this.name+"</td>"
						html+="<td>"+this.startDate+"</td>"
						html+="<td>"+this.endDate+"</td>"
						html+="<td>"+this.owner+"</td>"
						html+="<td><a a-id="+this.id+" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td></tr>"
					});
					$("#activityList").html(html);
					$("#activity-name").val("");
					$("#boundModal").modal("hide");
				}
			});
		});
		$("#activity-name").keyup(function (){
			let name = $.trim($("#activity-name").val());
			let id = '${requestScope.clue.id}';
			$.ajax({
				url:'workbench/clue/queryActivity.do',
				type:'post',
				data:{
					id:id,
					name:name
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.amount==0){
						$("#activityBody").html('<h3>暂无相关活动，敬请期待<h3>');
						return;
					}
					let html="";
					$.each(responseText.activity,function (){
						html+="<tr><td><input value=\""+this.id+"\" type=\"checkbox\"/></td>"
						html+="<td>"+this.name+"</td>"
						html+="<td>"+this.startDate+"</td>"
						html+="<td>"+this.endDate+"</td>"
						html+="<td>"+this.owner+"</td></tr>"
					});
					$("#activityBody").html(html);
				}
			});
			$("#allCheckbox").prop("checked",false);
		});
		$("#transfer").click(function (){
			window.location.href='workbench/clue/convert.do?id=${requestScope.clue.id}';
		});
	});
</script>

</head>
<body>

	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form id="editForm" class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="boundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activity-name" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							  <span class="glyphicon glyphicon-search form-control-feedback" ></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="allCheckbox" type="checkbox"/></td>
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
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="association">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.clue.fullname}<small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="transfer"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="showAndSaveRemark" style="position: relative; top: 40px; left: 40px;">
		<div id="remarkHead" class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<c:forEach items="${requestScope.remarkList}" var="remark">
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5 id="h_${remark.id}">${remark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}${requestScope.clue.appellation}-${requestScope.clue.company}</b> <small id="s_${remark.id}" style="color: gray;"> ${remark.editTime} 由${remark.editBy}${remark.editFlag!="0"?"修改":"创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" btn-id="editRemark" value="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" btn-id="deleteRemark" value="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form id="remarkForm" role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn"  type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityList">
						<c:forEach items="${requestScope.activityList}" var="activity">
							<tr id="tr_${activity.id}">
								<td>${activity.name}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a a-id="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a id="bindBtn" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>