<!--
/*********************************************************************
* 功能描述: 权证的签收处理
* 开发日期: 2013/03/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK"%>
<%@page import="com.ccb.util.CcbLoanConst"%>
<%@include file="/global.jsp"%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="paperSigninList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/suggest/js/ajaxSuggestions.js"></script>
    <style type="text/css" media="screen">
        @import url("/UI/support/suggest/css/ajax-suggestions.css");
    </style>
    <script type="text/javascript">
        // 把pulldown值复制到input中
        function setPullToInput(elm){
            document.getElementById("cust_name").value=elm.innerText;
            document.getElementById("cust_name").focus();
        }
    </script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanRegistedTab");
    dbGrid.setGridType("edit");

    String sql = "select a.nbxh,b.MORTECENTERCD,"
            +"(select deptname from ptdept where deptid=a.bankid) as deptname,"
            +"a.cust_name,a.RT_ORIG_LOAN_AMT,b.RELEASECONDCD,b.mortid,b.mortdate,b.BOXID,b.EXPRESSRTNDATE,b.recVersion,b.loanid"
            +" from ln_loanapply a,ln_mortinfo b where "
            +" a.loanid = b.loanid and b.mortstatus='"+CcbLoanConst.MORT_FLOW_RETURN+"'  "
            + " and b.Releasecondcd in ('04','05','06') "
            + "  "
            // 抵押交易中心过滤
            + " and b.MORTECENTERCD in (select mortecentercd from ln_morttype where typeflag='0' and deptid='"+deptId+"') ";

    dbGrid.setfieldSQL(sql);

    dbGrid.setField("nbxh", "text", "4", "nbxh", "false", "0");
    dbGrid.setField("交易中心", "dropdown", "6", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("机构", "center", "6", "deptname", "true", "0");
    dbGrid.setField("姓名", "text", "6", "cust_name", "true", "0");
    dbGrid.setField("金额", "money", "7", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("放款方式", "dropdown", "6", "RELEASECONDCD", "true", "RELEASECONDCD");
    dbGrid.setField("抵押编号", "center", "6", "mortid", "true", "0");
    dbGrid.setField("抵押日期", "center", "6", "mortdate", "true", "0");
    dbGrid.setField("柜号", "center", "6", "boxid", "true", "0");
    dbGrid.setField("权证发出日期", "text", "8", "EXPRESSRTNDATE", "true", "0");
    // 该字段是批量更新防止并发问题关键字段，不能删除；
    dbGrid.setField("版本号", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("loanid", "text", "2", "loanid", "false", "0");
//        dbGrid.setWhereStr(" order by a.cust_py asc ");
    dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='"+omgr.getOperator().getDeptid()+"' connect by prior deptid=parentdeptid) order by b.mortecentercd, a.bankid, b.mortid ");

    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    //20120524 zhanrui
    dbGrid.setbuttons("导出excel=excel,查看贷款=loanQuery,查看抵押=query,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        查询条件
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%" >
        <form id="queryForm" name="queryForm">
            <!-- 报表使用 -->
            <input type="hidden" id="expressType" name="expressType" value=""/>
            <tr height="20">

                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    借款人姓名
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                    <%--class="ajax-suggestion url-getPull.jsp">--%>
                </td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">交易中心</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                        zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from ln_morttype where deptid='" + deptId +
                                "' and typeflag='0' order by mortecentercd");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        //zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">机构</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>

                <td  align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button" onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="检索">
                </td>
            </tr>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">发出起始日期</td>
                <td width="20%" class="data_input"><input type="text" id="STARTDATE" name="STARTDATE" value=""
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">发出截止日期</td>
                <td width="20%" class="data_input"><input type="text" id="ENDDATE" name="ENDDATE"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% " >
                </td>
                <td width="10%"></td>
                <td width="20%"></td>

                <td align="right" nowrap="nowrap">
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
