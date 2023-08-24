<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta charset="UTF-8">

    <!--  It is a good idea to bundle all CSS in one file. The same with JS -->

    <!--  JQUERY -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin jquery/bs_pagination-master/css/-->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.min.js"></script>

    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
</head>
<script type="text/javascript">
    $(function() {

        $("#demo_pag1").bs_pagination({
            currentPage: 1,
            rowsPerPage: 10,
            totalPages: 100,
            totalRows: 1000,

            visiblePageLinks: 5,

            showGoToPage: true,
            showRowsPerPage: true,
            showRowsInfo: true,
            showRowsDefaultInfo: true,
            onChangePage: function () { // returns page_num and rows_per_page after a link has clicked

            }
        });
        $("#create-accountName").typeahead({
            source: function (query, process) {
                $.ajax({
                    url: "workbench/transaction/selectCustomerfortran.do",
                    data: {
                        name: query
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        process(data);
                    }
                });
            }
        });
    });
</script>
<body>
<!--  Just create a div and give it an ID -->

<div id="demo_pag1"></div>
<div style="position: relative;top: 40px; left: 50px;">
    <input type="file" id="activityFile" accept=".application/vnd.sealed.xls">
</div>
</body>
</html>
