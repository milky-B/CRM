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

    <script>
        showUsers = function (page, count) {
            let name = $.trim($("#name").val());
            let role = $.trim($("#role").val());
            let lockState = $.trim($("#lockState").val());
            let startTime = $.trim($("#startTime").val());
            let endTime= $.trim($("#endTime").val());
            let urlParams = "?name="+name+"&role="+role+"&lockState="+lockState+"&startTime="+startTime+"&endTime="+endTime+"&page="+page+"&count="+count;

            $.ajax({
                url: "settings/qx/user/list"+urlParams,
                type: "get",
                success: function (responseText) {
                    console.log(responseText);
                    let html = "";
                    $.each(responseText.data, function (index, object) {
                        html += "<tr><td><input type=\"checkbox\" value=\""+object.id+"\"/></td>";
                        html += "<td>" + index + "</td>";
                        html += "<td><a  href=\"/settings/qx/user/detail.do?id=" + object.id + "\">" + object.loginAct + "</a></td>";
                        html += "<td>" + object.name + "</td>";
                        html += "<td>" + object.deptno + "</td>";
                        html += "<td>" + object.email + "</td>";
                        html += "<td>" + object.expireTime + "</td>";
                        html += "<td>" + object.allowIps + "</td>";
                        html += "<td><a id=\"tr_user_"+object.id+"\" href=\"javascript:void(0);\" onclick=\"updateUserState('"+object.id+"')\" style=\"text-decoration: none;\" data-lock-state=\""+object.lockState+"\">" + (object.lockState == '0' ? "锁定" : "启用") + "</a></td>";
                        html += "<td>" + object.createBy + "</td>";
                        html += "<td>" + object.createtime + "</td>";
                        html += "<td>" + object.editBy + "</td>";
                        html += "<td>" + object.editTime + "</td></tr>";
                    });
                    console.log(html);
                    $("#userForm").html(html);
                    $("#allCheck").prop("checked", false);
                    let total = 1;
                    if (responseText.total % count == 0) {
                        total = responseText.total / count;
                    } else {
                        total = parseInt(responseText.total / count) + 1;
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

                        onChangePage: function (event, object) { // returns page_num and rows_per_page after a link has clicked
                            showUsers(object.currentPage, object.rowsPerPage);
                        }
                    });
                }
            });
        }
        updateUserState = function (userId) {
            // 根据 userId 获取用户标签
            let userElement = document.getElementById("tr_user_" + userId);

            // 从标签中获取用户状态信息
            let lockState = userElement.getAttribute("data-lock-state");

            // 判断用户状态，并更新状态
            let newLockState = lockState === '1' ? '0' : '1'; // 切换用户状态

            // 发送请求给后端更新用户状态
            $.ajax({
                url: "/settings/qx/user/update",
                type: "post",
                data: {
                    id: userId,
                    lockState: newLockState
                },
                success: function (response) {
                    // 更新成功后，修改标签上的用户状态信息
                    userElement.setAttribute("data-lock-state", newLockState);

                    // 修改标签上的显示文本
                    let newText = newLockState === '0' ? "锁定" : "启用";
                    userElement.textContent = newText;

                    // 在这里可以添加其他更新用户状态的逻辑，比如修改标签样式等

                    console.log("User state updated successfully.");
                },
                error: function (xhr, status, error) {
                    console.error("Failed to update user state: " + error);
                    // 在失败情况下可能需要进行错误处理，比如显示错误提示信息
                }
            });
        }

        $(function (){
            showUsers(1,10);
            $(".mydate").datetimepicker({
                language:'zh-CN',
                format:'yyyy-mm-dd',
                minView:'month',
                initialDate:new Date(),
                autoclose:true,
                todayBtn:true
            });
            $("#queryUser").click(function(){
                showUsers(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
            });
            $("#deleteButton").click(function (){
                if($("#userForm input[type=checkbox]:checked").length==0){
                    alert("请选择要删除的用户");
                    return;
                }
                if(window.confirm("确定删除吗")){
                    let id="";
                    $("#userForm input[type=checkbox]:checked").each(function (){
                        id+="id="+this.value+"&";
                    });
                    id=id.substring(0,id.length-1);
                    $.ajax({
                        url:"/settings/qx/user/delete",
                        data :id,
                        type:'post',
                        success:function (responseText){
                            if("1"==responseText.code){
                                alert(responseText.message);
                                return;
                            }
                            showUsers(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
                        }
                    })
                }
            });
            $("#addButton").click(function (){
                $("#createUserForm").get(0).reset();
                $("#createUserModal").modal("show");
                return false;
            });
            $("#saveButton").click(function(){
                let loginAct = $.trim($("#create-loginActNo").val());
                let name = $.trim($("#create-username").val());
                let loginPwd = $.trim($("#create-loginPwd").val());
                let confirmPwd =$.trim($("#create-confirmPwd").val());
                let email = $.trim($("#create-email").val());
                let expireTime = $.trim($("#create-expireTime").val());
                let lockState = $.trim($("#create-lockStatus").val());
                let deptId = $.trim($("#create-org").val());
                if(loginAct=="" || loginAct==null){
                    alert("账号不能为空");
                    return false;
                }
                if(loginPwd=="" || loginPwd==null){
                    alert("登录密码不能为空");
                    return false;
                }
                if(confirmPwd=="" || confirmPwd==null){
                    alert("请确认密码");
                    return;
                }
                if(loginPwd!=confirmPwd){
                    alert("密码不一致");
                    return false;
                }
                if(deptId==null || deptId==""){
                    alert("请选择相应部门");
                    return false;
                }
                $.ajax({
                    url:"/settings/qx/user/register",
                    type:'post',
                    contentType: 'application/json',
                    dataType:'json',
                    data:JSON.stringify({
                        loginAct:loginAct ,
                        name:name ,
                        loginPwd:loginPwd ,
                        confirmPwd:confirmPwd ,
                        email:email ,
                        expireTime:expireTime ,
                        lockState:lockState ,
                        deptId:deptId
                    }),
                    success:function (responseText){
                        if(responseText.code=="1"){
                            alert("创建失败");
                            return false;
                        }
                        //刷新
                        showUsers(1,$("#pagination").bs_pagination('getOption','rowsPerPage'));
                        $("#createUserModal").modal("hide");
                    }
                })
            });
        })
    </script>

</head>
<body>

<!-- 创建用户的模态窗口 -->
<div class="modal fade" id="createUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">新增用户</h4>
            </div>
            <div class="modal-body">

                <form id="createUserForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-loginActNo">
                        </div>
                        <label for="create-username" class="col-sm-2 control-label">用户姓名</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-username">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-loginPwd">
                        </div>
                        <label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-confirmPwd">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-expireTime">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-lockStatus">
                                <option></option>
                                <option value="1">启用</option>
                                <option value="0">锁定</option>
                            </select>
                        </div>
                        <label for="create-org" class="col-sm-2 control-label">部门<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-org">
                                <option></option>
                                <c:forEach items="${requestScope.roles}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-allowIps" style="width: 280%"
                                   placeholder="多个用逗号隔开">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveButton" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>用户列表</h3>
        </div>
    </div>
</div>

<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
    <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">用户姓名</div>
                <input id="name" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">部门名称</div>
                <input id="role" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">锁定状态</div>
                <select id="lockState" class="form-control">
                    <option></option>
                    <option value="0">锁定</option>
                    <option value="1">启用</option>
                </select>
            </div>
        </div>
        <br><br>

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon ">失效时间</div>
                <input class="form-control mydate" type="text" id="startTime"/>
            </div>
        </div>

        ~

        <div class="form-group">
            <div class="input-group">
                <input class="form-control mydate" type="text" id="endTime"/>
            </div>
        </div>

        <button id="queryUser" type="button" class="btn btn-default">查询</button>

    </form>
</div>


<div class="btn-toolbar" role="toolbar"
     style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="addButton" type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="deleteButton" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
    </div>
    <div class="btn-group" style="position: relative; top: 18%; left: 5px;">
        <button type="button" class="btn btn-default">设置显示字段</button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul id="definedColumns" class="dropdown-menu" role="menu">
            <li><a href="javascript:void(0);"><input type="checkbox"/> 登录帐号</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 用户姓名</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 部门名称</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 邮箱</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 失效时间</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 允许访问IP</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 锁定状态</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
        </ul>
    </div>
</div>

<div style="position: relative; left: 30px; top: 40px; width: 110%">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox"/></td>
            <td>序号</td>
            <td>登录帐号</td>
            <td>用户姓名</td>
            <td>部门名称</td>
            <td>邮箱</td>
            <td>失效时间</td>
            <td>允许访问IP</td>
            <td>锁定状态</td>
            <td>创建者</td>
            <td>创建时间</td>
            <td>修改者</td>
            <td>修改时间</td>
        </tr>
        </thead>
        <tbody id="userForm">

        </tbody>
    </table>
    <div id="pagination"></div>
</div>
</body>
</html>