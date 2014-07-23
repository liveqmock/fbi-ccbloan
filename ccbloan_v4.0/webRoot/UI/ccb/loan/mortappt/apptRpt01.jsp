<!--
/*********************************************************************
* ��������: ��ѺԤԼ����Ѻ����ͳ����������ϸ
* ��������: 2013/06/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="apptRpt01.js"></script>
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
    String deptId = omgr.getOperator().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("mainTab");
    dbGrid.setGridType("edit");

    String sql = "select a.nbxh, b.mortecentercd, "
            + "     (select deptname from ptdept where deptid=a.bankid) as deptname,"
            + "     a.loanid,a.cust_name, "
            + "     (select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = a.ln_typ) as ln_typ,"
            + "     a.RT_ORIG_LOAN_AMT, b.mortid,"
            + "     c.PROJ_NAME_ABBR, b.mortstatus, b.apptstatus,"
            + "     b.APPT_BIZ_CODE, (b.APPT_HDL_DATE||decode(b.APPT_HDL_TIME,'01','����','����')) APPT_HDL_DATE,  "
            + "     b.recVersion, b.FLOWSN, b.APPT_CONFIRM_RESULT, b.APPT_DATE_CONFIRM,b.APPT_FEEDBACK_RESULT  "
            + " from ln_loanapply a,ln_mortinfo b,ln_coopproj c  "
            + "  where a.loanid = b.loanid "
            + "   and a.proj_no = c.proj_no "
            + "   and b.apptstatus is not null and b.apptstatus >= '20' "
            + "   and b.APPT_VALID_FLAG = '1' " //��ЧԤԼ
            + "";
    dbGrid.setfieldSQL(sql);

    dbGrid.setField("nbxh", "center", "0", "nbxh", "false", "0");
    dbGrid.setField("��������", "dropdown", "8", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("����", "center", "10", "deptname", "true", "0");
    dbGrid.setField("���������", "text", "12", "loanid", "true", "0");
    dbGrid.setField("�����", "center", "8", "cust_name", "true", "0");
    dbGrid.setField("��������", "center", "10", "ln_typ", "true", "0");
    dbGrid.setField("������", "money", "10", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("��Ѻ���", "center", "8", "mortid", "true", "-1");
    dbGrid.setField("��Ŀ���", "center", "12", "PROJ_NAME", "true", "0");
    dbGrid.setField("��Ѻ״̬", "dropdown", "8", "MORTSTATUS", "true", "MORTSTATUS");
    dbGrid.setField("ԤԼ״̬", "dropdown", "10", "APPTSTATUS", "true", "APPTSTATUS");
    dbGrid.setField("ҵ������", "dropdown", "12", "APPT_BIZ_CODE", "true", "APPTBIZCODE");
    dbGrid.setField("ԤԼʱ��", "center", "12", "APPT_HDL_DATE", "true", "0");
    // ���ֶ����������·�ֹ��������ؼ��ֶΣ�����ɾ������˳��Ź̶���11
    dbGrid.setField("�汾��", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("ҵ����ˮ��", "center", "12", "FLOWSN", "false", "0");
    dbGrid.setField("ȷ�Ͻ��", "dropdown", "8", "APPT_CONFIRM_RESULT", "true", "APPT_CONFIRM_RESULT");
    dbGrid.setField("ȷ������", "center", "8", "APPT_DATE_CONFIRM", "true", "0");
    dbGrid.setField("������", "dropdown", "10", "APPT_FEEDBACK_RESULT", "true", "APPT_FEEDBACK_RESULT");

    dbGrid.setWhereStr(" order by b.appt_date_apply desc, b.appt_time_apply desc, b.mortecentercd, a.bankid, b.mortid ");
    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(false);
    dbGrid.setbuttons("����Excel=excel,�鿴����=loanQuery,�鿴��Ѻ=query,moveFirst,prevPage,nextPage,moveLast");

    //����
    DBGrid sumDbGrid = new DBGrid();
    sumDbGrid.setGridID("sumTab");
    sumDbGrid.setGridType("edit");

    String sumSql = "select b.mortecentercd, count(*) as tot\n" +
            "  from ln_loanapply a, ln_mortinfo b\n" +
            " where a.loanid = b.loanid\n" +
            "   and b.apptstatus is not null\n" +
            "   and b.apptstatus >= '20'\n" +
            "   and b.APPT_VALID_FLAG = '1'\n" +
            " ";
    sumDbGrid.setfieldSQL(sumSql);

    sumDbGrid.setField("��������", "dropdown", "20", "MORTECENTERCD", "true", "MORTECENTERCD");
    sumDbGrid.setField("ԤԼȷ�ϱ����ϼ�", "center", "10", "tot", "true", "0");

    sumDbGrid.setWhereStr(" group by mortecentercd ");
    sumDbGrid.setpagesize(10);
    sumDbGrid.setdataPilotID("datapilot");
    sumDbGrid.setCheck(false);
    sumDbGrid.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ʼ����</td>
                <td width="20%" class="data_input"><input type="text" id="STARTDATE" name="STARTDATE" value=""
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ֹ����</td>
                <td width="20%" class="data_input"><input type="text" id="ENDDATE" name="ENDDATE"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% " >
                </td>
                <td align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button" style="margin-right: 20px;margin-left: 20px;"
                           onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="����">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend>
        ��ѺԤԼ��Ϣ
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
<fieldset>
    <legend>
        ����ͳ����Ϣ
    </legend>
    <table width="100%">
        <tr>
            <td>
                <%=sumDbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET style="margin-top: 15px">
    <LEGEND>
        ����
    </LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right">
                <%=sumDbGrid.getDataPilot()%>
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
