<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE HTML>
<%--<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">--%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%--<meta http-equiv="X-UA-Compatible" content="IE=edge" >--%>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/suggest/js/ajaxSuggestions.js"></script>
    <link rel="stylesheet" type="text/css" href="../../../../css/default/om-default.css">
    <script type="text/javascript" src="../../../../js/jquery.min.js"></script>
    <script type="text/javascript" src="../../../../js/operamasks-ui.min.js"></script>
    <script type="text/javascript">
        $(window).scroll(function (){
            $("#grid").omGrid('resize');
        });
        $(document).ready(function() {
            $('#grid').omGrid({
                title : '表格',
                heigt : 400,
                width : 800,
                limit : 10,
                colModel : [{header : '流水号', name : 'flowsn', width : 240, align : 'center',sort:'clientSide'},
                            {header : '借款人', name : 'cust_name', width : 220, align : 'left',sort:'clientSide'},
                            {header : '贷款金额', name : 'rt_orig_loan_amt', align : 'left', width : 120,sort:'clientSide'},
                            {header : '贷款期限', name : 'rt_term_incr', align : 'left', width : 120,sort:'clientSide'}],
                dataSource : '../../../../griddata?method=fast',
                autoFit : true,
                showIndex : true
            });
            $('#create').bind('click', function() {
                var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
                var arg = new Object();
                // 操作类型：add
                arg.doType = "add";
                dialog("gridEdit.jsp?doType=add", arg, sfeature);
            });
            $('#modify').bind('click', function() {
                var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
                var selections=$('#grid').omGrid('getSelections',true);
                if (selections.length == 0) {
                    alert('请至少选择一行记录');
                    return false;
                }
                var rowData = selections[0];
                var flowsn = selections[0].flowsn;
                var arg = new Object();
                // 操作类型：add
                arg.doType = "edit";
                arg.flowsn = flowsn;
                dialog("gridEdit.jsp?doType=edit&flowsn="+flowsn, arg, sfeature);
            });
        });

    </script>
    <title>grid</title>
</head>
<body>
<div id="tbdiv">
    <input id="create" type="button" value="新增"/>
    <input id="modify" type="button" value="修改"/>
    <input id="delete" type="button" value="删除"/>
    地区(模糊查询，为空时显示全部)：<input id="qCity"/>
    <input id="query" type="button" value="查询"/>
</div>
<table id="grid"></table>
</body>
</html>

