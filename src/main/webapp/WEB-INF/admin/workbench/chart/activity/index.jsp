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

    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $.ajax({
            url:'workbench/activity/funnel.do',
            type:'get',
            dataType:'json',
            success:function (data){
                // 基于准备好的dom，初始化echarts实例
                var myChart = echarts.init(document.getElementById('funnel'));

                // 指定图表的配置项和数据
                option = {
                    title: {
                        text: 'Funnel'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: '{a} <br/>{b} : {c}%'
                    },
                    toolbox: {
                        feature: {
                            dataView: { readOnly: false },
                            restore: {},
                            saveAsImage: {}
                        }
                    },

                    series: [
                        {
                            name: 'Expected',
                            type: 'funnel',
                            left: '10%',
                            width: '80%',
                            label: {
                                formatter: '{b}Expected'
                            },
                            labelLine: {
                                show: false
                            },
                            itemStyle: {
                                opacity: 0.7
                            },
                            emphasis: {
                                label: {
                                    position: 'inside',
                                    formatter: '{b}Expected: {c}%'
                                }
                            },
                            data: data
                        }
                    ]
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }
        })


    </script>

</head>
<body>
<div id="funnel" style="width: 600px;height:400px;"></div>
</body>
</html>
