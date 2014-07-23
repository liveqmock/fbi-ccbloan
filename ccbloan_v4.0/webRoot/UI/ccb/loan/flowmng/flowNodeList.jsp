<!--
/*********************************************************************
* ��������: ����������չ�����
* �� ��: zr
* ��������: 2013/03/10
* �� �� ��:
* �޸�����:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.*" %>
<%
    // �û�����
    PTOPER oper = null;
    // �ͻ�����ID
    String custmgrId = "";

    // ��ʼ��ҳ��
    LNARCHIVEINFO bean = new LNARCHIVEINFO();
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

    //List
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanTab");
    dbGrid.setGridType("edit");
    String commSql = "select " +
            "  c.cust_name, " +
            " (select roledesc from ptrole where roleid = b.roleid) as roledesc," +
            "       a.operdate," +
            "       a.opertime," +
            "       (select opername from ptoper where operid = a.operid) as opername," +
            "       a.flowstat," +
            "       a.remark" +
            "  from ln_archive_flow a" +
            "  left join ptoperrole b" +
            "    on a.operid = b.operid " +
            "  left join ln_archive_info c" +
            "    on a.flowsn = c.flowsn" +
            " where " +
            "   b.roleid =" +
            "       (select min(roleid) from ptoperrole where operid = a.operid and roleid like 'WF%') ";
    //" and a.flowsn = '" + omgr.getOperatorId() +"'";
    dbGrid.setWhereStr(" and 1=1 order by a.operdate desc, opertime desc");
    dbGrid.setfieldSQL(commSql);

    dbGrid.setField("�����", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("��λ����", "center", "5", "roledesc", "true", "0");
    dbGrid.setField("��������", "center", "5", "operdate", "true", "0");
    dbGrid.setField("����ʱ��", "center", "5", "opertime", "true", "0");
    dbGrid.setField("������Ա", "center", "5", "opername", "true", "0");
    dbGrid.setField("����״̬", "dropdown", "5", "flowstat", "true", "ARCHIVEFLOW");
    dbGrid.setField("����˵��", "center", "15", "remark", "true", "0");

    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("moveFirst,prevPage,nextPage,moveLast");
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>������Ϣ</title>

    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="flowNodeList.js"></script>

</head>
<%--<body onload="formInit();" class="Bodydefault">--%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">

<form id="queryForm" name="queryForm">
    <fieldset style="padding: 15px">
        <legend style="margin-bottom: 10px">ҵ�����̽��չ�����</legend>
        <table width="100%" cellspacing="0" border="0">

            <input type="hidden" id="recversion" value=""/>
            <input type="hidden" id="af_recversion" value=""/>
            <input type="hidden" id="af_pkid" value=""/>
            <input type="hidden" id="deptid" value="<%=omgr.getOperator().getDeptid()%>"/>
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <tr>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ҵ����ˮ��</td>
                <td width="90%" class="data_input" colspan="3">
                    <textarea id="FLOWSN" name="FLOWSN" rows="10" value="" style="width:96%" textLength="5000" isNull="false">
                    </textarea>
                </td>
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">ҵ��������״̬</td>
                <td width="35%" class="data_input" colspan="3">
                    <input id="FLOWSTAT1" type="radio" checked="checked" name="FLOWSTAT" value="10"/>��������
                    <input id="FLOWSTAT2" type="radio" name="FLOWSTAT" value="20"/>�������
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">ҵ�������̱�ע</td>
                <td width="35%" class="data_input" colspan="3">
                    <textarea id="AF_REMARK" name="AF_REMARK" rows="15" value="" style="width:96%" textLength="500">
                    </textarea>
                </td>

            </tr>

        </table>
    </fieldset>

    <fieldset>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td align="center">
                    <!--���ӣ��޸�-->
                    <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="�ύ" onclick="saveClick();">
                </td>
            </tr>
        </table>
    </fieldset>
</form>

<fieldset>
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
</body>
</html>
