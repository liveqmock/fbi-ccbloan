<!--
/*********************************************************************
* 功能描述: 条形码页面显示
* 修改人: nanmeiying
* 修改日期: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.db.DBGrid" %>
<%@page import="pub.platform.system.manage.dao.PtDeptBean" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>条形码管理</title>
    <script language="javascript" src="spclBusBarCodeList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    PtDeptBean ptOperBean = omgr.getOperator().getPtDeptBean();
    DBGrid dbGrid = new DBGrid();
    String deptid = ptOperBean.getDeptid();
    dbGrid.setGridID("creditraTable");
    dbGrid.setGridType("edit");
    String sql = "select a.CUSTNO,a.CUSTNAME," +
            "(select EnuItemLabel from ptEnuDetail where EnuType = 'SPCLBUSTYPE' and  EnuItemValue= a.BUSTYPE) as BUSTYPE," +
            "a.ADDNAME1,a.ADDNAME2," +
            " (select deptname from ptdept where deptid=a.AGENCIES) as AGENCIES," +
            "(select prommgr_name from ln_prommgrinfo where prommgr_id=a.MARKETINGMANAGER) as MARKETINGMANAGER," +
            "(select deptname from ptdept where deptid=a.OPERATINGCENTER) as OPERATINGCENTER,"+
            "(select opername from ptoper where operid=a.CUSTOMERMANAGER) as CUSTOMERMANAGER,"+
            "a.MODIFYDATE,a.REMARK"+
            " from LN_SPCLBUS_CUST a left join ptoper p  on  a.CUSTOMERMANAGER =p.operid  where 1=1";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("业务流水号", "center", "13", "CUSTNO", "true", "-1");
    dbGrid.setField("申请人姓名", "center", "13", "CUSTNAME", "true", "0");
    //dbGrid.setField("贷款种类", "center", "7", "custname", "true", "0");
    dbGrid.setField("申请业务种类", "center", "15", "BUSTYPE", "true", "0");
    dbGrid.setField("变更(增加)人姓名1", "center", "25", "ADDNAME1", "true", "0");
    dbGrid.setField("变更(增加)人姓名2", "center", "25", "ADDNAME2", "true", "0");
    dbGrid.setField("经办机构", "center", "7", "AGENCIES", "true", "0");
    dbGrid.setField("营销经理", "number", "7", "MARKETINGMANAGER", "true", "0");
    dbGrid.setField("经营中心", "center", "7", "OPERATINGCENTER", "true", "0");
    dbGrid.setField("客户经理", "center", "7", "CUSTOMERMANAGER", "true", "0");
    dbGrid.setField("操作日期", "center", "7", "MODIFYDATE", "true", "0");
   // dbGrid.setField("流程状态", "center", "7", "aaa", "true", "0");
    dbGrid.setField("操作备注", "center", "7", "REMARK", "true", "0");

    dbGrid.setWhereStr(" order by a.createdate desc  ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("导出Excel=excel,条形码管理=barCodeManage,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> 查询条件</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- 系统日志表使用 -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" class="lbl_right_padding">业务流水号</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="custno" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">申请人证件号码</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="applyid" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">申请人姓名</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custname" size="60" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> 操作机构号</td>
                <td width="30%" class="data_input">
                    <input type="text" id="bankid" size="60" value="<%=deptid%>" style="width:90% ">
                </td>

            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">客户经理</td>
                <td width="30%" class="data_input">
                    <input type="text" id="opername" size="60" style="width:90% ">
                </td>

                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="检 索">
                </td>

                <td width="10%" align="right" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="重 填"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>

            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> 客户信息</legend>
    <table width="100%" class="title1">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> 操作</LEGEND>
    <table width="100%">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%></td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>
