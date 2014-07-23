<!--
/*********************************************************************
* ��������: �����������ͳ��
* �� ��: zr
* ��������: 2013/06/1
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.PTOPER" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // �û�����
    PTOPER oper = null;

    // ��ʼ��ҳ��
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    Calendar calendar = new GregorianCalendar();
    Calendar calendar1 = new GregorianCalendar(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) - 1, 1);
    Date lastmonth = calendar1.getTime();
    String startDate = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

    calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMaximum(Calendar.DAY_OF_MONTH));
    lastmonth = calendar1.getTime();
    String endDate = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

    //���̻�����Ϣ��
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("tab1");
    dbGrid.setGridType("edit");
    String infoSql = "select (select deptname from ptdept where deptid = cust_bankid) as custbank_name,\n" +
            "       tbl.*\n" +
            "  from (select (select deptid\n" +
            "                  from ptdept\n" +
            "                 where fillstr10 = '3'\n" +
            "                   and rownum = 1\n" +
            "                 start with deptid = t.bankid\n" +
            "                connect by prior parentdeptid = deptid) as cust_bankid,\n" +
            "               (select deptname from ptdept where deptid = bankid) as bank_name,\n" +
            "               bankid,\n" +
            "               prommgr_id,\n" +
            "               (select prommgr_name\n" +
            "                  from ln_prommgrinfo\n" +
            "                 where prommgr_id = t.prommgr_id) as prommgr_name,\n" +
            "               total,\n" +
            "               succ,\n" +
            "               fail,\n" +
            "               RTrim(To_Char(succ / total * 100, 'FM990.99'), '.') || '%' as rate\n" +
            "          from (select bankid,\n" +
            "                       prommgr_id,\n" +
            "                       count(*) as total,\n" +
            "                       count(case flowstat\n" +
            "                               when '10' then\n" +
            "                                1\n" +
            "                               else\n" +
            "                                null\n" +
            "                             end) as succ,\n" +
            "                       count(case flowstat\n" +
            "                               when '20' then\n" +
            "                                1\n" +
            "                               else\n" +
            "                                null\n" +
            "                             end) as fail\n" +
            "                  from (select a.operdate,\n" +
            "                               a.flowsn,\n" +
            "                               c.bankid,\n" +
            "                               c.custmgr_id as prommgr_id,\n" +
            "                               a.flowstat\n" +
            "                          from ln_archive_flow a,\n" +
            "                               ptoperrole      b,\n" +
            "                               ln_archive_info c\n" +
            "                         where a.operid = b.operid(+)\n" +
            "                           and b.roleid = 'WF0001'\n" +
            "                           and exists\n" +
            "                         (select 1\n" +
            "                                  from PTENUDETAIL t\n" +
            "                                 where enutype = 'ARCHIVE_SUM_RPT_OPER'\n" +
            "                                   and t.enuitemvalue = a.operid)\n" +
            "                           and a.flowsn = c.flowsn\n" +
            "                           and a.operdate >= '{startDate}'\n" +
            "                           and a.operdate <= '{endDate}')\n" +
            "                 group by bankid, prommgr_id) t\n" +
            "       ) tbl order by cust_bankid, bankid, rate desc\n";

    String tab1Sql= infoSql;
    infoSql = infoSql.replace("{startDate}", startDate);
    infoSql = infoSql.replace("{endDate}", endDate);

    dbGrid.setfieldSQL(infoSql);

    dbGrid.setField("��Ӫ����", "center", "8", "custbank_name", "true", "0");
    dbGrid.setField("��Ӫ����ID", "center", "8", "cust_bankid", "false", "0");
    dbGrid.setField("�������", "center", "8", "bank_name", "true", "0");
    dbGrid.setField("�������ID", "center", "8", "bankid", "false", "0");
    dbGrid.setField("Ӫ������ID", "center", "8", "prommgr_id", "true", "0");
    dbGrid.setField("Ӫ������", "center", "8", "prommgr_name", "true", "0");
    dbGrid.setField("����", "center", "5", "total", "true", "0");
    dbGrid.setField("ͨ����", "center", "5", "succ", "true", "0");
    dbGrid.setField("�����", "center", "5", "fail", "true", "0");
    dbGrid.setField("ͨ����", "center", "5", "rate", "true", "0");

    //dbGrid.setWhereStr(" and 1=2 order by a.operdate desc ");
    dbGrid.setpagesize(120);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");


    //���̽ڵ��
    DBGrid dbGridDetail = new DBGrid();
    dbGridDetail.setGridID("tab2");
    dbGridDetail.setGridType("edit");
    String detailSql = "select cust_bankid,\n" +
            "       (select deptname from ptdept where deptid = cust_bankid) as bank_name,\n" +
            "       total,\n" +
            "       succ,\n" +
            "       fail,\n" +
            "       RTrim(To_Char(succ / total * 100,'FM990.99'),'.') || '%' as rate\n" +
            "  from (select cust_bankid,\n" +
            "               count(*) as total,\n" +
            "               count(case flowstat\n" +
            "                       when '10' then\n" +
            "                        1\n" +
            "                       else\n" +
            "                        null\n" +
            "                     end) as succ,\n" +
            "               count(case flowstat\n" +
            "                       when '20' then\n" +
            "                        1\n" +
            "                       else\n" +
            "                        null\n" +
            "                     end) as fail\n" +
            "          from (select a.operdate,\n" +
            "                       a.flowsn,\n" +
            "                       c.bankid,\n" +
            "                       (select deptid  from ptdept where fillstr10 = '3' and rownum = 1 start with deptid = c.bankid connect by prior parentdeptid = deptid) as cust_bankid,\n" +
            "                       c.custmgr_id as prommgr_id,\n" +
            "                       a.flowstat\n" +
            "                  from ln_archive_flow a, ptoperrole b, ln_archive_info c\n" +
            "                 where a.operid = b.operid(+)\n" +
            "                   and b.roleid = 'WF0001'\n" +
            "                   and exists (select 1 from PTENUDETAIL t where enutype='ARCHIVE_SUM_RPT_OPER' and t.enuitemvalue=a.operid)\n" +
            "                   and a.flowsn = c.flowsn\n" +
            "                   and a.operdate >= '{startDate}'\n" +
            "                   and a.operdate <= '{endDate}')\n" +
            "         group by cust_bankid) t\n" +
            " order by  rate desc\n";
    System.out.println(detailSql);

    String tab2Sql= detailSql;
    detailSql = detailSql.replace("{startDate}", startDate);
    detailSql = detailSql.replace("{endDate}", endDate);

    dbGridDetail.setfieldSQL(detailSql);

    dbGridDetail.setField("��Ӫ����ID", "center", "8", "bankid", "true", "0");
    dbGridDetail.setField("��Ӫ����", "center", "8", "bank_name", "true", "0");
    dbGridDetail.setField("����", "center", "5", "total", "true", "0");
    dbGridDetail.setField("ͨ����", "center", "5", "succ", "true", "0");
    dbGridDetail.setField("�����", "center", "5", "fail", "true", "0");
    dbGridDetail.setField("ͨ����", "center", "5", "rate", "true", "0");

    dbGridDetail.setpagesize(32);
    dbGridDetail.setdataPilotID("detaildatapilot");
    dbGridDetail.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>������Ϣ</title>

    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/js/basic.js"></script>
    <script language="javascript" src="/js/xmlHttp.js"></script>
    <script language="javascript" src="/js/dbgrid.js"></script>
    <script language="javascript" src="/js/dbutil.js"></script>
    <script language="javascript" src="archiveSumQry.js"></script>

</head>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">

<form id="queryForm" name="queryForm">
    <fieldset style="padding: 15px">
        <legend style="margin-bottom: 10px">��ѯ����</legend>
        <table width="100%" cellspacing="0" border="0">

            <input type="hidden" id="deptid" value="<%=omgr.getOperator().getDeptid()%>"/>
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <input type="hidden" id="tab1Sql" name="tab1Sql" value="<%=tab1Sql%>"/>
            <input type="hidden" id="tab2Sql" name="tab2Sql" value="<%=tab2Sql%>"/>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">��ʼ����</td>
                <td width="30%" class="data_input"><input type="text" id="STARTDATE" name="STARTDATE"
                                                          value="<%=startDate%>"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% ">
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">��ֹ����</td>
                <td width="35%" class="data_input"><input type="text" id="ENDDATE" name="ENDDATE"
                                                          value="<%=endDate%>"
                                                          onClick="WdatePicker()"
                                                          fieldType="date"
                                                          style="width:90% " >
                </td>
            </tr>

        </table>
    </fieldset>

    <fieldset>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td align="center">
                    <!--���ӣ��޸�-->
                    <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="����" onclick="onSearch();">
                </td>
            </tr>
        </table>
    </fieldset>
</form>

<fieldset>
    <LEGEND>Ӫ��������ͳ��</LEGEND>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
<fieldset style="margin-top: 15px">
    <LEGEND>�����������ͳ��</LEGEND>
    <table width="100%">
        <tr>
            <td><%=dbGridDetail.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGridDetail.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>

</body>
</html>
