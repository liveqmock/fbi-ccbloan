<!--
/*********************************************************************
* ��������: �����ͻ��б�
* �޸���: nanmeiying
* �޸�����: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.db.DBGrid" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>������־</title>
    <script language="javascript" src="operLogQry.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("creditraTable");
    dbGrid.setGridType("edit");
    String sql = "select a.creditratingno,decode(a.creattype,'0','��ͨ����','1','����ͨ����') as creattype,a.opername,a.opertime,a.olddate,a.newdate from ln_creatlog a where 1=1 ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("����������", "center", "1", "creditratingno", "true", "-1");
    dbGrid.setField("��������", "center", "1", "creattype", "true", "-1");
    dbGrid.setField("������", "center", "1", "opername", "true", "0");
    dbGrid.setField("����ʱ��", "center", "1", "opertime", "true", "0");
    dbGrid.setField("����Ч��", "center", "1", "olddate", "true", "0");
    dbGrid.setField("����Ч��", "center", "1", "newdate", "true", "0");
    dbGrid.setWhereStr(" order by opertime desc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("moveFirst,prevPage,nextPage,moveLast");

%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ϵͳ��־��ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <input type="hidden" id="pkid" name="pkid" value="">
            <tr>
                <td width="10%" class="lbl_right_padding">����������</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="creditratingno" size="30" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">������</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="opername" size="60" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <select id="creattype">
                        <option value=""></option>
                        <option value="0">��ͨ����</option>
                        <option value="1">����ͨ����</option>
                    </select>
                </td>
                <td width="25%" align="center" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="�� ��">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> ������¼</legend>
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
