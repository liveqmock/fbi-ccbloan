<!--
/*********************************************************************
* 功能描述: 贷款管理
* 作 者: leonwoo
* 开发日期: 2010/01/16
* 修 改 人:
* 修改日期:
* 版 权: 公司
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="loanList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/suggest/js/ajaxSuggestions.js"></script>
    <style type="text/css" media="screen">
        @import url("/UI/support/suggest/css/ajax-suggestions.css");
    </style>
    <script type="text/javascript">
        // 把pulldown值复制到input中
        function setPullToInput(elm) {
            document.getElementById("cust_name").value = elm.innerText;
            document.getElementById("cust_name").focus();
        }
    </script>
</head>
<%
    String menuAction = "";
    if (request.getParameter(CcbLoanConst.MENU_ACTION) != null) {
        menuAction = request.getParameter(CcbLoanConst.MENU_ACTION);
    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanTab");
    dbGrid.setGridType("edit");
    String commSql = "select a.nbxh,"
            + " (select deptname from ptdept where deptid=a.bankid)as deptname, "
            + " (select prommgr_name from ln_prommgrinfo where prommgr_id=a.custmgr_id) as prommgr_name,"
            + " a.loanid,a.cust_name,a.RT_ORIG_LOAN_AMT,a.CUST_OPEN_DT,a.APLY_DT,a.RT_TERM_INCR,"
            //+ " (select PROMCUST_NO from ln_promotioncustomers where LOANID=a.LOANID) as PROMCUST_NO"
            + " '' as PROMCUST_NO"
            + " from ln_loanapply a  where 1=1 ";
    if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
        commSql += " and not exists (select 1 from ln_mortinfo b where b.loanid=a.loanid)  ";
    }
    //commSql += " and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) ";
    commSql += "  and exists (select  1 from (select deptid from ptdept start with deptid = '" + omgr.getOperator().getDeptid() + "' connect by prior deptid = parentdeptid)  where a.bankid = deptid) ";

    //只能编辑那些未做过抵押登记的,查询查所有的
    /*
        if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
            commSql += " and a.operdate=to_char(sysdate,'yyyy-MM-dd') ";
        }
    */
    dbGrid.setfieldSQL(commSql);

    dbGrid.setField("内部序号", "text", "10", "nbxh", "false", "-1");
    dbGrid.setField("机构", "center", "5", "deptname", "true", "0");
    dbGrid.setField("营销经理", "center", "5", "prommgr_name", "true", "0");
    dbGrid.setField("贷款申请序号", "text", "8", "loanid", "true", "0");
    dbGrid.setField("借款人姓名", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("贷款金额", "money", "6", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("开户日期", "center", "5", "CUST_OPEN_DT", "true", "0");
    dbGrid.setField("申请日期", "center", "5", "APLY_DT", "true", "0");
    dbGrid.setField("贷款期限", "center", "5", "RT_TERM_INCR", "true", "0");
    dbGrid.setField("营销信息客户序号", "text", "20", "PROMCUST_NO", "false", "-1");

    dbGrid.setWhereStr(" order by a.CUST_OPEN_DT desc,APLY_DT desc,a.cust_py asc ");
    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    if (menuAction.equals(CcbLoanConst.MENU_SELECT)) {
        dbGrid.setbuttons("查看贷款=query,moveFirst,prevPage,nextPage,moveLast");
    } else {
        dbGrid.setbuttons("查看贷款=query,添加贷款=appendRecod,编辑贷款=editRecord,删除贷款=deleteRecord,moveFirst,prevPage,nextPage,moveLast");
    }
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> 查询条件</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- 隐藏字段，删除之用 -->
            <input type="hidden" id="nbxh" name="nbxh"/>
            <!-- 流水日志使用 -->
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <!-- 营销信息客户序号 -->
            <input type="hidden" id="PROMCUST_NO" name="PROMCUST_NO" value=""/>
            <tr height="20">
                <td width="8%" nowrap="nowrap" class="lbl_right_padding">业务流水号</td>
                <td width="25%" class="data_input"><input type="text" id="FLOWSN" name="FLOWSN" value="" style="width:96% ">
                </td>

                <td width="15%" align="right" nowrap="nowrap" class="lbl_right_padding"> 借款人姓名</td>
                <td width="70%" align="right" nowrap="nowrap" class="data_input"><input type="text" id="cust_name"
                                                                                        size="40"
                                                                                        class="ajax-suggestion url-getLoanPull.jsp">
                </td>
                <td align="center" nowrap="nowrap"><input name="cbRetrieve" type="button" class="buttonGrooveDisable"
                                                          id="button" onClick="cbRetrieve_Click(document.queryForm)"
                                                          value="检索">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="重填">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> 贷款信息</legend>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> 操作</LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
<div id="search-result-suggestions">
    <div id="search-results"></div>
</div>
<script type="text/javascript">
    // Initialize the input highlight script
    //initInputHighlightScript();
</script>
</body>
</html>
