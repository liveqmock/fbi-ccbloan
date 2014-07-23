<!--
/*********************************************************************
* ��������: ��ѺԤԼ����Ѻ����ͳ����������ϸ
* ��������: 2013/06/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="apptSuccRateQry.js"></script>
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

    // ��ʼ��ҳ��
    Calendar calendar = new GregorianCalendar();
    Calendar calendar1 = new GregorianCalendar(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) - 1, 1);
    Date lastmonth = calendar1.getTime();
    String startDate = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

    calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMaximum(Calendar.DAY_OF_MONTH));
    lastmonth = calendar1.getTime();
    String endDate = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("mainTab");
    dbGrid.setGridType("edit");

    String sql = "select MORTECENTERCD,\n" +
            "       total,\n" +
            "       succ,\n" +
            "       RTrim(To_Char(succ / total * 100, 'FM990.99'), '.') || '%' as rate\n" +
            "  from (select t.MORTECENTERCD,\n" +
            "               count(*) as total,\n" +
            "               count(case\n" +
            "                       when t.apptstatus in ('30', '50', '90', '91') then\n" +
            "                        1\n" +
            "                       else\n" +
            "                        null\n" +
            "                     end) as succ\n" +
            "          from LN_MORTINFO t\n" +
            "         where t.apptstatus is not null\n" +
            "           and t.appt_hdl_date >= '{startDate}'\n" +
            "           and t.appt_hdl_date <= '{endDate}'\n" +
            "         group by t.MORTECENTERCD)\n";

    sql = sql.replace("{startDate}", startDate);
    sql = sql.replace("{endDate}", endDate);

    dbGrid.setfieldSQL(sql);

    dbGrid.setField("��������", "dropdown", "8", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("ԤԼ����", "center", "5", "total", "true", "0");
    dbGrid.setField("ԤԼ�ɹ���", "center", "5", "succ", "true", "0");
    dbGrid.setField("ԤԼ�ɹ���", "center", "5", "rate", "true", "0");

    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(false);
    dbGrid.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");

    //����
    DBGrid dbGrid2 = new DBGrid();
    dbGrid2.setGridID("bankTab");
    dbGrid2.setGridType("edit");

    String sql2 = "select (select deptname from ptdept where deptid = bankid) as bank_name,\n" +
            "       total,\n" +
            "       succ,\n" +
            "       RTrim(To_Char(succ / total * 100, 'FM990.99'), '.') || '%' as rate\n" +
            "  from (select a.bankid,\n" +
            "               count(*) as total,\n" +
            "               count(case\n" +
            "                       when t.apptstatus in ('30', '50', '90', '91') then\n" +
            "                        1\n" +
            "                       else\n" +
            "                        null\n" +
            "                     end) as succ\n" +
            "          from LN_MORTINFO t, ln_loanapply a\n" +
            "         where t.apptstatus is not null\n" +
            "           and t.loanid = a.loanid\n" +
            "           and t.appt_hdl_date >= '{startDate}'\n" +
            "           and t.appt_hdl_date <= '{endDate}'\n" +
            "         group by a.bankid)\n" +
            " order by bankid\n";

    sql2 = sql2.replace("{startDate}", startDate);
    sql2 = sql2.replace("{endDate}", endDate);

    dbGrid2.setfieldSQL(sql2);

    dbGrid2.setField("��������", "dropdown", "8", "bank_name", "true", "0");
    dbGrid2.setField("ԤԼ����", "center", "5", "total", "true", "0");
    dbGrid2.setField("ԤԼ�ɹ���", "center", "5", "succ", "true", "0");
    dbGrid2.setField("ԤԼ�ɹ���", "center", "5", "rate", "true", "0");

    dbGrid2.setpagesize(50);
    dbGrid2.setdataPilotID("datapilot");
    dbGrid2.setCheck(false);
    dbGrid2.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <input type="hidden" id="tab1Sql" name="tab1Sql" value="<%=sql%>"/>
            <input type="hidden" id="tab2Sql" name="tab2Sql" value="<%=sql2%>"/>
            <tr height="20">
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ʼ����</td>
                <td width="30%" class="data_input"><input type="text" id="STARTDATE" name="STARTDATE"
                                                          value="<%=startDate%>"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ֹ����</td>
                <td width="30%" class="data_input"><input type="text" id="ENDDATE" name="ENDDATE"
                                                          value="<%=endDate%>"
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
                <%=dbGrid2.getDBGrid()%>
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
                <%=dbGrid2.getDataPilot()%>
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
