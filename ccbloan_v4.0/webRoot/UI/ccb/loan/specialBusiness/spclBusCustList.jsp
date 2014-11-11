<!--
/*********************************************************************
* 功能描述: 特殊业务资料管理列表
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
    <title>客户管理</title>
    <script language="javascript" src="spclBusCustList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    PtDeptBean ptOperBean = omgr.getOperator().getPtDeptBean();
    DBGrid dbGrid = new DBGrid();
    String deptid = ptOperBean.getDeptid();
    dbGrid.setGridID("creditraTable");
    dbGrid.setGridType("edit");
    String sql = "select a.CUSTNO," +
            "(select DEPTNAME || '('|| DEPTID || ')' from ptdept where DEPTID = a.BANKID) as BANKID," +
            "a.CUSTNAME,a.APPLYID,a.APPLYTEL1," +
            "(select EnuItemLabel from ptEnuDetail where EnuType = 'SPCLBUSTYPE' and  EnuItemValue= a.BUSTYPE) as BUSTYPE,"+
            "a.ADDNAME1,a.ADDNAME2,"+
            "(select EnuItemLabel from ptEnuDetail where EnuType = 'MARISTA' and EnuItemValue=a.APPLYMARRIAGE) as APPLYMARRIAGE,"+
            "a.MATENAME,a.MATEIDCARD," +
            "a.MATETEL,a.BASISREMARK,a.OPERID,a.OPERDATE,a.MODIFYOPERID,a.MODIFYDATE" +
            " from LN_SPCLBUS_CUST a where 1=1 ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("业务流水号", "center", "18", "CUSTNO", "true", "-1");
    dbGrid.setField("建立机构", "center", "16", "BANKID", "true", "0");
    //dbGrid.setField("贷款种类", "center", "30", "BUSTYPE", "true", "0");
    dbGrid.setField("申请人姓名", "center", "10", "CUSTNAME", "true", "0");
    dbGrid.setField("申请人证件号码", "center", "18", "APPLYID", "true", "0");
    dbGrid.setField("申请人联系电话", "center", "18", "APPLYTEL1", "true", "0");
    dbGrid.setField("申请业务种类", "center", "26", "BUSTYPE", "true", "0");
    dbGrid.setField("变更(增加)人姓名1", "center", "20", "ADDNAME1", "true", "0");
    dbGrid.setField("变更(增加)人姓名2", "center", "20", "ADDNAME2", "true", "0");
    dbGrid.setField("婚姻状况", "center", "17", "APPLYMARRIAGE", "true", "0");
    dbGrid.setField("配偶姓名", "center", "16", "MATENAME", "true", "0");
    dbGrid.setField("配偶证件号码", "center", "16", "MATEIDCARD", "true", "0");
    dbGrid.setField("配偶联系电话", "center", "15", "MATETEL", "true", "0");
    dbGrid.setField("备注", "center", "15", "BASISREMARK", "true", "0");
    dbGrid.setField("建立柜员", "center", "10", "OPERID", "true", "0");
    dbGrid.setField("建立日期", "center", "16", "OPERDATE", "true", "0");
    dbGrid.setField("修改柜员", "center", "10", "MODIFYOPERID", "true", "0");
    dbGrid.setField("修改日期", "center", "20", "MODIFYDATE", "true", "0");

    dbGrid.setWhereStr(" order by a.createdate desc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("导出Excel=excel,查看客户详情=query,新增客户=appendRecod,修改客户=editRecord,删除客户=deleteRecord,moveFirst,prevPage,nextPage,moveLast");
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
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">申请人姓名</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="custname" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">申请业务种类</td>
                <td width="30%" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("bustype", " ", "");
                        zs.setSqlString("select EnuItemValue as value,EnuItemLabel as text from ptEnuDetail where EnuType = 'SPCLBUSTYPE' order by EnuItemValue");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "false");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> 建立机构号</td>
                <td width="30%" class="data_input">
                    <input type="text" id="bankid" size="60" value="<%=deptid%>" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="检 索">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">建立柜员</td>
                <td width="30%" class="data_input">
                    <input type="text" id="operid" size="60" style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">修改柜员</td>
                <td width="30%" class="data_input">
                    <input type="text" id="modifyoperid" size="60" style="width:90% ">
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
</body>
</html>
