<!--
/*********************************************************************
* ��������: ��Ѻ��Ϣ�����Ѻ��ϸҳ��;��Ѻ��֤�Ǽ� (��Ѻ���Ǽ�)
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
    // �����������
    String loanID = "";
    // ��������
    String doType = "";
    // ��Ѻ���
    String mortID = "";

    if (request.getParameter("loanID") != null)
        loanID = request.getParameter("loanID");

    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");
    if ("add".equalsIgnoreCase(doType)) {
        // �Զ�ȡ����Ѻ���
        //mortID = SeqUtil.getSeq(CcbLoanConst.MORTTYPE);
    } else {
        if (request.getParameter("mortID") != null)
            mortID = request.getParameter("mortID");
        // ��ʼ��ҳ��
        LNINSURANCE bean = LNINSURANCE.findFirst("where mortid='" + mortID + "'");
        if (bean != null) {
            StringUtils.getLoadForm(bean, out);
        }
    }

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

%>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=GBK">
<title>���յ����Ǽ�</title>
<script language="javascript" src="/UI/support/tabpane.js"></script>
<script language="javascript" src="/UI/support/common.js"></script>
<script language="javascript" src="/UI/support/DataWindow.js"></script>
<script language="javascript" src="/UI/support/pub.js"></script>
<script language="javascript" src="insuranceRtnPaperEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
  <form id="editForm" name="editForm">
    <br>
    <fieldset>
    <legend>���յ����Ǽ�</legend>
    <table width="100%" cellspacing="0" border="0">
      <!-- �������� -->
      <input type="hidden" id="doType" value="<%=doType%>">

      <input type="hidden" id="attendflag" name="attendflag" value=""/>
        <input type="hidden" id="insurancests" name="insurancests" value=""/>

      <tr>
        <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����������</td>
        <td width="30%" class="data_input"><input type="text" id="loanID" name="loanID" value="<%=loanID%>"
                                                              style="width:90% " disabled="disabled"></td>
        <td width="20%" nowrap="nowrap" class="lbl_right_padding">��Ѻ���</td>
        <td width="30%" class="data_input"><input type="text" id="mortID" name="mortID" value="<%=mortID%>"
                                                              style="width:90%" disabled="disabled"></td>
      </tr>
      <tr>
        <td width="20%" nowrap="nowrap" class="lbl_right_padding">�������</td>
        <td width="30%" colspan="3" class="data_input"><input name="PAPERRTNDATE" type="text"
                                                                          id="PAPERRTNDATE" style="width:33.4%"
                                                                          onClick="WdatePicker()" fieldType="date"
                                                                          isNull="false">
          <span class="red_star">*</span></td>
      </tr>

      <tr>
        <td width="20%" class="lbl_right_padding">�������</td>
        <td width="30%"  class="data_input">
            <input id="INSURANCEID" name="INSURANCEID" style="width:90%" textLength="12">
          <span class="red_star">*</span></td>

          <td width="20%" nowrap="nowrap" class="lbl_right_padding">��Ҫ�������</td>
          <td width="30%" class="data_input"><input type="text" id="documentid" name="documentid" style="width:90%"
                                                    textLength="30">
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
    </fieldset>
    <fieldset>
    <legend>����</legend>
    <table width="100%" class="title1" cellspacing="0">
      <tr>
        <td align="center"><!--��ѯ-->
          <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onmouseout="button_onmouseout()" type="button" value="����" onClick="saveClick();">
          <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onmouseout="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
        </td>
      </tr>
    </table>
    </fieldset>
  </form>
</div>
<div id="search-result-suggestions">
  <div id="search-results"> </div>
</div>
</body>
</html>
