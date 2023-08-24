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

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$(".mydate").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true
		});
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

			let customerId = '${requestScope.customer.id}'
			let noteContent = $.trim($("#remark").val());
			$.ajax({
				url:'workbench/customer/saveRemark.do',
				data:{
					customerId:customerId,
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
					html+="<font color=\"gray\">客户</font> <font color=\"gray\">-</font> <b>"+remark.customerId+"</b> <small id=\"s_"+remark.id+"\" style=\"color: gray;\">"+ remark.createTime+" 由${sessionScope.user.name}创建</small>"
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
				url:"workbench/customer/deleteRemark.do",
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
				url:'workbench/customer/editRemark.do',
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
		$("#createContactsBtn").click(function (){
			$("#createContactsModalForm").get(0).reset();
			$("#createContactsModal").modal("show");
		});
		$("#create-customerName").typeahead({
			source:function (query,process) {
				$.ajax({
					url:"workbench/customer/selectCustomerForContact.do",
					data:{
						name:query
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						process(data);
					}
				});
			}
		});
		$("#saveContactBtn").click(function (){
			let owner = $("#create-contactsOwner").val()
			let source = $("#create-clueSource").val()
			let customerId = $("#create-customerName").val()
			let fullname = $.trim($("#create-surname").val())
			let appellation = $("#create-call").val()
			let email = $.trim($("#create-email").val())
			let mphone = $("#create-mphone").val()
			let job = $.trim($("#create-job").val())
			let description = $.trim($("#create-describe").val())
			let contactSummary = $.trim($("#edit-contactSummary").val())
			let nextContactTime = $("#edit-nextContactTime").val()
			let address = $.trim($("#edit-address1").val())

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
				url:"workbench/customer/createContact.do",
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
				success:function (contact){
					if(contact.code=="0"){
						alert("添加失败");
						return;
					}
					html="";
					html+="<tr id=\"tr_"+contact.id+"\"><td><a href=\"workbench/contacts/detail.do?id="+contact.id+"\" style=\"text-decoration: none;\">"+contact.fullname+contact.appellation+"</a></td>"
					html+="<td>"+contact.email+"</td>"
					html+="<td>"+contact.mphone+"</td>"
					html+="<td><a href=\"javascript:void(0);\" btn-id=\"deleteContactBtn\" value=\""+contact.id+"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>删除</a></td></tr>"
					$("#contactsBody").append(html);
					$("#createContactsModal").modal("hide");
				}
			});
		});
		$("#contactsBody").on("click","a[btn-id=deleteContactBtn]",function (){
			let id = $(this).attr("value");;
			$("#contactId").val(id);
			$("#removeContactsModal").modal("show");
		});
		$("#toDeleteBtn").click(function (){
			let id = $("#contactId").val();
			$.ajax({
				url:'workbench/customer/deleteContact.do',
				data:{
					id:id
				},
				type:'post',
				dataType:'json',
				success:function (response){
					if(response.code=="0"){
						alert(response.message);
					}
					$("#tr_"+id).remove();
					$("#removeContactsModal").modal("hide");
				}
			})
		});
		$("#transactionBody").on('click','a[btn-id=deleteTransactionId]',function (){
			$("#tranId").val($(this).attr("tran-id"));
			$("#removeTransactionModal").modal("show");
		});
		$("#toDeleteTransactionBtn").click(function (){
			let tranId = $("#tranId").val();
			$.ajax({
				url:'workbench/customer/deleteTransaction.do',
				type:'get',
				data:{
					id:tranId
				},
				dataType:'json',
				success:function (responseText){
					if(responseText.code=="0"){
						alert(responseText.message);
					}
					$("#tr_"+tranId).remove();
					$("#removeTransactionModal").modal("hide");
				}
			})
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

	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<input type="hidden" id="contactId">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="toDeleteBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
    <div class="modal fade" id="removeTransactionModal" role="dialog">
		<input type="hidden" id="tranId">
        <div class="modal-dialog" role="document" style="width: 30%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title">删除交易</h4>
                </div>
                <div class="modal-body">
                    <p>您确定要删除该交易吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button type="button" id="toDeleteTransactionBtn">删除</button>
                </div>
            </div>
        </div>
    </div>
	
	<!-- 创建联系人的模态窗口 -->
<!-- 创建联系人的模态窗口 -->
<div class="modal fade" id="createContactsModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
			</div>
			<div class="modal-body">
				<form id="createContactsModalForm" class="form-horizontal" role="form">

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
								<c:forEach items="${requestScope.source}" var="s">
									<option value="${s.id}">${s.value}</option>
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
							<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
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
				<button id="saveContactBtn" type="button" >保存</button>
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
			<h3>${requestScope.customer.name} <small><a href="${requestScope.customer.website}" target="_blank">${requestScope.customer.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${requestScope.customer.address}
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
						<font color="gray">客户</font> <font color="gray">-</font> <b>${remark.customerId}</b> <small id="s_${remark.id}" style="color: gray;"> ${remark.editTime} 由${remark.editBy}${remark.editFlag=="1"?"修改":"创建"}</small>
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
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
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
							<td><a href="workbench/transaction/detail.html?id=${trade.transaction.id}" style="text-decoration: none;">${trade.transaction.name}</a></td>
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
				<a href="workbench/transaction/save.do?back=1" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>

					<tbody id="contactsBody">

					<c:forEach items="${requestScope.contactList}" var="contact">
						<tr id="tr_${contact.id}">
							<td><a href="workbench/contacts/detail.do?id=${contact.id}" style="text-decoration: none;">${contact.fullname}${contact.appellation}</a></td>
							<td>${contact.email}</td>
							<td>${contact.mphone}</td>
							<td><a href="javascript:void(0);" value="${contact.id}" btn-id="deleteContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="createContactsBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>