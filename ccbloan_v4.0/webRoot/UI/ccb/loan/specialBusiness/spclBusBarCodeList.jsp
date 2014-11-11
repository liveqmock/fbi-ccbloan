<!--
/*********************************************************************
* ��������: ������ҳ����ʾ
* �޸���: nanmeiying
* �޸�����: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.db.DBGrid" %>
<%@page import="pub.platform.system.manage.dao.PtDeptBean" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>���������</title>
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
    dbGrid.setField("ҵ����ˮ��", "center", "13", "CUSTNO", "true", "-1");
    dbGrid.setField("����������", "center", "13", "CUSTNAME", "true", "0");
    //dbGrid.setField("��������", "center", "7", "custname", "true", "0");
    dbGrid.setField("����ҵ������", "center", "15", "BUSTYPE", "true", "0");
    dbGrid.setField("���(����)������1", "center", "25", "ADDNAME1", "true", "0");
    dbGrid.setField("���(����)������2", "center", "25", "ADDNAME2", "true", "0");
    dbGrid.setField("�������", "center", "7", "AGENCIES", "true", "0");
    dbGrid.setField("Ӫ������", "number", "7", "MARKETINGMANAGER", "true", "0");
    dbGrid.setField("��Ӫ����", "center", "7", "OPERATINGCENTER", "true", "0");
    dbGrid.setField("�ͻ�����", "center", "7", "CUSTOMERMANAGER", "true", "0");
    dbGrid.setField("��������", "center", "7", "MODIFYDATE", "true", "0");
   // dbGrid.setField("����״̬", "center", "7", "aaa", "true", "0");
    dbGrid.setField("������ע", "center", "7", "REMARK", "true", "0");

    dbGrid.setWhereStr(" order by a.createdate desc  ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,���������=barCodeManage,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ϵͳ��־��ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" class="lbl_right_padding">ҵ����ˮ��</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="custno" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">������֤������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="applyid" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custname" size="60" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ����������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="bankid" size="60" value="<%=deptid%>" style="width:90% ">
                </td>

            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>
                <td width="30%" class="data_input">
                    <input type="text" id="opername" size="60" style="width:90% ">
                </td>

                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="�� ��">
                </td>

                <td width="10%" align="right" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="�� ��"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>

            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> �ͻ���Ϣ</legend>
    <table width="100%" class="title1">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> ����</LEGEND>
    <table width="100%">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%></td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>
