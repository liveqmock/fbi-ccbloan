 <!--
/*********************************************************************
* ��������: ��ѺԤԼȷ�ϴ���ȷ��
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

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>ԤԼ��Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="apptConfirmYesEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>ԤԼ����ȷ��</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">ԤԼȷ�ϱ�ע</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="appt_sendback_remark" rows="10"
                                                                             id="appt_sendback_remark" style="width:90.4%"
                                                                             textLength="200"></textarea></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">���������</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="clientNames" rows="2"
                                                                             id="clientNames" style="width:90.4%" readonly="true"
                                                                             ></textarea></td>
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
