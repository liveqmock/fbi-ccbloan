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
    <script language="javascript" src="acctBranchList.js"></script>
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

    //判断是否个贷代理机构（个贷中心、个贷分中心、四个自办行）
    String ploanProxyDept = "0";
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();
    try {
        RecordSet chrs = dc.executeQuery("select count(*) as cnt from LN_MORTCENTER_APPT where deptid='" + deptId + "'");
        while (chrs != null && chrs.next()) {
            if (chrs.getInt(0) > 0) {
                ploanProxyDept = "1"; //个贷中心、个贷分中心、四个自办行
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("数据库处理错误" + e.getMessage());
        return;
    } finally {
        cm.release();
    }

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("acctTab");
    dbGrid.setGridType("edit");
    String commSql = "select b.nbxh as mortid,( select deptname from ptdept where deptid=b.bankid )as deptname, " +
            " b.cust_name," +
            " ( select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = b.ln_typ ) ln_typ, " +
            " b.rt_orig_loan_amt,( select proj_name from ln_coopproj where proj_no=b.proj_no ) proj_name, "+
            " b.loanid, b.nbxh " +
            " from ln_loanapply b " +
            " left outer join ln_mortinfo a on a.loanid = b.loanid " +
            " where nvl(b.apprstate,' ') in ('06','10')" +
            " and b.bankid in('371997609','371997709','371997909','371998009') "+
            " and b.bankid in (" +
            " select deptid from ptdept " +
            " start with deptid = '" + omgr.getOperator().getDeptid() +"'" +
            " connect by prior deptid = parentdeptid" +
            " )";
//    if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
//        commSql += " and not exists (select 1 from ln_mortinfo b where b.loanid=a.loanid)  ";
//    }
//    //commSql += " and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) ";
//    commSql += "  and exists (select  1 from (select deptid from ptdept start with deptid = '" + omgr.getOperator().getDeptid() + "' connect by prior deptid = parentdeptid)  where a.bankid = deptid) ";

    //只能编辑那些未做过抵押登记的,查询查所有的
    /*
        if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
            commSql += " and a.operdate=to_char(sysdate,'yyyy-MM-dd') ";
        }
    */
    dbGrid.setfieldSQL(commSql);

    dbGrid.setField("抵押编号", "text", "10", "mortid", "false", "-1");
    dbGrid.setField("经办行", "center", "5", "deptname", "true", "0");
    dbGrid.setField("借款人姓名", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("贷款种类", "center", "5", "ln_typ", "true", "0");
    dbGrid.setField("贷款金额", "money", "6", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("项目简称", "center", "10", "proj_name", "true", "0");
    dbGrid.setField("贷款申请序号", "text", "8", "loanid", "true", "0");
    dbGrid.setField("内部序号", "center", "15", "nbxh", "false", "0");
    //String whereStr = " and not exists (select c.loanid from ln_acctinfo c where b.loanid = c.loanid)";
    String whereStr = " order by b.loanid ";
    dbGrid.setWhereStr(whereStr);
    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    if (menuAction.equals(CcbLoanConst.MENU_SELECT)) {
        dbGrid.setbuttons("查看贷款=query,moveFirst,prevPage,nextPage,moveLast");
    } else {
        dbGrid.setbuttons("查看贷款=loanQuery,获取委扣账号=getBatchAcctNo,moveFirst,prevPage,nextPage,moveLast");
    }
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> 查询条件</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- 隐藏字段 -->
            <input type="hidden" id="ploanProxyDept" name="ploanProxyDept"  value="<%=ploanProxyDept%>"/>
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">贷款申请序号</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <input type="text" id="loanID" name="loanID" style="width:90% "></td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">经办机构</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs;
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("bankid", "", "371980000");
                            zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                    + " start with deptid = '" + "371980000" + "'"
                                    + " connect by prior deptid = parentdeptid");
                        }else{
                            zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                            zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                    + " start with deptid = '" + deptId + "'"
                                    + " connect by prior deptid = parentdeptid");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">贷款种类</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("ln_typ", "", "");
                        zs.setSqlString("select code_id,code_desc from ln_odsb_code_desc where code_type_id='053' order by code_id");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">抵押流程状态</td>
                <td width="15%" class="data_input"><%
                    zs = new ZtSelect("MORTSTATUS", "MORTSTATUS", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                </td>
            </tr>
            <tr>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 借款人姓名</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" size="50" style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">交易中心</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                            zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from LN_MORTCENTER_APPT where deptid='" + deptId + "' and typeflag='0' order by mortecentercd");
                        }else{
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "MORTECENTERCD");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 合作项目简称</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
                <td align="center" nowrap="nowrap" colspan="2">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable"
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
