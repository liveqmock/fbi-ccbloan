<!--
/*********************************************************************
* ��������: ��Ѻ��Ϣ�����Ѻ��ϸҳ��;���п�����δ����Ѻ���ӵǼ�
*
* �� ��: leonwoo
* ��������: 2010/01/16
* �� �� ��:
* �޸�����:
* �� Ȩ: ��˾
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*" %>
<%

    // ��������
    String doType = "";
    // ��Ѻ���
    String mortID = "";


    /*if (request.getParameter("mortID") != null)
        mortID = request.getParameter("mortID");
    // ��ʼ��ҳ��
    LNMORTINFO bean = LNMORTINFO.findFirst("where mortid='" + mortID + "'");
    if (bean != null) {
        StringUtils.getLoadForm(bean, out);
    }*/

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>���п��������ɱ���Ѻ���ӵǼ�</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script type="text/javascript" language="javascript">
        function formInit() {
            // ��������Զ�����
            var date = new Date();
            document.getElementById("RPTMORTDATE").value = getDateString(date);
            document.getElementById("SENDFLAG").value = "1";
		    document.getElementById("SENDFLAG").disabled = "true";
        }
        function saveClick() {
            var arg = new Object();
            if (operation = "edit") {
                arg.rptmortdt = document.getElementById("RPTMORTDATE").value;
                arg.sendflag = document.getElementById("SENDFLAG").value;
                window.returnValue = arg;
                window.close();
            }
        }
    </script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">

<fieldset>
    <legend>
        ���п��������ɱ���Ѻ���ӵǼ�
    </legend>
    <form id="queryForm" name="queryForm">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">���ɱ�/�ɱ���Ѻ��־</td>
                <td width="30%" class="data_input"><%
                    ZtSelect zs = new ZtSelect("SENDFLAG", "SENDFLAG", "1");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    out.print(zs);
                %>
                    <span class="red_star">*</span></td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ɱ���Ѻʱ��</td>
                <td width="30%" class="data_input"><input name="RPTMORTDATE" type="text" id="RPTMORTDATE"
                                                          style="width:90%" onClick="WdatePicker()"
                                                          fieldType="date">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                <td width="30%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>"
                                                          style="width:90%" disabled="disabled"></td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
                <td width="30%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                          style="width:90%" disabled="disabled"></td>
            </tr>
        </table>
    </form>
</fieldset>
<fieldset>
    <legend>
        ����
    </legend>
    <table align="center">
        <tr>
            <td align="center">
                <input class="buttonGrooveDisable" type="button" id="btnSubmit" onclick="saveClick()" value="ȷ ��">
                <input name="Input" class="buttonGrooveDisable" type="reset" value="ȡ ��" onClick="window.close();">
            </td>
        </tr>
    </table>
</fieldset>

</body>
</html>