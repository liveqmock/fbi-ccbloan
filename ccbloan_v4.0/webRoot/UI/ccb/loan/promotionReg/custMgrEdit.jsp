<!--
/*********************************************************************
* ��������: Ӫ������¼���ƽ����Ϣ
*
* �� ��: haiyuhuang
* ��������: 2011/07/22
* �� �� ��:
* �޸�����:
* �� Ȩ:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*" %>
<%
    //��������
    String doType = "";
    //�����ͻ�˳���
    String promcustid = "";
    // �ͻ�����ID
    String custMgrID = "";

    if (request.getParameter("doType") != null) {
        doType = request.getParameter("doType");
    }
    if (request.getParameter("promcustno") != null) {
        promcustid = request.getParameter("promcustno");
    }
    if (!"add".equalsIgnoreCase(doType)) {
        LNPROMOTIONCUSTOMERS bean = LNPROMOTIONCUSTOMERS.findFirst("where PROMCUST_NO='" + promcustid + "'");
        if (bean != null) {
            custMgrID = bean.getCustmgr_id();
            StringUtils.getLoadForm(bean, out);
        }
    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>�ͻ���Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="custMgrEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container"><br>

    <form id="editForm" name="editForm">
        <input type="hidden" id="recVersion" value=""/>
        <input type="hidden" id="PROMCUST_NO" value="<%=promcustid%>"/>
        <!-- �༭��ʱ����ʾ�ͻ�����IDʹ�� -->
        <input type="hidden" id="custMgrID" value="<%=custMgrID%>"/>
        <!-- ��ˮ��־��ʹ�� -->
        <input type="hidden" id="busiNode" name="busiNode" value=""/>
        <input type="hidden" id="custbankid" name="custbankid" value="<%=omgr.getOperator().getDeptid()%>"/>
        <fieldset>
            <legend>�ͻ������޸��ƽ���Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ӫ����</td>
                    <td width="35%" class="data_input">
                        <%
                            ZtSelect zs = new ZtSelect("CUST_BANKID", "", omgr.getOperator().getDeptid());
                            zs.setSqlString("select deptid, deptname  from ptdept where FILLSTR10='3'"
                                    + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                    + " connect by prior deptid = parentdeptid");
                            zs.addAttr("style", "width: 90%");
                            zs.addAttr("fieldType", "text");
                            zs.addAttr("onchange", "reSelect()");
//                            zs.addOption("", "");
                            zs.addAttr("isNull", "false");
                            out.print(zs);
                        %><span class="red_star">*</span>
                    </td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>
                    <td width="35%" class="data_input">
                        <%
                            zs = new ZtSelect("CUSTMGR_ID", "", "");
                            zs.addAttr("style", "width: 90%");
                            zs.addAttr("fieldType", "text");
                            zs.addAttr("isNull", "false");
                            zs.addOption("", "");
                            out.print(zs);
                        %><span class="red_star">*</span>
                    </td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">������</td>
                    <td width="35%" class="data_input">
                        <input type="text" id="rt_orig_loan_amt" name="rt_orig_loan_amt" value=""
                               style="width:90%">
                    </td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">���״̬</td>
                    <td width="35%" class="data_input">
                        <%
                            zs = new ZtSelect("STATUS", "RELEASECHECK", "");
                            zs.addAttr("style", "width: 90%");
                            zs.addAttr("fieldType", "text");
                            zs.addAttr("isNull", "false");
                            out.print(zs);
                        %><span class="red_star">*</span>
                    </td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��ע</td>
                    <td colspan="3" class="data_input">
                        <input type="text" id="REMARK" name="REMARK" value=""
                               style="width:96.4%"></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                    <td width="35%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>"
                                                              style="width:90%" disabled="disabled"></td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
                    <td width="35%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                              style="width:90%" disabled="disabled"></td>
                </tr>
            </table>
        </fieldset>
        <br>
        <fieldset>
            <legend>����</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center"><!--��ѯ-->
                        <%if (doType.equals("select")) { %>
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="�ر�" onClick="window.close();">
                        <%} else if (doType.equals("edit") || doType.equals("add")) { %>
                        <!--���ӣ��޸�-->
                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="����" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
                        <%} else if (doType.equals("delete")) { %>
                        <!--ɾ��-->
                        <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ɾ��" onClick="deleteClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
                        <%} %>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
<div id="search-result-suggestions">
    <div id="search-results"></div>
</div>
</body>
</html>
