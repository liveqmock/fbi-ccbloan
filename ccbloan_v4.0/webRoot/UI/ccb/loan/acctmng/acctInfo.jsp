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
    <script language="javascript" src="acctInfo.js"></script>
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
    String commSql = "select a.acct_id, ( select deptname from ptdept where deptid=b.bankid )as deptname, " +
            " a.loanid, b.cust_name, " +
            " ( select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = b.ln_typ ) ln_typ, " +
            " b.rt_orig_loan_amt,( select proj_name from ln_coopproj where proj_no=b.proj_no ) proj_name," +
            " ( select enuitemlabel from PTENUDETAIL where enutype = 'APPTTYPE' and enuitemvalue = a.appt_type) appt_type," +
            " a.acct_name,a.acct_no,a.acct_bank,a.acct_amt,a.pay_date,a.operid,a.recversion " +
            " from ln_acctinfo a " +
            " inner join ln_loanapply b on a.loanid = b.loanid  " +
            " where 1 =1 "+
            " and a.deptid in (" +
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
    dbGrid.setField("账户编号", "center", "5", "acct_id", "false", "0");
    dbGrid.setField("经办行", "center", "5", "deptname", "true", "0");
    dbGrid.setField("贷款申请序号", "text", "8", "loanid", "true", "0");
    dbGrid.setField("借款人姓名", "center", "5", "cust_name", "true", "0");
//    dbGrid.setField("抵押人姓名", "center", "5", "apptName", "true", "0");
    dbGrid.setField("贷款种类", "center", "5", "ln_typ", "true", "0");
    dbGrid.setField("贷款金额", "money", "6", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("项目简称", "center", "10", "proj_name", "true", "0");
    dbGrid.setField("抵押类型", "center", "6", "appt_type", "true", "0");
    dbGrid.setField("账户名称", "center", "5", "acct_name", "true", "0");
    dbGrid.setField("收款账号", "center", "10", "acct_no", "true", "0");
    dbGrid.setField("开户银行", "center", "10", "acct_bank", "true", "0");
    dbGrid.setField("抵押费金额", "center", "4", "acct_amt", "true", "0");
    dbGrid.setField("缴交日期", "center", "6", "pay_date", "true", "0");
    dbGrid.setField("经办人", "center", "5", "operid", "true", "0");
    dbGrid.setField("版本号", "text", "4", "recVersion", "false", "0");

    String whereStr = " and a.print_flag = '0' ";
    whereStr = whereStr +  " order by a.loanid ";
    dbGrid.setWhereStr(whereStr);
    dbGrid.setpagesize(15);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    if (menuAction.equals(CcbLoanConst.MENU_SELECT)) {
        dbGrid.setbuttons("查看贷款=query,moveFirst,prevPage,nextPage,moveLast");
    } else {
        dbGrid.setbuttons("缴费报销=batchEdit,通知书打印=filePrint,汇总导出=allExport,moveFirst,prevPage,nextPage,moveLast");
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
            <input type="hidden" id="acctid" name="acctid"/>
            <tr height="20">
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
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 借款人姓名</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" size="50" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 抵押人姓名</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="appt_name" name="appt_name" size="50" style="width:90% ">
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
                <td align="center" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable"
                                                          id="button" onClick="cbRetrieve_Click(document.queryForm)"
                                                          value="检索">
                </td>
            </tr>
            <tr>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 合作项目简称</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 是否已经缴费报销</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <%
                        zs = new ZtSelect("pay_flag", "BOOLTYPE", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("isNull","false");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">报销开始日期</td>
                <td width="15%" nowrap="nowrap" class="data_input"><input type="text" id="PAY_DATE1"
                                                                          name="PAY_DATE1" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">报销截止日期</td>
                <td width="15%" nowrap="nowrap" class="data_input"><input type="text" id="PAY_DATE2"
                                                                          name="PAY_DATE2" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
                <td align="center" nowrap="nowrap">
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
