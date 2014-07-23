<!--
/*********************************************************************
* 功能描述: 抵押库柜登记
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

    <script language="javascript" src="mortBoxList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>

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
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    //判断是否个贷代理机构（个贷中心、个贷分中心、四个自办行）
    String ploanProxyDept = "0";
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();
    try {
        RecordSet chrs = dc.executeQuery("select count(*) as cnt from ln_morttype where deptid='" + deptId + "'");
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
    dbGrid.setGridID("loanRegistedTab");
    dbGrid.setGridType("edit");

    String sql = "select a.nbxh," +
            " (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' " +
            " and t.enuitemvalue = b.mortecentercd) MORTECENTERCD," +
            " (select deptname from ptdept where deptid=a.bankid) as deptname," +
            " ( select proj_name from ln_coopproj where proj_no=a.proj_no ) proj_name," +
            " a.cust_name,a.RT_ORIG_LOAN_AMT," +
            " (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'RELEASECONDCD' " +
            " and t.enuitemvalue = b.RELEASECONDCD) RELEASECONDCD," +
            " b.mortid,b.BOXID,b.EXPRESSNOTE,b.recVersion,b.loanid " +
            " from ln_loanapply a,ln_mortinfo b " +
            " where a.loanid = b.loanid " +
            " and b.mortstatus = '" + CcbLoanConst.MORT_FLOW_REGISTED + "' " +
            " and b.Releasecondcd in ('01','02','03') " +
            " and (b.boxid is not null or b.boxid <>'') " +
            " and (b.sendflag <> '0' or sendflag is null)  "+
            " and b.MORTECENTERCD in ( select mortecentercd from ln_morttype where typeflag='0' and deptid='"+deptId+"') ";

    dbGrid.setfieldSQL(sql);

    dbGrid.setField("nbxh", "text", "2", "nbxh", "false", "0");
    dbGrid.setField("交易中心", "center", "6", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("机构", "center", "7", "deptname", "true", "0");
    dbGrid.setField("项目简称", "text", "5", "proj_name", "true", "0");
    dbGrid.setField("姓名", "text", "5", "cust_name", "true", "0");
    dbGrid.setField("金额", "money", "7", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("放款方式", "center", "7", "RELEASECONDCD", "true", "RELEASECONDCD");
    dbGrid.setField("抵押编号", "center", "7", "mortid", "true", "0");
    dbGrid.setField("柜号", "center", "6", "boxid", "true", "0");
    dbGrid.setField("备注", "text", "7", "EXPRESSNOTE", "true", "0");
    // 该字段是批量更新防止并发问题关键字段，不能删除；
    dbGrid.setField("版本号", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("loanid", "text", "4", "loanid", "false", "0");
//    dbGrid.setWhereStr(" order by a.cust_py asc ");
    dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() +
            "' connect by prior deptid=parentdeptid) order by b.mortecentercd, a.bankid,proj_name, b.mortid ");
    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    dbGrid.setbuttons("导出excel=excel,查看贷款=loanQuery,查看抵押=query,库柜更改=batchEdit,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        查询条件
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
        <!-- 报表使用 -->
        <input type="hidden" id="expressType" name="expressType" value=""/>
            <tr height="20">

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">业务流水号</td>
                <td width="15%" class="data_input"><input type="text" id="FLOWSN" name="FLOWSN" value="" style="width:96% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">抵押库柜号</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="boxid" name="boxid" size="60" style="width:90% ">
                </td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">交易中心</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = null;
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                            zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from ln_morttype where deptid='" + deptId +
                                    "' and typeflag='0' order by mortecentercd");
                        }else{
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "MORTECENTERCD");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">机构</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addOption("", "");
                        //zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="检索">
                </td>
            </tr>
            <tr height="20">
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    借款人姓名
                </td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                    <%--class="ajax-suggestion url-getPull.jsp">--%>
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> 合作项目简称</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">约定放款方式</td>
                <td width="15%" class="data_input"><%
                    zs = new ZtSelect("releasecondcd", "releasecondcd", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">抵押编号</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="mortid" name="mortid" size="60" style="width:90% ">
                </td>

                <td align="left" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="重填"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend>
        抵押信息
    </legend>
    <table width="100%">
        <tr>
            <td>
                <%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND>
        操作
    </LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right">
                <%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>

<div id="search-result-suggestions">
    <div id="search-results">
    </div>
</div>
</body>
</html>
