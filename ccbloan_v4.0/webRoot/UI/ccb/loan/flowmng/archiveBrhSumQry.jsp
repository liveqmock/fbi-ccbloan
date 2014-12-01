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
    String infoSql = "select (select deptname from ptdept where deptid = cust_bankid) as custbank_name, " +
            " tbl.* " +
            " from (select (select deptid from ptdept where fillstr10 = '3' and rownum = 1 " +
            " start with deptid = t.bankid " +
            " connect by prior parentdeptid = deptid) as cust_bankid, " +
            " (select deptname from ptdept where deptid = bankid) as bank_name, " +
            " bankid, " +
            " prommgr_id, " +
            " (select prommgr_name " +
            " from ln_prommgrinfo " +
            " where prommgr_id = t.prommgr_id) as prommgr_name, " +
            " total, succ,fail, RTrim(To_Char(succ / total * 100, 'FM990.99'), '.') || '%' as rate " +
            " from (select bankid, " +
            "                       prommgr_id, " +
            "                       count(*) as total, " +
            "                       count(case flowstat " +
            "                               when '10' then " +
            "                                1 " +
            "                               else " +
            "                                null " +
            "                             end) as succ, " +
            "                       count(case flowstat " +
            "                               when '20' then " +
            "                                1 " +
            "                               else " +
            "                                null " +
            "                             end) as fail " +
            "                  from (select a.operdate, " +
            "                               a.flowsn, " +
            "                               c.bankid, " +
            "                               c.custmgr_id as prommgr_id, " +
            "                               a.flowstat " +
            "                          from ln_archive_flow a, " +
            "                               ptoperrole      b, " +
            "                               ln_archive_info c " +
            "                         where a.operid = b.operid(+) " +
            "                           and b.roleid = 'WF0001' " +
            "                           and exists " +
            "                         (select 1 " +
            "                                  from PTENUDETAIL t " +
            "                                 where enutype = 'ARCHIVE_SUM_RPT_SIN' " +
            "                                   and t.enuitemvalue = a.operid) " +
            "                           and a.flowsn = c.flowsn " +
            "                           and a.operdate >= '{startDate}' " +
            "                           and a.operdate <= '{endDate}'" +
            " and c.bankid in (select deptid from ptdept where fillstr20='3')) " +
            "                 group by bankid, prommgr_id) t " +
            "       ) tbl order by cust_bankid, bankid, rate desc ";

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
    String detailSql = "select cust_bankid, " +
            "       (select deptname from ptdept where deptid = cust_bankid) as bank_name, " +
            "       total, " +
            "       succ, " +
            "       fail, " +
            "       RTrim(To_Char(succ / total * 100,'FM990.99'),'.') || '%' as rate " +
            "  from (select cust_bankid, " +
            "               count(*) as total, " +
            "               count(case flowstat " +
            "                       when '10' then " +
            "                        1 " +
            "                       else " +
            "                        null " +
            "                                 end) as succ,  +" +
            "                           count(case flowstat  +" +
            "                                   when '20' then  +" +
            "                                    1  +" +
            "                                   else  +" +
            "                                    null  +" +
            "                                 end) as fail  +" +
            "             from (select a.operdate,  +" +
            "                                   a.flowsn,  +" +
            "                                   c.bankid,  +" +
            "              (select deptid  from ptdept where fillstr10 = '3' and rownum = 1 " +
            " start with deptid = c.bankid connect by prior parentdeptid = deptid) as cust_bankid, " +
            "                       c.custmgr_id as prommgr_id, " +
            "                       a.flowstat " +
            "                  from ln_archive_flow a, ptoperrole b, ln_archive_info c " +
            "                 where a.operid = b.operid(+) " +
            "                   and b.roleid = 'WF0001' " +
            "                   and exists (select 1 from PTENUDETAIL t where enutype='ARCHIVE_SUM_RPT_SIN' and t.enuitemvalue=a.operid) " +
            "                   and a.flowsn = c.flowsn " +
            "                   and a.operdate >= '{startDate}' " +
            "                   and a.operdate <= '{endDate}'" +
            " and c.bankid in (select deptid from ptdept where fillstr20='3')) " +
            "         group by cust_bankid) t " +
            " order by  rate desc ";
    System.out.println(detailSql);

    String tab2Sql= detailSql;
    detailSql = detailSql.replace("{startDate}", startDate);
    detailSql = detailSql.replace("{endDate}", endDate);

    dbGridDetail.setfieldSQL(detailSql);

    dbGridDetail.setField("��Ӫ����ID", "center", "8", "cust_bankid", "true", "0");
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
    <script language="javascript" src="archiveBrhSumQry.js"></script>

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
