<!--
/*********************************************************************
* ��������: ����ҵ�����Ϲ����б�
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
    <title>�ͻ�����</title>
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
    dbGrid.setField("ҵ����ˮ��", "center", "18", "CUSTNO", "true", "-1");
    dbGrid.setField("��������", "center", "16", "BANKID", "true", "0");
    //dbGrid.setField("��������", "center", "30", "BUSTYPE", "true", "0");
    dbGrid.setField("����������", "center", "10", "CUSTNAME", "true", "0");
    dbGrid.setField("������֤������", "center", "18", "APPLYID", "true", "0");
    dbGrid.setField("��������ϵ�绰", "center", "18", "APPLYTEL1", "true", "0");
    dbGrid.setField("����ҵ������", "center", "26", "BUSTYPE", "true", "0");
    dbGrid.setField("���(����)������1", "center", "20", "ADDNAME1", "true", "0");
    dbGrid.setField("���(����)������2", "center", "20", "ADDNAME2", "true", "0");
    dbGrid.setField("����״��", "center", "17", "APPLYMARRIAGE", "true", "0");
    dbGrid.setField("��ż����", "center", "16", "MATENAME", "true", "0");
    dbGrid.setField("��ż֤������", "center", "16", "MATEIDCARD", "true", "0");
    dbGrid.setField("��ż��ϵ�绰", "center", "15", "MATETEL", "true", "0");
    dbGrid.setField("��ע", "center", "15", "BASISREMARK", "true", "0");
    dbGrid.setField("������Ա", "center", "10", "OPERID", "true", "0");
    dbGrid.setField("��������", "center", "16", "OPERDATE", "true", "0");
    dbGrid.setField("�޸Ĺ�Ա", "center", "10", "MODIFYOPERID", "true", "0");
    dbGrid.setField("�޸�����", "center", "20", "MODIFYDATE", "true", "0");

    dbGrid.setWhereStr(" order by a.createdate desc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,�鿴�ͻ�����=query,�����ͻ�=appendRecod,�޸Ŀͻ�=editRecord,ɾ���ͻ�=deleteRecord,moveFirst,prevPage,nextPage,moveLast");
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
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">����������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="custname" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ҵ������</td>
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
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ����������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="bankid" size="60" value="<%=deptid%>" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="�� ��">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" id="operid" size="60" style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�޸Ĺ�Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" id="modifyoperid" size="60" style="width:90% ">
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
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> ����</LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>
