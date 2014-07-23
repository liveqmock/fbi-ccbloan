<!--
/*********************************************************************
* ��������: ��ѺԤԼʧ����ϸ��ѯ
* ��������: 2013/07/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="apptFailQry.js"></script>
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

    String sql = "select a.nbxh,\n" +
            "       b.mortecentercd,\n" +
            "       (select deptname from ptdept where deptid = a.bankid) as deptname,\n" +
            "       a.loanid,\n" +
            "       a.cust_name,\n" +
            "       (select code_desc as text\n" +
            "          from ln_odsb_code_desc\n" +
            "         where code_type_id = '053'\n" +
            "           and code_id = a.ln_typ) as ln_typ,\n" +
            "       a.RT_ORIG_LOAN_AMT,\n" +
            "       b.mortid,\n" +
            "       a.PROJ_NAME_ABBR,\n" +
            "       b.mortstatus,\n" +
            "       b.apptstatus,\n" +
            "       b.recVersion,\n" +
            "       b.FLOWSN, b.APPT_BIZ_CODE, (b.APPT_HDL_DATE||decode(b.APPT_HDL_TIME,'01','����','����')) APPT_HDL_DATE_TMP�� \n" +
            "       b.RELEASECONDCD\n" +
            "  from (select t1.*,\n" +
            "               case t1.proj_no\n" +
            "                 when null then\n" +
            "                  ''\n" +
            "                 else\n" +
            "                  (select proj_name_abbr\n" +
            "                     from ln_coopproj\n" +
            "                    where proj_no = t1.proj_no)\n" +
            "               end as proj_name_abbr\n" +
            "          from ln_loanapply t1) a,\n" +
            "       ln_mortinfo b,\n" +
            "       (select *\n" +
            "          from (select t.mortid, count(*) as cnt\n" +
            "                  from LN_MORT_APPT t\n" +
            "                 where t.txncode = 'apply_add'\n" +
            "                   and t.appt_date >= '{startDate}'\n" +
            "                   and t.appt_date <= '{endDate}'\n" +
            "                 group by t.mortid)\n" +
            "         where cnt >= 3) c\n" +
            " where a.loanid = b.loanid\n" +
            "   and b.mortid = c.mortid\n" +
            " ";
//            " order by b.mortecentercd, a.bankid, b.mortid\n";

    sql = sql.replace("{startDate}", startDate);
    sql = sql.replace("{endDate}", endDate);

    dbGrid.setfieldSQL(sql);

    dbGrid.setField("nbxh", "center", "0", "nbxh", "false", "0");
    dbGrid.setField("��������", "dropdown", "6", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("����", "center", "10", "deptname", "true", "0");
    dbGrid.setField("���������", "text", "12", "loanid", "true", "0");
    dbGrid.setField("�����", "center", "6", "cust_name", "true", "0");
    dbGrid.setField("��������", "center", "8", "ln_typ", "true", "0");
    dbGrid.setField("������", "money", "8", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("��Ѻ���", "center", "6", "mortid", "true", "-1");
    dbGrid.setField("��Ŀ���", "center", "10", "PROJ_NAME", "true", "0");
    dbGrid.setField("��Ѻ״̬", "dropdown", "8", "MORTSTATUS", "true", "MORTSTATUS");
    dbGrid.setField("ԤԼ״̬", "dropdown", "8", "APPTSTATUS", "true", "APPTSTATUS");
    // ���ֶ����������·�ֹ��������ؼ��ֶΣ�����ɾ������˳��Ź̶���11
    dbGrid.setField("�汾��", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("ҵ����ˮ��", "center", "12", "FLOWSN", "false", "0");
    dbGrid.setField("ҵ������", "dropdown", "12", "APPT_BIZ_CODE", "true", "APPTBIZCODE");
    dbGrid.setField("ԤԼʱ��", "center", "12", "APPT_HDL_DATE_TMP", "true", "0");
    dbGrid.setField("�ſʽ", "dropdown", "6", "RELEASECONDCD", "true", "RELEASECONDCD");

    dbGrid.setWhereStr(" and 1!=1 ");
//dbGrid.setWhereStr(" order by b.appt_date_apply desc, b.appt_time_apply desc, b.mortecentercd, a.bankid, b.mortid ");
    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(false);
    dbGrid.setbuttons("����Excel=excel,�鿴����=loanQuery,�鿴��Ѻ=query,moveFirst,prevPage,nextPage,moveLast");

%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <input type="hidden" id="tabSql" name="tab1Sql" value="<%=sql%>"/>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                        //zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from ln_morttype where deptid='" + deptId + "' and typeflag='0'");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ʼ����</td>
                <td width="20%" class="data_input"><input type="text" id="STARTDATE" name="STARTDATE"
                                                          value="<%=startDate%>"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ԤԼ��ֹ����</td>
                <td width="20%" class="data_input"><input type="text" id="ENDDATE" name="ENDDATE"
                                                          value="<%=endDate%>"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           style="margin-right: 20px;margin-left: 20px;"
                           onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="����">
                </td>
            </tr>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="20%" nowrap="nowrap" class="data_input">
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
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ��Ŀ���
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="proj_name_abbr" name="proj_name_abbr" style="width:90%">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">ҵ������</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("APPTBIZCODE", "APPTBIZCODE", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend>
        ��ѺԤԼ3�����ϣ���3�Σ����ɹ���ϸ
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
