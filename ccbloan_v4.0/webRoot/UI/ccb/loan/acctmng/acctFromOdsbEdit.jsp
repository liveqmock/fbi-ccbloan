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
    String strLoanid = "";
    if (request.getParameter("strLoanid") != null)
        strLoanid = request.getParameter("strLoanid");

    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

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
    <script language="javascript" src="acctFromOdsbEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>��ȡί���˺���Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <input type="hidden" id="strLoanid" value="<%=strLoanid%>">
                <input type="hidden" id="DEPT_ID" value="<%=deptId%>">

                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ѻ�ѽ��</td>
                    <td width="35%" class="data_input"><input type="text" id="ACCT_AMT" name="ACCT_AMT" value=""
                                                              onblur="Txn_GotFocus(this);" style="width:90%" intLength="12"
                                                              floatLength="2"
                                                              isNull="false"><span class="red_star">*</span></td>
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
