<!--
/*********************************************************************
* ��������: ��Ѻ��Ϣ���������ϸҳ��
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
    //�˻����
    String acctid = "";
    // �����������
    String loanid = "";
    // ��������
    String doType = "";
    // �û�����
    PTOPER oper = null;
    // �˻�����
    String custname = "";

    if (request.getParameter("loanid") != null){
        loanid = request.getParameter("loanid");
    }
    if (request.getParameter("doType") != null){
        doType = request.getParameter("doType");
    }
    if (request.getParameter("custname") != null){
        custname = request.getParameter("custname");
        custname = new String(custname.getBytes("ISO8859-1"),"GBK");
    }
    if (request.getParameter("acctid") != null){
        acctid = request.getParameter("acctid");
    }

    // ��ʼ��ҳ��
    LNACCTINFO bean = LNACCTINFO.findFirst("where acct_id='" + acctid + "'");
    if (bean != null) {
        StringUtils.getLoadForm(bean, out);
    }

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    //ȡ���û�������
    if (bean != null) {
        oper = PTOPER.findFirst("where operid='" + bean.getOperid() + "'");
    }
    if (oper == null) {
        oper = new PTOPER();
    }
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>�ɿ����˻���Ϣ</title>

    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="acctEdit.js"></script>


</head>
<body onload="formInit();" class="Bodydefault">

<form id="editForm" name="editForm">
<fieldset style="padding: 15px">
    <legend style="margin-bottom: 10px">������Ϣ</legend>
    <table width="100%" cellspacing="0" border="0">
        <input type="hidden" id="acctid" value="<%=acctid%>">
        <input type="hidden" id="doType" value="<%=doType%>">
        <input type="hidden" id="recversion" value=""/>
        <!-- ��ˮ��־��ʹ�� -->
        <input type="hidden" id="busiNode" name="busiNode" value=""/>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">���������</td>
            <td width="30%" class="data_input" colspan="3"><input type="text" id="LOANID" name="LOANID" value="<%=loanid%>"
                                                      intLength="24" style="width:90% " isNull="false"  disabled="disabled"><span
                    class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">ί���˻�����</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_NAME" name="ACCT_NAME" style="width:90%" value="<%=custname%>"
                                                      textLength="50" isNull="false"><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">ί���տ��˺�</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_NO" name="ACCT_NO" style="width:90%"
                                                      textLength="30" isNull="false"><span class="red_star">*</span>
            </td>

        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">��������</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_BANK" name="ACCT_BANK" style="width:90%"
                                                      textLength="50" isNull="false"><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ѻ�ѽ��</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_AMT" name="ACCT_AMT" value=""
                                                      onblur="Txn_GotFocus(this);" style="width:90%" intLength="18"
                                                      floatLength="2"
                                                      isNull="false"><span class="red_star">*</span></td>

        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ѻ����</td>
            <td width="35%" class="data_input">
                <%
                    ZtSelect zs;
                    zs = new ZtSelect("APPT_TYPE", "APPTTYPE", "1");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    zs.addOption("", "");
                    out.print(zs);
                %><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">��ע</td>
            <td width="35%" class="data_input"><input type="text" id="REMARK" name="REMARK" value=""
                                                      style="width:90%"
                                                      intLength="100"></td>
        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
            <td width="35%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%"
                                                      disabled="disabled"></td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
            <td width="35%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                      style="width:90%"
                                                      disabled="disabled"></td>
        </tr>
    </table>
</fieldset>
<fieldset>
    <legend>����</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td align="center">
                <!--��ѯ-->
                <%if (doType.equals("select")) { %>
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="�ر�" onclick="window.close();">
                <%} else if (doType.equals("edit") || doType.equals("add")) { %>
                <!--���ӣ��޸�-->
                <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="����" onclick="saveClick();">
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="ȡ��" onclick="window.close();">
                <%} else if (doType.equals("delete")) { %>
                <!--ɾ��-->
                <input id="deletebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="ɾ��" onclick="deleteClick();">
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="ȡ��" onclick="window.close();">
                <%} %>
            </td>
        </tr>
    </table>
</fieldset>

</form>
</body>
</html>
