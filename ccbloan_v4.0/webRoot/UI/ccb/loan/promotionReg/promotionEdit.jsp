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
    //���֤����
    String promcustid = "";

    if (request.getParameter("doType") != null) {
        doType = request.getParameter("doType");
    }
    if (request.getParameter("promcustno") != null) {
        promcustid = request.getParameter("promcustno");
    }
    if (!"add".equalsIgnoreCase(doType)) {
        LNPROMOTIONCUSTOMERS bean = LNPROMOTIONCUSTOMERS.findFirst("where PROMCUST_NO='" + promcustid + "'");
        if (bean != null) {
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
    <script language="javascript" src="promotionEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container"><br>

    <form id="editForm" name="editForm">
        <input type="hidden" id="recVersion" value=""/>
        <input type="hidden" id="PROMCUST_NO" value="<%=promcustid%>"/>
        <input type="hidden" id="operbankid" value="<%=omgr.getOperator().getPtDeptBean().getDeptid()%>"/>
        <!-- ��ˮ��־��ʹ�� -->
        <input type="hidden" id="busiNode" name="busiNode" value=""/>
        <fieldset>
            <legend>Ӫ������¼��ͻ���Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">����</td>
                    <td width="35%" class="data_input"><input type="text" id="CUST_NAME" name="CUST_NAME" value=""
                                                              style="width:90% " isNull="false">
                        <span class="red_star">*</span>
                    </td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">֤������</td>
                    <td width="35%" class="data_input">
                        <input type="text" id="CUST_ID" name="CUST_ID" value="" style="width:90%">
                        <span class="red_star">*</span></td>

                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                    <td width="35%" class="data_input">
                        <%
                            ZtSelect zs = new ZtSelect("LN_TYP", "", "");
                            zs.setSqlString("select code_id as value ,code_desc as text  from ln_odsb_code_desc where code_type_id='053'");
                            zs.addAttr("style", "width: 90%");
                            zs.addAttr("fieldType", "text");
                            zs.addOption("", "");
                            out.print(zs);
                        %>
                    </td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">Ӫ������</td>
                    <td width="35%" class="data_input"><input name="PROMMGR_NAME" type="text" id="PROMMGR_NAME"
                                                              style="width:90%" value="" isNull="false">
                        <span class="red_star">*</span>
                    </td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">������</td>
                    <td width="35%" class="data_input">
                        <input type="text" id="rt_orig_loan_amt" name="rt_orig_loan_amt" value="" style="width:90%">
                    </td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                    <td width="35%" class="data_input"><input type="text" id="RT_TERM_INCR" name="RT_TERM_INCR" value=""
                                                              style="width:90%">
                    </td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">�ͻ��绰</td>
                    <td width="35%" class="data_input"><input name="CUST_PHONE" type="text" id="CUST_PHONE"
                                                              style="width:90%" value="">
                    </td>
                    <td nowrap="nowrap" class="data_input" colspan="2"></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                    <td width="35%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>"
                                                              style="width:90%" disabled="disabled"></td>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
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
