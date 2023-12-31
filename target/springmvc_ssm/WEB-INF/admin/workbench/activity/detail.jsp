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
		$("#showAndSaveRemark").on("click",".myHref[btn-id='deleteRemark']",function (){
			let id = $(this).attr("value");
			$.ajax({
				url:"workbench/activity/deleteRemark.do",
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
				url:'workbench/activity/editRemark.do',
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
		$("#saveBtn").click(function (){
			let remark =$.trim($("#remark").val());
			if(remark==null||remark==""){
				alert("备注不能为空");
				return;
			}
			let id = '${requestScope.activity.id}';
					//$("#activityDetail").attr("activity-id");
			$.ajax({
				url:"workbench/activity/saveRemark.do",
				data:{
					id:id,
					remark:remark
				},
				type:'post',
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert("评论失败");
						return;
					}
					let html = "";
					let object = responseText.activityRemark;
					html+="<div id=\"div_"+object.id+ "\"  class=\"remarkDiv\" style=\"height: 60px;\">";
					html+="	<img title="+object.createBy+" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
					html+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
					html+="<h5 id=\"h_"+object.id+"\">"+remark+"</h5>";
					html+="<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>"+"${requestScope.activity.name}"+"</b> <small id=\"s_"+object.id+"\" style=\"color: gray;\">"+ object.editTime+" 由"+'${sessionScope.user.name}'+"创建</small>";
					html+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
					html+="<a class=\"myHref\"  btn-id=\"editRemark\" value=\""+object.id+"\"href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
					html+="&nbsp;&nbsp;&nbsp;&nbsp;";
					html+='<a class=\"myHref\" btn-id=\"deleteRemark\" value=\"'+object.id+'\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a></div></div></div>';

					//$("#remarkDiv").before(html);
					$("#remarkHead").after(html);
					$("#remarkForm").get(0).reset();
					//$("#remarkForm")[0].reset();
				}
			});
		});
		$("#cancelBtn").click(function (){
			$("#remarkForm").get(0).reset();
		});
	});

</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
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

    

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${requestScope.activity.name} <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;" id="activityDetail" activity-id="${requestScope.activity.id}">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="activityName">${requestScope.activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="showAndSaveRemark" style="position: relative; top: 30px; left: 40px;">
		<div id="remarkHead" class="page-header">
			<h4>备注</h4>
		</div>

		<!-- 备注1 -->
			<c:forEach items="${requestScope.remarkList}" var="remark">
				<div class="remarkDiv" id="div_${remark.id}" style="height: 60px;">
					<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
					<div style="position: relative; top: -40px; left: 40px;" >
						<h5 id="h_${remark.id}">${remark.noteContent}</h5>
						<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small id="s_${remark.id}" style="color: gray;"> ${remark.editTime} 由${remark.editBy}${remark.editFlag!="1"?"创建":"修改"}</small>
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
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>