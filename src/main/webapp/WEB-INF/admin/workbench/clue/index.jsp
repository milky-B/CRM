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

	showClue = function (currentPage,rowsPerPage){
		let owner = $("#query-clueOwner").val();
		let company =  $.trim($("#query-company").val());
		let fullname = $.trim($("#query-fullname").val());
		let phone = $.trim($("#query-phone").val());
		let mphone = $.trim($("#query-mphone").val());
		let state = $("#query-status").val();
		let source = $("#query-source").val();
		let page = currentPage;
		let count = rowsPerPage;
		if(phone.length>=13&&!/^0\d{2,3}-?\d{7,8}$/.test(phone)){
			alert("检查座机号码格式及长度");
			return;
		}
		if(mphone.length>=15&&!/^(?:(?:\+|00)86)?1[3-9]\d{9}$/.test(mphone)){
			alert("检查号码的格式及长度");
			return;
		}
		$.ajax({
			url:"workbench/clue/queryClueByConditions.do",
			post:'post',
			data:{
				owner:owner,
				company:company,
				fullname:fullname,
				phone:phone,
				mphone:mphone,
				state:state,
				source:source,
				page:page,
				count:count
			},
			dataType: 'json',
			success:function (responseText){
				html="";
				$.each(responseText.clueList,function (index,clue){
					html+="<tr><td><input type=\"checkbox\" value='"+clue.id+"'/></td>";
					html+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detail.do?id="+clue.id+"'\">"+clue.fullname;
					if(clue.appellation!=null){
						html+=clue.appellation;
					}
				    html+="</a></td>"
					html+="<td>"+clue.company+"</td>"
					html+="<td>"+clue.phone+"</td>"
					html+="<td>"+clue.mphone+"</td>"
					html+="<td>"+clue.source+"</td>"
					html+="<td>"+clue.owner+"</td>"
					html+="<td>"+clue.state+"</td>"
					html+="</tr>"
				});
				$("#clue-tbody").html(html);
				$("#allCheckbox").prop('checked',false);
				let totalpages;
				if(responseText.amount%count==0){
					totalpages=responseText.amount/count;
				}else{
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
						showClue(object.currentPage,object.rowsPerPage);
					}
				});
			}
		});
	};

	$(function(){
		showClue(1,10);
		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
		$("#createBtn").click(function (){
			$("#createClueForm").get(0).reset();
			$("#createClueModal").modal("show");
		});
		$("#saveClue").click(function (){
			let owner = $("#create-clueOwner").val();
			let company =  $.trim($("#create-company").val());
			let appellation = $("#create-call").val();
			let fullname = $.trim($("#create-surname").val());
			let job = $.trim($("#create-job").val());
			let email = $.trim($("#create-email").val());
			let phone = $.trim($("#create-phone").val());
			let website = $.trim($("#create-website").val());
			let mphone = $.trim($("#create-mphone").val());
			let state = $("#create-status").val();
			let source = $("#create-source").val();
			let description = $.trim($("#create-describe").val());
			let contactSummary = $.trim($("#create-contactSummary").val());
			let nextContactTime = $("#nextContactTime").val();
			let address = $.trim($("#create-address").val());
			if(company==null||company==""){
				alert("公司名不能为空");
				return;
			}
			if(fullname==null||fullname==""){
				alert("名字不能为空");
				return;
			}
			if(email!=null&&email!="" && !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)){
				alert("邮箱格式不对");
				return;
			}
			if(phone!=null&&phone!=""&&!/^0\d{2,3}-?\d{7,8}$/.test(phone)){
				alert("检查公司座机格式");
				return;
			}
			if(mphone!=null&&mphone!=""&&!/^(?:(?:\+|00)86)?1[3-9]\d{9}$/.test(mphone)){
				alert("检查手机号码格式");
				return;
			}
			$.ajax({
				url:"workbench/clue/create.do",
				type:'post',
				dataType:'json',
				data:{
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					website:website,
					mphone:mphone
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert("创建失败");
						return;
					}
					//刷新
					showClue(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#createClueModal").modal("hide");
				}
			});
		});
		$("#queryBtn").click(function (){
			showClue(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
		});
		$("#allCheckbox").click(function (){
			$("#clue-tbody input[type='checkbox']").prop('checked',$("#allCheckbox").prop('checked'));
		});
		$("#clue-tbody").on('click',"input[type='checkbox']",function (){
			if($("#clue-tbody input[type='checkbox']").length==$("#clue-tbody input[type='checkbox']:checked").length){
				$("#allCheckbox").prop('checked',true);
			}else{
				$("#allCheckbox").prop('checked',false);
			}
		});
		$("#deleteBtn").click(function (){
			if($("#clue-tbody input[type=checkbox]:checked").length==0){
				alert("请选择要删除的活动");
				return;
			}
			if(window.confirm("确定删除吗?")){
				let ids="";
				$.each($("#clue-tbody input[type='checkbox']:checked"),function (){
					ids+='id='+this.value+'&';
				});
				ids=ids.substring(0,ids.length-1);
				$.ajax({
					url:'workbench/clue/delete.do',
					type:'post',
					data:ids,
					dataTpe:'json',
					success:function (responseText){
						if(responseText.code=="0"){
							alert(responseText.message);
							return;
						}
						showClue(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}
				});
			}
		});
		$("#updateBtn").click(function (){
			let checkbox = $("#clue-tbody input[type='checkbox']:checked");
			if(checkbox.length==0){
				alert("请先选择要修改的标签");
				return;
			}
			let id = checkbox.get(0).value;
			$.ajax({
				url:"workbench/clue/queryOne.do",
				type:'post',
				data:{
					id:id
				},
				dataType:'json',
				success:function (clue){
					if(clue==null){
						alert("系统忙，请稍后再试");
						return;
					}
					$("#edit-owner").val(clue.owner);
					$("#edit-company").val(clue.company);
					$("#edit-appellation").val(clue.appellation);
					$("#edit-fullname").val(clue.fullname);
					$("#edit-job").val(clue.job);
					$("#edit-email").val(clue.email);
					$("#edit-phone").val(clue.phone);
					$("#edit-website").val(clue.website);
					$("#edit-mphone").val(clue.mphone);
					$("#edit-status").val(clue.state);
					$("#edit-source").val(clue.source);
					$("#edit-describe").val(clue.description);
					$("#edit-contactSummary").val(clue.contactSummary);
					$("#edit-nextContactTime").val(clue.nextContactTime);
					$("#edit-address").val(clue.address);
					$("#updateClueBtn").val(clue.id);
					$("#editClueModal").modal("show");
				}
			});
		});
		$("#updateClueBtn").click(function (){
			let id = $("#updateClueBtn").val();
			let owner = $("#edit-owner").val();
			let company =  $.trim($("#edit-company").val());
			let appellation = $("#edit-appellation").val();
			let fullname = $.trim($("#edit-fullname").val());
			let job = $.trim($("#edit-job").val());
			let email = $.trim($("#edit-email").val());
			let phone = $.trim($("#edit-phone").val());
			let website = $.trim($("#edit-website").val());
			let mphone = $.trim($("#edit-mphone").val());
			let state = $("#edit-status").val();
			let source = $("#edit-source").val();
			let description = $.trim($("#edit-describe").val());
			let contactSummary = $.trim($("#edit-contactSummary").val());
			let nextContactTime = $("#edit-nextContactTime").val();
			let address = $.trim($("#edit-address").val());
			if(company==null||company==""){
				alert("公司名不能为空");
				return;
			}
			if(fullname==null||fullname==""){
				alert("名字不能为空");
				return;
			}
			if(email!=null&&email!="" && !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)){
				alert("邮箱格式不对");
				return;
			}
			if(phone!=null&&phone!=""&&!/^0\d{2,3}-?\d{7,8}$/.test(phone)){
				alert("检查公司座机格式");
				return;
			}
			if(mphone!=null&&mphone!=""&&!/^(?:(?:\+|00)86)?1[3-9]\d{9}$/.test(mphone)){
				alert("检查手机号码格式");
				return;
			}
			$.ajax({
				url:"workbench/clue/update.do",
				type:'post',
				dataType:'json',
				data:{
					id:id,
					owner:owner,
					company:company,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					phone:phone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					website:website,
					mphone:mphone
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert("修改失败，请稍后再试");
						return;
					}
					showClue(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#editClueModal").modal("hide");
				}
			});
		});
	});
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="createClueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
								  <c:forEach items="${requestScope.appellation}" var="a">
									  <option value="${a.id}">${a.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
								  <c:forEach items="${requestScope.clueState}" var="s">
									  <option value="${s.id}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${requestScope.source}" var="s">
									  <option value="${s.id}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input class="form-control mydate" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveClue">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${requestScope.appellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<c:forEach items="${requestScope.clueState}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
									<c:forEach items="${requestScope.source}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="edit-nextContactTime" >
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-default"  id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="query-source" class="form-control">
					  	  <option></option>
						  <c:forEach items="${requestScope.source}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="query-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="query-status" class="form-control">
					  	<option></option>
						  <c:forEach items="${requestScope.clueState}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="queryBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheckbox" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clue-tbody">

					</tbody>
				</table>
			</div>

		</div>

	</div>
	<div id="pagination"/>
</body>
</html>