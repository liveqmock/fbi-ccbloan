<%@ page import="com.ccb.util.CcbLoanConst" %>
<!--
/*********************************************************************
* ��������: ������Ѻ���������ѯ
* ��������: 2013/05/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="sscmFeedbackQry.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>

    <script language="javascript" src="/UI/support/suggest/js/ajaxSuggestions.js"></script>
    <style type="text/css" media="screen">
        @import url("/UI/support/suggest/css/ajax-suggestions.css");
    </style>

    <script type="text/javascript">
        // ��pulldownֵ���Ƶ�input��
        function setPullToInput(elm) {
            document.getElementById("cust_name").value = elm.innerText;
            document.getElementById("cust_name").focus();
        }

    </script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("mainTab");
    dbGrid.setGridType("edit");

    String sql = "select b.recVersion, a.nbxh, b.MORTECENTERCD,(select deptname from ptdept where deptid=a.bankid) as deptname," +
            "a.loanid,a.cust_name,a.RT_ORIG_LOAN_AMT,b.mortid,b.documentid,"
            + " b.mortregstatus, b.CLRPAPERDATE, b.CLRREASONCD, b.CLRREASONREMARK, b.SSCM_STATUS, b.SSCM_DATE, b.SSCM_NOCANCEL_REASON "
            + " from ln_loanapply a,ln_mortinfo b where  "
            + " a.loanid = b.loanid and b.mortstatus='" + CcbLoanConst.MORT_FLOW_CLEARED + "' "
            + " and SSCM_STATUS is not null ";
    dbGrid.setfieldSQL(sql);

    dbGrid.setField("�汾��", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("nbxh", "text", "4", "nbxh", "false", "0");
    dbGrid.setField("��������", "dropdown", "6", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("����", "center", "10", "deptname", "true", "0");
    dbGrid.setField("�����������", "center", "12", "loanid", "true", "0");
    dbGrid.setField("���������", "text", "6", "cust_name", "true", "0");
    dbGrid.setField("������", "money", "8", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("��Ѻ���", "center", "6", "mortid", "true", "-1");
    dbGrid.setField("�������", "center", "6", "DOCUMENTID", "true", "0");
    dbGrid.setField("��Ѻ״̬", "dropdown", "6", "mortregstatus", "true", "MORTREGSTATUS");
    dbGrid.setField("ȡ֤����", "text", "8", "CLRPAPERDATE", "true", "0");
    dbGrid.setField("ȡ֤ԭ��", "dropdown", "8", "CLRREASONCD", "true", "CLRREASONCD");
    dbGrid.setField("ȡ֤��ע", "text", "12", "CLRREASONREMARK", "true", "0");
    dbGrid.setField("������Ѻ״̬", "dropdown", "6", "SSCM_STATUS", "true", "SSCM_STATUS");
    dbGrid.setField("������Ѻ����", "text", "8", "SSCM_DATE", "true", "0");
    dbGrid.setField("δ��Ѻԭ��ע", "text", "12", "SSCM_NOCANCEL_REASON", "true", "0");

    dbGrid.setWhereStr(" and 1!=1 ");

    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    dbGrid.setbuttons("����Excel=excel,�鿴����=loanQuery,�鿴��Ѻ=query,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
        <!-- ����ʹ�� -->
        <input type="hidden" id="expressType" name="expressType" value=""/>
            <tr height="20">
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ���������
                </td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td align="center" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="����">
                </td>
            </tr>
            <tr height="20">
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        out.print(zs);
                    %>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ѻ״̬</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("SSCM_STATUS", "SSCM_STATUS", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>

                <td align="center" nowrap="nowrap">
                    <input name="clear" type="button" class="buttonGrooveDisable"
                           onClick="clear_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="���">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend>
        ��Ѻ��Ϣ
    </legend>
    <table width="100%">
        <tr>
            <td>
                <%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND>
        ����
    </LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right">
                <%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>

<div id="search-result-suggestions">
    <div id="search-results">
    </div>
</div>
</body>
</html>
