        <!--
/*********************************************************************
* ��������: ��ѺԤԼ��Ϣ¼��
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.DateTime" %>
<%
    String doType = "";
    String clientNames = "";
    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

    String predays;
    ConnectionManager cm = null;
    try {
        cm = ConnectionManager.getInstance();
        DatabaseConnection dc = cm.get();
        RecordSet chrs = dc.executeQuery("select t.enuitemexpand from ptenudetail t where t.enutype='APPTPARAM' and t.enuitemvalue = 'APPT_APPLY_DAYS'");
        predays = "0";
        if (chrs != null && chrs.next()) {
            predays = chrs.getString("enuitemexpand");
        }
        //��ǰԤԼ������ ��Ѻ���ڸڣ�role:WF0006�� ������
        OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
        chrs = dc.executeQuery("select roleid from ptoperrole where operid = '" + omgr.getOperatorId() + "' and roleid = 'WF0006'");
        if (chrs != null && chrs.next()) {
            predays = "0";
        }
    } finally {
        if (cm != null) {
            cm.release();
        }
    }

    DateTime dateTime = new DateTime().plusDays(Integer.valueOf(predays));
    String startdate = dateTime.toString("yyyy-MM-dd");

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>ԤԼ��Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="apptApplyParamEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>ԤԼ������Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <input type="hidden" id="appt_date_init" value="<%=startdate%>">
                <input type="hidden" id="appt_date_pre" value="<%=predays%>">
                <input type="hidden" id="mortecentercd">
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">ԤԼ����</td>
                    <td width="35%" class="data_input"><input type="text" id="limitDate" name="limitDate" style="width:90% ">
                    </td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>����</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center">
                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="����" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
</body>
</html>
