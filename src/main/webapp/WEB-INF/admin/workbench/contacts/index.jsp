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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--  PAGINATION plugin jquery/bs_pagination-master/css/-->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">
	showContacts= function (currentPage,rowsPerPage){
		let owner = $("#query-owner").val();
		let fullname = $.trim($("#query-fullname").val());
		let customerName = $.trim($("#query-customerName").val());
		let source = $("#query-source").val();
		let job = $("#query-job").val();
		let page = currentPage;
		let count = rowsPerPage;

		$.ajax({
			url:"workbench/contacts/queryContactsByConditions.do",
			type:'post',
			data:{
				owner:owner,
				fullname:fullname,
				customerName:customerName,
				source:source,
				job:job,
				page:page,
				count:count
			},
			dataType: 'json',
			success:function (responseText){
				html="";
				$.each(responseText.contacts,function (index,clue){
					html+="<tr class=\"active\">"
					html+="<td><input type=\"checkbox\" value=\""+this.id+"\" /></td>"
					html+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/contacts/detail.do?id="+this.id+"';\">"+this.fullname+this.appellation+"</a></td>"
					html+="<td>"+this.customerId+"</td>"
					html+="<td>"+this.owner+"</td>"
					html+="<td>"+this.source+"</td>"
					html+="<td>"+this.job+"</td></tr>"
				});

				$("#contactBody").html(html);
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
						showContacts(object.currentPage,object.rowsPerPage);
					}
				});
			}
		});
	};

	$(function(){
		showContacts(1,10);
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
		$(".customerName").typeahead({
			source:function (query,process){
				$.ajax({
					url:'workbench/customer/queryCustomerName.do',
					type:'post',
					dataType:'json',
					data:{
						name:query
					},
					success:function (data){
						process(data);
					}
				})
			}
		});
		$("#queryBtn").click(function (){
			showContacts(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
		});

		$("#allchecked").click(function (){
			$("#contactBody input[type='checkbox']").prop('checked',$("#allchecked").prop('checked'));
		});
		$("#contactBody").on('click',"input[type='checkbox']",function (){
			if($("#contactBody input[type='checkbox']").length==$("#contactBody input[type='checkbox']:checked").length){
				$("#allchecked").prop('checked',true);
			}else{
				$("#allchecked").prop('checked',false);
			}
		});
		$("#deleteContactBtn").click(function (){
			if($("#contactBody input[type=checkbox]:checked").length==0){
				alert("请选择要删除的联系人");
				return;
			}
			if(window.confirm("确定删除吗?")){
				let ids="";
				$.each($("#contactBody input[type='checkbox']:checked"),function (){
					ids+='id='+this.value+'&';
				});
				ids=ids.substring(0,ids.length-1);
				$.ajax({
					url:'workbench/contacts/deleteContactByKeys.do',
					type:'post',
					data:ids,
					dataTpe:'json',
					success:function (responseText){
						if(responseText.code=="0"){
							alert(responseText.message);
							return;
						}
						showContacts(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}
				});
			}
		});
		$("#createContactBtn").click(function (){
			$("#createContactsModal").modal("show");
		});
		$("#savaContactsBtn").click(function (){
			let owner = $("#create-contactsOwner").val();
			let source = $("#create-clueSource").val();
			let customerId = $("#create-customerName").val();
			let fullname = $.trim($("#create-surname").val());
			let appellation = $("#create-call").val();
			let email = $.trim($("#create-email").val());
			let mphone = $.trim($("#create-mphone").val());
			let job = $.trim($("#create-job").val());
			let description = $.trim($("#create-describe").val());
			let contactSummary = $.trim($("#create-contactSummary1").val());
			let nextContactTime = $.trim($("#create-nextContactTime1").val());
			let address = $.trim($("#create-address").val());
			if(customerId==null||customerId==""){
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
			if(mphone!=null&&mphone!=""&&!/^(?:(?:\+|00)86)?1[3-9]\d{9}$/.test(mphone)){
				alert("检查手机号码格式");
				return;
			}
			$.ajax({
				url:"workbench/contacts/create.do",
				type:'post',
				dataType:'json',
				data:{
					owner:owner,
					customerId:customerId,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					mphone:mphone
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert("创建失败");
						return;
					}
					//刷新
					showContacts(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#createContactsModal").modal("hide");
				}
			});
		});
		$("#editContactBtn").click(function (){
			if($("#contactBody input[type=checkbox]:checked").length==0){
				alert("请选择要修改的联系人");
				return;
			}
			let id = $("#contactBody input[type=checkbox]:checked").get(0).value;
			$.ajax({
				url:'workbench/contacts/queryContactForEdit.do',
				type:'post',
				data:{
					id:id
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert("系统繁忙请稍后");
						return;
					}
					let contacts = responseText.contacts;
					$("#editContactBtn").val(contacts.id);
					$("#edit-contactsOwner").val(contacts.owner);
					$("#edit-clueSource").val(contacts.source);
					$("#edit-customerName").val(contacts.customerId);
					$("#edit-surname").val(contacts.fullname);
					$("#edit-call").val(contacts.appellation);
					$("#edit-email").val(contacts.email);
					$("#edit-mphone").val(contacts.mphone);
					$("#edit-job").val(contacts.job);
					$("#edit-describe").val(contacts.description);
					$("#edit-contactSummary").val(contacts.contactSummary);
					$("#edit-nextContactTime").val(contacts.nextContactTime);
					$("#edit-address").val(contacts.address);
					$("#editContactsModal").modal("show");
				}
			})
		});
		$("#updateContactsBtn").click(function (){
			let id = $("#editContactBtn").val( );
			let owner = $("#edit-contactsOwner").val( );
			let source = $("#edit-clueSource").val( );
			let customerId = $.trim($("#edit-customerName").val( ));
			let fullname = $.trim($("#edit-surname").val( ));
			let appellation = $("#edit-call").val( );
			let email = $.trim($("#edit-email").val( ));
			let mphone = $("#edit-mphone").val( );
			let job = $("#edit-job").val( );
			let description = $.trim($("#edit-describe").val( ));
			let contactSummary = $.trim($("#edit-contactSummary").val( ));
			let nextContactTime = $("#edit-nextContactTime").val( );
			let address = $("#edit-address").val( );
			if(customerId==null||customerId==""){
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
			if(mphone!=null&&mphone!=""&&!/^(?:(?:\+|00)86)?1[3-9]\d{9}$/.test(mphone)){
				alert("检查手机号码格式");
				return;
			}
			$.ajax({
				url:"workbench/contacts/update.do",
				type:'post',
				dataType:'json',
				data:{
					id:id,
					owner:owner,
					customerId:customerId,
					appellation:appellation,
					fullname:fullname,
					job:job,
					email:email,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					mphone:mphone
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert("更新失败,请稍后再试");
						return;
					}
					//刷新
					showContacts(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#editContactsModal").modal("hide");
				}
			});
		})
	});

	
</script>
</head>
<body>

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:forEach items="${requestScope.dicValues}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${requestScope.appellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control customerName" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" id="create-nextContactTime1">
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
					<button type="button" class="btn btn-primary" id="savaContactsBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
									<c:forEach items="${requestScope.dicValues}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${requestScope.appellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control customerName" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
									<input type="text" class="form-control mydate" id="edit-nextContactTime">
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
					<button type="button" id="updateContactsBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input id="query-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="query-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="query-source">
						  <option></option>
						  <c:forEach items="${requestScope.dicValues}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">职位</div>
				      <input id="query-job" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="queryBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createContactBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editContactBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allchecked" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>职位</td>
						</tr>
					</thead>
					<tbody id="contactBody">
					</tbody>
				</table>
				<div id="pagination"/>
			</div>

		</div>
	</div>
</body>
</html>