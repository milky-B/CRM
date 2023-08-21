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
<script type="text/javascript">

	showCustomer = function (page,count){
		let name = $.trim($("#search-name").val());
		let owner = $.trim($("#search-owner").val());
		let phone = $.trim($("#search-phone").val());
		let website = $.trim($("#search-Website").val());
		$.ajax({
			url: "workbench/customer/query.do",
			type: "post",
			data: {
				name:name,
				owner:owner,
				phone:phone,
				website:website,
				count:count,
				page:page
			},
			dateType: "json",
			success:function (responseText){
				html=""
				$.each(responseText.customerList,function (){
					html+="<tr><td><input value='"+this.id+"' type=\"checkbox\" /></td>"
					html+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/detail.do?id="+this.id+"';\">"+this.name+"</a></td>"
					html+="<td>"+this.owner+"</td>"
					html+="<td>"+this.phone+"</td>"
					html+="<td>"+this.website+"</td></tr>"
				});
				$("#customerBody").html(html);
				$("#allCheckbox").prop("checked",false);
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
						showCustomer(object.currentPage,object.rowsPerPage);
					}
				});
			}
		})
	}
	$(function(){
		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
		showCustomer(1,10);
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$("#createBtn").click(function (){
			$("#createForm").get(0).reset();
			$("#createCustomerModal").modal("show");
		});
		$("#saveBtn").click(function (){
			let owner = $("#create-customerOwner").val();
			let name = $.trim($("#create-customerName").val());
			let website = $.trim($("#create-website").val());
			let phone = $("#create-phone").val();
			let contactSummary = $.trim($("#create-contactSummary").val());
			let nextContactTime = $("#create-nextContactTime").val();
			let description = $.trim($("#create-describe").val());
			let address = $.trim($("#create-address").val());
			if(name==""){
				alert("名称不能为空");
				return ;
			}
			if(phone!=null&&phone!=""&&!/^0\d{2,3}-?\d{7,8}$/.test(phone)){
				alert("检查公司座机格式");
				return;
			}
			$.ajax({
				url:"workbench/customer/create.do",
				type:'post',
				dataType:'json',
				data:{
					owner:owner,
					name:name,
					phone:phone,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					website:website
				},
				success:function (responseText){
					if(responseText.code=="0"){
						alert("创建失败");
						return;
					}
					//刷新
					showCustomer(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					$("#createCustomerModal").modal("hide");
				}
			});
		});
		$("#queryBtn").click(function (){
			showCustomer(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
		});
		$("#allCheckbox").click(function (){
			$("#customerBody input[type=checkbox]").prop("checked",$("#allCheckbox").prop("checked"));
		});
		$("#customerBody").on('click','input[type=checkbox]',function (){
			if($("#customerBody input[type=checkbox]").length==$("#customerBody input[type=checkbox]:checked").length){
				$("#allCheckbox").prop("checked",true);
				return;
			}
			$("#allCheckbox").prop("checked",false);
		});
		$("#deleteBtn").click(function (){
			if($("#customerBody input[type=checkbox]:checked").length==0){
				alert("请选择要删除的客户");
				return;
			}
			if(window.confirm("确定删除?")){
				let ids="";
				let checkedbox = $("#customerBody input[type=checkbox]:checked");
				$.each(checkedbox,function (){
					ids+="ids="+this.value+"&";
				});
				ids=ids.substring(0,ids.length-1);
				$.ajax({
					url:'workbench/customer/delete.do',
					data:ids,
					type:'post',
					dataType: 'json',
					success:function (responseText){
						if(responseText.code=="0"){
							alert(responseText.message);
							return;
						}
						showCustomer(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
					}
				});
			}
		});
		$("#editBtn").click(function (){
			if($("#customerBody input[type=checkbox]:checked").length==0){
				alert("请选择要修改的客户");
				return;
			}
			let id = $("#customerBody input[type=checkbox]:checked").get(0).value;
			$.ajax({
				url:'workbench/customer/edit.do',
				data:{
					id:id
				},
				dataType:'json',
				type:'post',
				success:function (customer){
					if(customer==null){
						alert("系统忙，请稍后再试");
						return;
					}
					$("#edit-customerOwner").val(customer.owner);
					$("#edit-customerName").val(customer.name);
					$("#edit-website").val(customer.website);
					$("#edit-phone").val(customer.phone);
					$("#edit-describe").val(customer.description);
					$("#edit-contactSummary").val(customer.contactSummary);
					$("#edit-nextContactTime").val(customer.nextContactTime);
					$("#edit-address").val(customer.address);
					$("#updateBtn").val(customer.id);
					$("#editCustomerModal").modal("show");
				}
			})
		});
		$("#updateBtn").click(function (){
			let id = $("#updateBtn").val();
			let owner = $("#edit-customerOwner").val();
			let name = $.trim($("#edit-customerName").val());
			let website = $.trim($("#edit-website").val());
			let phone = $("#edit-phone").val();
			let contactSummary = $.trim($("#edit-contactSummary").val());
			let nextContactTime = $("#edit-nextContactTime").val();
			let description = $.trim($("#edit-describe").val());
			let address = $.trim($("#edit-address").val());
			if(name==""){
				alert("名称不能为空");
				return ;
			}
			if(phone!=null&&phone!=""&&!/^0\d{2,3}-?\d{7,8}$/.test(phone)){
				alert("检查公司座机格式");
				return;
			};
			$.ajax({
				url:'workbench/customer/update.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					phone:phone,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address,
					website:website
				},
				type:'post',
				dataType:'json',
				success:function (response){
					if("0"==response.code){
						alert(response.message);
						return
					}
					showCustomer($("#pagination").bs_pagination('getOption','currentPage'),$("#pagination").bs_pagination('getOption','rowsPerPage'));

					$("#editCustomerModal").modal("hide");
				}
			});
		});
	});
	
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="createForm">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
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
                                    <input type="text" class="form-control mydate" id="create-nextContactTime">
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
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${requestScope.users}" var="user">
										<option  value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
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
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="search-Website">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="allCheckbox" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerBody">

					</tbody>
				</table>
			    <div id="pagination"/>
			</div>

		</div>
		
	</div>
</body>
</html>