<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*" %>
<%
    // �����������
    String loanID = "";
    // ��������
    String doType = "";
    // ��Ѻ���
    String mortID = "";
    // ������Ŀ����
    LNLOANAPPLY loan = null;

    if (request.getParameter("loanID") != null)
        loanID = request.getParameter("loanID");

    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");


        // ��ʼ��ҳ��
        LNMORTINFO bean = LNMORTINFO.findFirst("where loanid='" + loanID + "'");
        if (bean != null) {
            StringUtils.getLoadForm(bean, out);
        }
    if (doType.equals("edit")) {
        LNINSURANCE insurance = LNINSURANCE.findFirst(" where loanid='" + loanID + "'");
        if (insurance != null) {
            StringUtils.getLoadForm(insurance,out);
        }
    }

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

%>
<html>


<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>��Ѻ��Ϣ�Ǽ�</title>

    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="insuranceEdit.js"></script>

</head>
<body bgcolor="#ffffff" onload="formInit();" class="Bodydefault">
<br>

<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>��Ѻ��Ϣ�Ǽ�</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <!-- ��������˳��� -->
                <input type="hidden" id="loanid" name="loanid" value=""/>
                <!-- ��Ѻ��� -->
                <input type="hidden" id="mortid" name="mortid" value=""/>
                <input type="hidden" id="insurancests" name="insurancests" value=""/>
                <tr>
                    <td width="20%" class="lbl_right_padding">�Ƿ������</td>
                    <td width="30%" class="data_input">
                        <%
                            ZtSelect zs = new ZtSelect("attendflag", "BOOLTYPE", "");
                            zs.addAttr("style", "width: 40%");
                            zs.addAttr("fieldType", "text");
                            //zs.addAttr("isNull","false");
                            out.print(zs);
                        %>
                    </td>
                </tr>

            </table>
        </fieldset>

        <br>
        <fieldset>
            <legend>������Ϣ</legend>

            <table width="100%" cellspacing="0" border="0">

                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                    <td width="30%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>"
                                                              style="width:90%" disabled="disabled"></td>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
                    <td width="30%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                              style="width:90%" disabled="disabled"></td>
                </tr>
            </table>
        </fieldset>
        <br>
        <fieldset>
            <legend>����</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center">

                        <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                               onmouseout="button_onmouseout()" type="button" value="����" onclick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                               onmouseout="button_onmouseout()" type="button" value="ȡ��" onclick="window.close();">

                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
</body>
</html>