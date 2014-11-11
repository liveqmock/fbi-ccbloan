<!--
/*********************************************************************
* 功能描述: 流程处理综合查询
* 作 者: zr
* 开发日期: 2013/03/10
* 修 改 人:
* 修改日期:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.*" %>
<%
    // 用户对象
    PTOPER oper = null;
    // 客户经理ID
    String custmgrId = "";

    // 初始化页面
    LNARCHIVEINFO bean = new LNARCHIVEINFO();
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

    //流程基本信息表
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("flowInfoTab");
    dbGrid.setGridType("edit");
    String infoSql = "select a.flowsn as keycode, " +
            "  a.cust_name, a.bustype," +
            "  (select deptname from ptdept where deptid = a.bankid) as bankname,      " +
            "  (select prommgr_name  from ln_prommgrinfo where prommgr_id = a.custmgr_id) as custmgr_name,     " +
            "  (select deptname from ptdept where deptid = a.cust_bankid) as cust_bankname,      " +
            "  (select opername from ptoper where operid = a.realcustmgr_id) as realcustmgr_name,     " +
            "  (select  code_desc  from ln_odsb_code_desc where code_type_id='053' and code_id = a.ln_typ) as ln_typ,    " +
            "  a.operdate " +
            "  from ln_spclbus_info a" +
            "  where 1 = 1" +
            " ";

    infoSql += "  and exists (select  1 from (select deptid from ptdept start with deptid = '" + omgr.getOperator().getDeptid() + "' connect by prior deptid = parentdeptid)  where a.bankid = deptid) ";

    dbGrid.setfieldSQL(infoSql);

    dbGrid.setField("业务流水号", "center", "8", "keycode", "true", "-1");
    dbGrid.setField("申请人", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("申请业务种类", "dropdown", "5", "bustype", "true", "SPCLBUSTYPE");
    dbGrid.setField("经办机构", "center", "5", "bankname", "true", "0");
    dbGrid.setField("营销经理", "center", "5", "custmgr_name", "true", "0");
    dbGrid.setField("经营中心", "center", "5", "cust_bankname", "true", "0");
    dbGrid.setField("客户经理", "center", "5", "realcustmgr_name", "true", "0");
    dbGrid.setField("贷款种类", "center", "5", "ln_typ", "true", "0");
    dbGrid.setField("操作日期", "center", "5", "operdate", "false", "0");

    dbGrid.setWhereStr(" and 1=2 order by a.operdate desc ");
    dbGrid.setpagesize(5);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("moveFirst,prevPage,nextPage,moveLast");


    //流程节点表
    DBGrid dbGridDetail = new DBGrid();
    dbGridDetail.setGridID("flowNodeTab");
    dbGridDetail.setGridType("edit");
    String detailSql = "select (select roledesc from ptrole where roleid = b.roleid) as roledesc, " +
            " a.operdate, a.opertime," +
            " (select opername from ptoper where operid = a.operid) as opername,  a.flowstat, " +
            " a.remark  " +
            "  from ln_spclbus_flow a  " +
            "  left join ptoperrole b    " +
            "  on a.operid = b.operid " +
            "  where 1=1" +
//            "  b.roleid =(select min(roleid) from ptoperrole where operid = a.operid and roleid like 'WF%') "
            " ";
    dbGridDetail.setWhereStr(" and 1=2 order by a.operdate desc,a.opertime desc ");
    dbGridDetail.setfieldSQL(detailSql);

    dbGridDetail.setField("岗位名称", "center", "5", "roledesc", "true", "0");
    dbGridDetail.setField("交接日期", "center", "5", "operdate", "true", "0");
    dbGridDetail.setField("交接时间", "center", "5", "opertime", "true", "0");
    dbGridDetail.setField("操作人员", "center", "5", "opername", "true", "0");
    dbGridDetail.setField("处理状态", "dropdown", "5", "flowstat", "true", "ARCHIVEFLOW");
    dbGridDetail.setField("操作说明", "center", "15", "remark", "true", "0");

    dbGridDetail.setpagesize(15);
    dbGridDetail.setdataPilotID("detaildatapilot");
    //dbGridDetail.setbuttons("default");
    dbGridDetail.setbuttons("moveFirst,prevPage,nextPage,moveLast");
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>贷款信息</title>

    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/js/basic.js"></script>
    <script language="javascript" src="/js/xmlHttp.js"></script>
    <script language="javascript" src="/js/dbgrid.js"></script>
    <script language="javascript" src="/js/dbutil.js"></script>
    <script language="javascript" src="spclBusFlowCompQry.js"></script>
</head>
<%--<body onload="formInit();" class="Bodydefault">--%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">

<form id="queryForm" name="queryForm">
    <fieldset style="padding: 15px">
        <legend style="margin-bottom: 10px">查询条件</legend>
        <table width="100%" cellspacing="0" border="0">
            <input type="hidden" id="recversion" value=""/>
            <input type="hidden" id="af_recversion" value=""/>
            <input type="hidden" id="af_pkid" value=""/>
            <input type="hidden" id="deptid" value="<%=omgr.getOperator().getDeptid()%>"/>
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">业务流水号</td>
                <td width="30%" class="data_input"><input type="text" id="FLOWSN" name="FLOWSN" value=""
                                                          textLength="100" style="width:90% ">
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">申请人</td>
                <td width="35%" class="data_input"><input type="text" id="CUST_NAME" name="CUST_NAME" style="width:90%"
                                                          textLength="40"  >
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">经办机构</td>
                <td width="35%" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("BANKID", "", "");
                        zs.setSqlString("select deptid, deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid  order by FILLSTR20,deptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("onchange", "reSelect()");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">营销经理</td>
                <td width="35%" class="data_input">
                    <%
                        zs = new ZtSelect("CUSTMGR_ID", "", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("onchange", "promMgrReSelect()");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
            </tr>
        </table>
    </fieldset>
    <fieldset>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td align="center">
                    <!--增加，修改-->
                    <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="检索" onclick="onSearch();">
                    <input name="" class="buttonGrooveDisable" type="reset" value="重填" onmouseover="button_onmouseover()" onmouseout="button_onmouseout()">
                </td>
            </tr>
        </table>
    </fieldset>
</form>
<fieldset>
    <LEGEND>特殊业务申请资料信息列表</LEGEND>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
<fieldset style="margin-top: 15px">
    <LEGEND> 业务流程信息列表</LEGEND>
    <table width="100%">
        <tr>
            <td><%=dbGridDetail.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGridDetail.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>