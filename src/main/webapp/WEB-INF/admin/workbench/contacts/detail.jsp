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
		/*queryTransaction = function (){
            let id = '${requestScope.contacts.id}';
		$.ajax({
			url:'workbench/contacts/queryTransaction.do',
			data:{
				id,id
			},
			dataType:'json',
			type:'post',
			success:function (responseText){
				html=""
				$.each(responseText,function (){

					html+="<tr id=\"tr_"+this.transaction.id+"\">"
					html+="<td><a href=\"workbench/transaction/detail.jsp?id='"+this.transaction.id+"' style=\"text-decoration: none;\">"+this.transaction.name+"</a></td>"
					html+="<td>"+this.transaction.money+"</td>"
					html+="<td>"+this.transaction.stage+"</td>"
					html+="<td>"+this.possibility+"</td>"
					html+="<td>"+this.transaction.expectedDate+"</td>"
					html+="<td>"+this.transaction.type+"</td>"
					html+="<td><a href=\"javascript:void(0);\" tran-id=\""+this.transaction.id+" \"btn-id=\"deleteTransactionId\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td></tr>"

				})
				$("#transactionBody").html(html);
			}
		})
	}*/
		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});

			$("#cancelRemarkBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});

			$("#remarkScope").on('mouseover','.remarkDiv',function(){
				$(this).children("div").children("div").show();
			});
			$("#remarkScope").on('mouseout','.remarkDiv',function(){
				$(this).children("div").children("div").hide();
			});
			$("#remarkScope").on('mouseover','.myHref',function(){
				$(this).children("span").css("color","red");
			});
			$("#remarkScope").on('mouseout','.myHref',function(){
				$(this).children("span").css("color","#E6E6E6");
			});
			$("#cancelRemarkBtn").click(function (){
				$("#remarkForm").get(0).reset();
			});
			$("#saveRemarkBtn").click(function (){
				let contactsId = '${requestScope.contacts.id}'
				let noteContent = $.trim($("#remark").val());
				$.ajax({
					url:'workbench/contacts/saveRemark.do',
					data:{
						contactsId:contactsId,
						noteContent,noteContent
					},
					type:'post',
					dataType:'json',
					success:function (responseText){
						if(responseText.code=="0"){
							alert("评论失败，请稍后再试");
							return;
						}
						let remark = responseText.remark;
						html="";
						html+="<div id=\"div_"+remark.id+ "\" class=\"remarkDiv\" style=\"height: 60px;\">"
						html+="<img title='"+remark.createBy+"' src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
						html+="<div style=\"position: relative; top: -40px; left: 40px;\" >"
						html+="<h5 id=\"h_"+remark.id+"\">"+remark.noteContent+"</h5>"
						html+="<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>${requestScope.contacts.customerId}</b> <small id=\"s_"+remark.id+"\" style=\"color: gray;\">"+ remark.createTime+" 由${sessionScope.user.name}创建</small>"
						html+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						html+="<a class=\"myHref\" btn-id=\"editRemark\" value=\""+remark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						html+="&nbsp;&nbsp;&nbsp;&nbsp;"
						html+="<a class=\"myHref\" btn-id=\"deleteRemark\" value=\""+remark.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a></div></div></div>"
						$("#remarkHead").after(html);
						$("#remarkForm").get(0).reset();
					}
				});
			});
			$("#remarkScope").on("click",".myHref[btn-id='deleteRemark']",function (){
				let id = $(this).attr("value");
				$.ajax({
					url:"workbench/contacts/deleteRemark.do",
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
			$("#remarkScope").on("click",".myHref[btn-id='editRemark']",function (){
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
					url:'workbench/contacts/editRemark.do',
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
			$("#transactionBody").on('click','a[btn-id=deleteTransactionId]',function (){
				if(window.confirm("确定删除吗?")){
					let id = $(this).attr("tran-id");
					$.ajax({
						url:'workbench/contacts/deleteTransaction.do',
						type:'post',
						dataType:'json',
						data:{
							id:id
						},
						success:function (responseText){
							if(responseText.code=="0"){
								alert("系统繁忙,请稍后再试");
								return;
							}
							$("#tr_"+id).remove();
						}
					})
				}
			});
			$("#activityRelation").click(function (){
				//查询未关联的市场活动
				let id = '${requestScope.contacts.id}';
				$.ajax({
					url:'workbench/contacts/queryActivity.do',
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
						$("#editActivityBody").html(html);
						$("#allCheckbox").prop("checked",false);
						$("")
						$("#bundActivityModal").modal("show");
					}
				});
			});
			$("#allCheckbox").click(function (){
				$("#editActivityBody input[type=checkbox]").prop("checked",$("#allCheckbox").prop("checked"));
			});
			$("#editActivityBody").on('click','input[type=checkbox]',function (){
				if($("#editActivityBody input[type=checkbox]").length==$("#editActivityBody input[type=checkbox]:checked").length){
					$("#allCheckbox").prop("checked",true);
					return;
				}
				$("#allCheckbox").prop("checked",false);
			});
			$("#association").click(function (){
				let checkedActivity = $("#editActivityBody input[type=checkbox]:checked");
				if(checkedActivity.length==0){
					alert("请选择要关联的活动");
					return;
				}
				let id="";
				$.each(checkedActivity,function (){
					id+="id="+this.value+"&"
				});
				id+='contactsId='+'${requestScope.contacts.id}';
				$.ajax({
					url:'workbench/contacts/associate.do',
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
							html+="<td><a a-id="+this.id+" href=\"javascript:void(0);\"  btn-id=\"deleteActivityBtn\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td></tr>"
						});
						$("#activityBody").html(html);
						$("#queryActivityForm").get(0).reset();
						$("#bundActivityModal").modal("hide");
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
							$("#editActivityBody").html('<h3>暂无相关活动，敬请期待<h3>');
							return;
						}
						let html="";
						$.each(responseText.activity,function (){
							html+="<tr id=\"tr_"+this.id+"\"><td><input value=\""+this.id+"\" type=\"checkbox\"/></td>"
							html+="<td>"+this.name+"</td>"
							html+="<td>"+this.startDate+"</td>"
							html+="<td>"+this.endDate+"</td>"
							html+="<td>"+this.owner+"</td></tr>"
						});
						$("#editActivityBody").html(html);
						$("#allCheckbox").prop("checked",false);
					}
				});
			});
			$("#activityBody").on('click','a',function (){
				let id = $(this).attr("a-id");
				$.ajax({
					url:"workbench/contacts/deleteActivity.do",
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
				<h4 class="modal-title" id="myRemarkModalLabel">修改备注</h4>
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
<!-- 解除联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="unbundActivityModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 30%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">解除关联</h4>
			</div>
			<div class="modal-body">
				<p>您确定要解除该关联关系吗？</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
			</div>
		</div>
	</div>
</div>

<!-- 联系人和市场活动关联的模态窗口 -->
<div class="modal fade" id="bundActivityModal" role="dialog">
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
					<form id="queryActivityForm" class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input id="activity-name" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
					<tbody id="editActivityBody">
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" id="association">关联</button>
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
				<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
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
							<input type="text" class="form-control" id="edit-surname" value="李四">
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
							<input type="text" class="form-control" id="edit-job" value="CTO">
						</div>
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" value="12345678901">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email">
						</div>
						<label for="edit-birth" class="col-sm-2 control-label">生日</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-birth">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
							<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-nextContactTime">
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="edit-address1"></textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
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
		<h3>${requestScope.contacts.fullname}${requestScope.contacts.appellation} <small> - ${requestScope.contacts.customerId}</small></h3>
	</div>
	<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
		<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editContactsModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
	</div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
	<div style="position: relative; left: 40px; height: 30px;">
		<div style="width: 300px; color: gray;">所有者</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.owner}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.contacts.source}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 10px;">
		<div style="width: 300px; color: gray;">客户名称</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.customerId}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.contacts.fullname}${requestScope.contacts.appellation}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 20px;">
		<div style="width: 300px; color: gray;">邮箱</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.email}</b></div>
		<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
		<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.contacts.mphone}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 30px;">
		<div style="width: 300px; color: gray;">职位</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.job}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 40px;">
		<div style="width: 300px; color: gray;">创建者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.contacts.createTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 50px;">
		<div style="width: 300px; color: gray;">修改者</div>
		<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.contacts.editTime}</small></div>
		<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 60px;">
		<div style="width: 300px; color: gray;">描述</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${requestScope.contacts.description}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 70px;">
		<div style="width: 300px; color: gray;">联系纪要</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				&nbsp;${requestScope.contacts.contactSummary}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 80px;">
		<div style="width: 300px; color: gray;">下次联系时间</div>
		<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.nextContactTime}</b></div>
		<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
	<div style="position: relative; left: 40px; height: 30px; top: 90px;">
		<div style="width: 300px; color: gray;">详细地址</div>
		<div style="width: 630px;position: relative; left: 200px; top: -20px;">
			<b>
				${requestScope.contacts.address}
			</b>
		</div>
		<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
	</div>
</div>
<!-- 备注 -->
<div id="remarkScope" style="position: relative; top: 10px; left: 40px;">
	<div id="remarkHead" class="page-header">
		<h4>备注</h4>
	</div>
	<!-- 备注1 -->
	<c:forEach items="${requestScope.remarkList}" var="remark">
		<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
			<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5 id="h_${remark.id}">${remark.noteContent}</h5>
				<font color="gray">客户</font> <font color="gray">-</font> <b>${requestScope.contacts.customerId}</b> <small id="s_${remark.id}" style="color: gray;"> ${remark.editTime} 由${remark.editBy}${remark.editFlag=="1"?"修改":"创建"}</small>
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
				<button id="cancelRemarkBtn" type="button" class="btn btn-default">取消</button>
				<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
			</p>
		</form>
	</div>
</div>

<!-- 交易 -->
<div>
	<div style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>交易</h4>
		</div>
		<div style="position: relative;top: 0px;">
			<table id="activityTable3" class="table table-hover" style="width: 900px;">
				<thead>
				<tr style="color: #B3B3B3;">
					<td>名称</td>
					<td>金额</td>
					<td>阶段</td>
					<td>可能性</td>
					<td>预计成交日期</td>
					<td>类型</td>
					<td></td>
				</tr>
				</thead>
				<tbody id="transactionBody">
				<c:forEach items="${requestScope.transactionList}" var="trade">
					<tr id="tr_${trade.transaction.id}">
						<td><a href="workbench/transaction/detail.do?id=${trade.transaction.id}" style="text-decoration: none;">${trade.transaction.name}</a></td>
						<td>${trade.transaction.money}</td>
						<td>${trade.transaction.stage}</td>
						<td>${trade.possibility}</td>
						<td>${trade.transaction.expectedDate}</td>
						<td>${trade.transaction.type}</td>
						<td><a href="javascript:void(0);" tran-id="${trade.transaction.id}" btn-id="deleteTransactionId" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
					</tr>
				</c:forEach>

				</tbody>
			</table>
		</div>

		<div>
			<a href="workbench/transaction/save.do?back=0" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
		</div>
	</div>
</div>

<!-- 市场活动 -->
<div>
	<div style="position: relative; top: 60px; left: 40px;">
		<div class="page-header">
			<h4>市场活动</h4>
		</div>
		<div style="position: relative;top: 0px;">
			<table id="activityTable" class="table table-hover" style="width: 900px;">
				<thead>
				<tr style="color: #B3B3B3;">
					<td>名称</td>
					<td>开始日期</td>
					<td>结束日期</td>
					<td>所有者</td>
					<td></td>
				</tr>
				</thead>
				<tbody id="activityBody">

				<c:forEach items="${requestScope.activityList}" var="activity">
					<tr id="tr_${activity.id}">
						<td><a href="/workbench/activity/detail.do?id=${activity.id}" style="text-decoration: none;">${activity.name}</a></td>
						<td>${activity.startDate}</td>
						<td>${activity.endDate}</td>
						<td>${activity.owner}</td>
						<td><a href="javascript:void(0);" a-id="${activity.id}" btn-id="deleteActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>

		<div>
			<a href="javascript:void(0);" id="activityRelation" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
		</div>
	</div>
</div>


<div style="height: 200px;"></div>
</body>
</html>