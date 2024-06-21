<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>


    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <!--  PAGINATION plugin jquery/bs_pagination-master/css/-->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <style>
        .dragbox {
            display: inline-flex;
            width: 100px;
            height: 100px;
            background: slateblue;
            position: relative;
            margin: 10px;
            flex: 1;
            color: #fff;
            justify-content: center;
            align-items: center;
            vertical-align: top;
            /* transition: .15s; */
        }

        .dragbox:empty::after {
            content: 'drag me';
        }

        .flex-box {
            display: flex;
        }

        [draggable=true][dragging] {
            box-shadow: 5px 5px 15px rgba(0, 0, 0, .2);
        }

        .dropbox {
            position: relative;
            height: 500px;
            border: 10px solid #f1f1f1;
        }

        [allowdrop][over] {
            border-color: wheat;
        }

        .dropbox .dragbox {
            position: absolute;
            margin: 0;
            left: 0;
            top: 0;
        }

        .droplist {
            width: 500px;
            border: 10px solid #f1f1f1;
            padding: 10px;
        }

        .dragitem {
            display: flex;
            align-items: center;
            list-style: none;
            padding: 10px;
            height: 40px;
            color: #fff;
            background: slateblue;
        }

        .dragitem:not(:first-child) {
            margin-top: 10px;
        }

        .fab {
            position: fixed;
            right: 30px;
            top: 30px;
            font-size: 30px;
            background: royalblue;
            border: 0;
            padding: 10px 20px;
            color: #fff;
            cursor: pointer;
            outline: 0;
            box-shadow: 0 0 15px rgba(0, 0, 0, .2);
            transition: .2s;
        }

        .fab:hover {
            background: rgb(51, 95, 228);
        }

        .fab:hover:active {
            transform: translateY(3px);
        }

        .fab:disabled {
            background: mediumseagreen;
        }

        .fab:disabled::before {
            content: '√ '
        }
    </style>
    <script>
        showEnums= function (){
            $.ajax({
                url:"settings/qx/menus",
                type:"get",
                dataType:"json",
                success:function(responseText){
                    let html = "";
                    $.each(responseText,function (index,object){
                        html+="<li class=\"dragitem\" draggable=\"true\" value=\""+object.id+"\">";
                        html+="<span class=\"glyphicon "+object.icon+"\"></span>"+object.name+"</li>"
                    });
                    $("#droplist").html(html);
                }
            })
        }
        $(function () {
            showEnums();
            $("#saveButton").click(function () {
                var droplist = document.getElementById('droplist');
                var dragItems = droplist.getElementsByClassName('dragitem');
                var allValues = 'id=';
                for (var i = 0; i < dragItems.length; i++) {
                    var value = dragItems[i].getAttribute('value');
                    allValues += value;
                    if (i < dragItems.length - 1) {
                        allValues += ',';
                    }
                }
                console.log('All values:', allValues);
                $.ajax({
                    url:"settings/qx/menu/updateSort?"+allValues,
                    type:'get',
                    dataType:'json',
                    success:function(responseText){
                     if(responseText.code=='0'){
                         alert("保存成功");
                         showEnums();
                         return;
                     }
                     alert("保存失败");
                    }
                })
            })
        })
    </script>
</head>

<body>
<!-- 我的资料 -->
<div class="modal fade" id="myInformation" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">我的资料</h4>
            </div>
            <div class="modal-body">
                <div style="position: relative; left: 40px;">
                    姓名：<b>${sessionScope.user.name}</b><br><br>
                    登录帐号：<b>${sessionScope.user.loginAct}</b><br><br>
                    组织机构：<b>${sessionScope.user.deptno}</b><br><br>
                    邮箱：<b>${sessionScope.user.email}</b><br><br>
                    失效时间：<b>${sessionScope.user.expireTime}</b><br><br>
                    允许访问IP：<b>${sessionScope.user.allowIps}</b>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改密码的模态窗口 -->
<div class="modal fade" id="editPwdModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 70%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="oldPwd" class="col-sm-2 control-label">原密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="oldPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPwd" class="col-sm-2 control-label">新密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="newPwd" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="window.location.href='index.do';">更新
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 退出系统的模态窗口 -->
<div class="modal fade" id="exitModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 30%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">离开</h4>
            </div>
            <div class="modal-body">
                <p>您确定要退出系统吗？</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal"
                        onclick="window.location.href='index.do';">确定
                </button>
            </div>
        </div>
    </div>
</div>

<!-- 顶部 -->
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2023 milky</span></div>
    <div style="position: absolute; top: 15px; right: 15px;">
        <ul>
            <li class="dropdown user-dropdown">
                <a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle"
                   data-toggle="dropdown">
                    <span class="glyphicon glyphicon-user"></span> ${sessionScope.user.name} <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                    <li><a href="workbench/index.do"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
                    <li><a href="settings/index.do"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span
                            class="glyphicon glyphicon-file"></span> 我的资料</a></li>
                    <li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span
                            class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
                    <li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span
                            class="glyphicon glyphicon-off"></span> 退出</a></li>
                </ul>
            </li>
        </ul>
    </div>
</div>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>菜单列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button id="saveButton" type="button" class="btn btn-primary" data-toggle="modal"
                data-target="#createRoleModal"><span class="glyphicon glyphicon-plus"></span> 保存
        </button>
    </div>
</div>
<ul class="droplist" allowdrop id="droplist">
    <%--<c:forEach items="${requestScope.menus}" var="menu">
        <li class="dragitem" draggable="true" value="${menu.id}">
            <span class="glyphicon ${menu.icon}"></span> ${menu.name}
        </li>
    </c:forEach>--%>
</ul>
<!-- <script src="../lib/draggable-polyfill.js"></script> -->
<script>
    //sort
    var currentDragItem = null;
    var offsetY = 0;
    $(document).ready(function() {
        // 绑定拖拽事件
        $('#droplist').on('dragstart', '.dragitem', function(ev) {
            ev.originalEvent.dataTransfer.setData('text', '');
            offsetY = ev.originalEvent.offsetY;
            currentDragItem = this;
        });

        $('#droplist').on('dragend', '.dragitem', function(ev) {
            currentDragItem = null;
        });

        $('#droplist').on('dragover', function(ev) {
            ev.preventDefault();
            if (!currentDragItem) {
                return;
            }
            var dragitem = $(ev.target).closest('.dragitem')[0];
            if (dragitem) {
                if (ev.originalEvent.offsetY > offsetY) {
                    $(dragitem).after(currentDragItem);
                } else {
                    $(dragitem).before(currentDragItem);
                }
            }
        });
    });

</script>
</body>

</html>