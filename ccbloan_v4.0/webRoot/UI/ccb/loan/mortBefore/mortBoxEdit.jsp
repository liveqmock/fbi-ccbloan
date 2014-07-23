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
    String strMortid = "";
    String recVersion = "";
    String strBoxid = "";
    if (request.getParameter("strMortid") != null)
        strMortid = request.getParameter("strMortid");

    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

    if (request.getParameter("recVersion") != null)
        recVersion = request.getParameter("recVersion");

    if (request.getParameter("strBoxid") != null)
        strBoxid = request.getParameter("strBoxid");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>�˻���Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="mortBoxEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>��Ѻ�����Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <input type="hidden" id="strMortid" value="<%=strMortid%>">
                <input type="hidden" id="DEPT_ID" value="<%=deptId%>">
                <input type="hidden" id="recVersion" value="<%=recVersion%>">

                <tr>
                    <td width="15%"  nowrap="nowrap" class="lbl_right_padding">���</td>
                    <td width="35%"  class="data_input" ><input type="text" id="boxid" name="boxid"  value=""  style="width:90% " textLength="10" isNull="false">
                        <span class="red_star">*</span>
                    </td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��ݱ�ע</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="EXPRESSNOTE" rows="3"
                                                                             id="EXPRESSNOTE" style="width:96.4%"
                                                                             textLength="500"></textarea></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">���������</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="clientNames" rows="2"
                                                                             id="clientNames" style="width:96.4%" readonly="true"></textarea></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">ԭ�й��</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="strBoxid" rows="2"
                                                                             id="strBoxid" style="width:96.4%" readonly="true"></textarea></td>
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
