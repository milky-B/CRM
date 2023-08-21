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
	showActivities = function (page,count){
		let name=$.trim($("#queryName").val());
		let owner=$.trim($("#queryOwner").val());
		let startDate=$.trim($("#startTime").val());
		let endDate=$.trim($("#endTime").val());
		$.ajax({
			url: "workbench/activity/query.do",
			type: "post",
			data: {
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				count:count,
				page:page
			},
			dateType: "json",
			success:function (responseText){
				let html = "";
				/*let a = responseText.activity;
				for(i=0;i<a.length;i++){
					html+="<tr class=\"active\"> <td><input type=\"checkbox\" value=\""+a[i].id+"\"/></td> <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">";
					html+=a[i].name;
					html+="</a></td>";
					html+="<td>"+a[i].owner+"</td>";
					html+="<td>"+a[i].startDate+"</td>"
					html+="<td>"+a[i].endDate+"</td></tr>"
				}*/
				$.each(responseText.activity,function (index,object){

					html+="<tr class=\"active\"> <td><input type=\"checkbox\" value=\""+object.id+"\"/></td> <td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detail.do?id="+object.id+"';\">";
					html+=object.name;
					html+="</a></td>";
					html+="<td>"+object.owner+"</td>";
					html+="<td>"+object.startDate+"</td>"
					html+="<td>"+object.endDate+"</td></tr>"
				});
				$("#activityForm").html(html);
				$("#allCheck").prop("checked",false);
				/*
				因为活动列表不是固态标签，所以用这种注册回调函数的方式的话，要在生成它的时候再注册，
				这导致activityForm的checkbox的回调函数一直注册，处理这种非固态标签时候，使用on方法比较好
				$("#activityForm input[type=checkbox]").click(function (){
					if($("#activityForm input[type=checkbox]").length==$("#activityForm input[type=checkbox]:checked").length){
						$("#allCheck").prop("checked",true);
						return;
					}
					$("#allCheck").prop("checked",false);
				});
				*/

				let total = 1;
				if(responseText.amount%count==0){
					total = responseText.amount/count;
				}else{
					total =parseInt(responseText.amount/count)+1;
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

					onChangePage: function(event,object) { // returns page_num and rows_per_page after a link has clicked
						showActivities(object.currentPage,object.rowsPerPage);
					}
				});
			}
		});
	};

	$(function (){
		showActivities(1,10);
		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
		$("#saveButton").click(function (){
			let name = $.trim($("#name").val());
			let owner = $.trim($("#create-marketActivityOwner").val());
			let startDate = $.trim($("#startDate").val());
			let endDate = $.trim($("#endDate").val());
			let cost = $.trim($("#cost").val());
			let description = $.trim($("#create-describe").val());
			$.ajax({
				url:"workbench/activity/save.do",
				type:"post",
				dataType:"json",
				data:{
					name:name,
					owner:owner,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert(responseText.message);
						return;
					}
					showActivities(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#createActivityModal").modal("hide");
					//添加活动到列表

				},
				beforeSend:function (){
					if(name==""||owner==""){
						alert("所有者和名称都不能为空");
						return false;
					}
					if(startDate!="" && endDate=="" || startDate=="" && endDate!=""){
						alert("请补全日期");
						return false;
					}
					if(startDate.localeCompare(endDate)>0){
						alert("请检查时间");
						return false;
					}
					if(cost!="" && !/^0$|^[1-9][0-9]*$/.test(cost)){
						alert("检查成本，注意格式只能取非负整数");
						return false;
					}
					return true;
				}
			})
		});
		$("#createButton").click(function (){
			$("#createActivityForm").get(0).reset();
			$("#createActivityModal").modal("show");
		});
		$("#queryButton").click(function (){
			showActivities(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
		});
		$("#allCheck").click(function (){
			$("#activityForm input[type=checkbox]").prop("checked",$("#allCheck").prop("checked"));
		});
		$("#activityForm").on("change","input[type=checkbox]",function (){
			if($("#activityForm input[type=checkbox]").length==$("#activityForm input[type=checkbox]:checked").length){

				$("#allCheck").prop("checked",true);
				return;
			}
			$("#allCheck").prop("checked",false);
		});
		$("#deleteButton").click(function (){
			if($("#activityForm input[type=checkbox]:checked").length==0){
				alert("请选择要删除的活动");
				return;
			}
			if(window.confirm("确定删除吗")){
				let ids="";
				$("#activityForm input[type=checkbox]:checked").each(function (){
					ids+="ids="+this.value+"&";
				});
				ids=ids.substring(0,ids.length-1);
				$.ajax({
					url:"workbench/activity/delete.do",
					data :ids,
					dataType: 'json',
					type:'post',
					success:function (responseText){
						if("0"==responseText.code){
							alert(responseText.message);
							return;
						}
						showActivities(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}
				})
			}
		});
		$("#updateButton").click(function (){
			let updateAct = $("#activityForm input[type=checkbox]:checked");
			if(updateAct.length==0){
				alert("请选择要修改的活动");
				return;
			}
			let id = updateAct.get(0).value;
			$.ajax({
				url:"workbench/activity/queryByKey.do",
				data:{
					id:id
				},
				dataType:'json',
				type:'post',
				success:function (activity){
					if(activity==""||activity==null){
						alert("系统繁忙");
						return;
					}
					$("#edit-marketActivityOwner").val(activity.owner)
					$("#edit-marketActivityName").val(activity.name);
					$("#edit-startTime").val(activity.startDate);
					$("#edit-endTime").val(activity.endDate);
					$("#edit-cost").val(activity.cost);
					$("#edit-describe").val(activity.description);
					$("#editActivityModal").modal("show");
				}
			});

		});
		$("#update-save-button").click(function (){
			let id = $("#activityForm input[type=checkbox]:checked").get(0).value;
			let owner = $("#edit-marketActivityOwner").val();
			let name = $("#edit-marketActivityName").val();
			let startDate = $("#edit-startTime").val();
			let endDate = $("#edit-endTime").val();
			let cost = $("#edit-cost").val();
			let description = $("#edit-describe").val();
			$.ajax({
				url:'workbench/activity/update.do',
				type: 'post',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description
				},
				dataType:'json',
				success:function (response){
					if("0"==response.code){
						alert(response.message);
						return
					}
					showActivities($("#pagination").bs_pagination('getOption','currentPage'),$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#editActivityModal").modal("hide");
				},
				beforeSend:function (){
					if(name==""||owner==""){
						alert("所有者和名称都不能为空");
						return false;
					}
					if(startDate!="" && endDate=="" || startDate=="" && endDate!=""){
						alert("请补全日期");
						return false;
					}
					if(startDate.localeCompare(endDate)>0){
						alert("请检查时间");
						return false;
					}
					if(cost!="" && !/^0$|^[1-9][0-9]*$/.test(cost)){
						alert("检查成本，注意格式只能取非负整数");
						return false;
					}
					return true;
				}
			});
		});
		$(window).keydown(function (event){
			if(event.key == "Enter"){
				if($("#createActivityModal").is(":visible")){
					$("#saveButton").click();
				}else if($("#editActivityModal").is(":visible")){
					$("#update-save-button").click();
				}
			}
		});
		$("#exportActivityAllBtn").click(function (){
			window.location.href="workbench/activity/download.do";
		});
		$("#exportActivityXzBtn").click(function (){
			let activities = $("#activityForm input[type=checkbox]:checked");
			if(activities.length<1){
				alert("请选择要导出的活动");
				return;
			}
			let ids="";
			activities.each(function (index,object){
				ids+="ids="+object.value+"&";
			});
			window.location.href="workbench/activity/download.do?"+ids;
		});
		$("#uploadBtn").click(function (){
			$("#importActivityModal").modal("show");
		});
		$("#importActivityBtn").click(function (){
			if(!/\.xls$/i.test($("#activityFile").val())){
				alert("请选择正确类型的文件");
				return;
			}
			let file = $("#activityFile")[0].files[0];

			let formData = new FormData();
			formData.append("file",file);
			if(file.size>1024*1024*5){
				alert("文件过大");
				return;
			}
			$.ajax({
				url:'workbench/activity/upload.do',
				type:'post',
				data:formData,
				processData:false,//设置ajax是否将数据都转换为字符串
				contentType:false,//是否以urlencoded编码
				dataType:'json',
				success:function (returnMessage){
					if("0"==returnMessage.code){
						alert(returnMessage.message);
						return;
					}
					alert(returnMessage.message);
					showActivities(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#importActivityModal").modal("hide");
				}
			});
		});
	});
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="createActivityForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" id="name" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime"  class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input id="startDate" class="form-control mydate" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input id="endDate" class="form-control mydate" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" id="cost" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveButton" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" id="updateActivityForm" role="form">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-startTime"/>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" id="edit-endTime"/>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="update-save-button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile" accept="application/vnd.ms-excel">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="queryName" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="queryOwner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control mydate" type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control mydate" type="text" id="endTime">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryButton">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button"  class="btn btn-primary" id="createButton"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateButton"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteButton" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button id="uploadBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheck" type="checkbox" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityForm">

					</tbody>
				</table>
				<div id="pagination"></div>
			</div>
		</div>
	</div>
</body>
</html>