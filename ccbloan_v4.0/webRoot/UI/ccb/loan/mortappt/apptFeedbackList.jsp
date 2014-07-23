<!--
/*********************************************************************
* ��������: ��ѺԤԼ������
* ��������: 2013/05/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="apptFeedbackList.js"></script>
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

    //�ж��Ƿ��������������������ġ����������ġ��ĸ��԰��У�
    String ploanProxyDept = "0";
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();
    try {
        RecordSet chrs = dc.executeQuery("select count(*) as cnt from LN_MORTCENTER_APPT where deptid='" + deptId + "'");
        while (chrs != null && chrs.next()) {
            if (chrs.getInt(0) > 0) {
                ploanProxyDept = "1"; //�������ġ����������ġ��ĸ��԰���
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("���ݿ⴦�����" + e.getMessage());
        return;
    } finally {
        cm.release();
    }

    boolean isBranch = true;
    String normalBranchFlag = "1"; //��֧ͨ�У��Ƿ��С��������ġ����������ġ��ĸ��԰��У�
    if ("371981610".equals(deptId)
            || "371981620".equals(deptId)
            || "371980000".equals(deptId)) {
        isBranch = false;  //���С��������ġ�����������
    }

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("mainTab");
    dbGrid.setGridType("edit");

    String sql = "select a.nbxh, b.mortecentercd, "
            + "     (select deptname from ptdept where deptid=a.bankid) as deptname,"
            + "     a.loanid,a.cust_name, "
            + "     (select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = a.ln_typ) as ln_typ,"
            + "     a.RT_ORIG_LOAN_AMT, b.mortid,"
            + "     a.PROJ_NAME_ABBR, b.mortstatus, b.apptstatus,"
            + "     b.recVersion, b.FLOWSN, b.APPT_BIZ_CODE, (b.APPT_HDL_DATE||decode(b.APPT_HDL_TIME,'01','����','����')) APPT_HDL_DATE_TMP,  b.RELEASECONDCD   "
            + " from (select t1.*, case t1.proj_no when null then  '' else (select proj_name_abbr from ln_coopproj where proj_no = t1.proj_no) end as proj_name_abbr from ln_loanapply t1) a,ln_mortinfo b  "
            + "  where a.loanid = b.loanid "
            + "   and (b.apptstatus = '20' or b.apptstatus = '50')  "     //��ȷ�ϻ�������Ѻ
            + "   and b.APPT_VALID_FLAG = '1' and APPT_OVER_FLAG = '0'" //δ��ɵ���ЧԤԼ
            + "";
/*
    String sql = "select a.nbxh, b.mortecentercd, "
            + "     (select deptname from ptdept where deptid=a.bankid) as deptname,"
            + "     a.loanid,a.cust_name, "
            + "     (select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = a.ln_typ) as ln_typ,"
            + "     a.RT_ORIG_LOAN_AMT, b.mortid,"
            + "     c.PROJ_NAME_ABBR, b.mortstatus, b.apptstatus,"
            + "     b.recVersion, b.FLOWSN, b.APPT_BIZ_CODE, (b.APPT_HDL_DATE||decode(b.APPT_HDL_TIME,'01','����','����')) APPT_HDL_DATE_TMP  "
            + " from ln_loanapply a,ln_mortinfo b,ln_coopproj c  "
            + "  where a.loanid = b.loanid "
            + "   and a.proj_no = c.proj_no "
            + "   and (b.apptstatus = '20' or b.apptstatus = '50')  "     //��ȷ�ϻ�������Ѻ
            + "   and b.APPT_VALID_FLAG = '1' and APPT_OVER_FLAG = '0'" //δ��ɵ���ЧԤԼ
            + "";
*/
    if (isBranch) {
        sql += "   and  b.RELEASECONDCD in ('04','05','06')  ";  //�����ſ�
    } else {
        sql += "   and  b.RELEASECONDCD not in ('04','05','06')  ";
    }
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
    dbGrid.setField("ԤԼ״̬", "dropdown", "8", "APPTSTATUS", "true", "APPTSTATUS");
    // ���ֶ����������·�ֹ��������ؼ��ֶΣ�����ɾ������˳��Ź̶���11
    dbGrid.setField("�汾��", "text", "4", "recVersion", "false", "0");
    dbGrid.setField("ҵ����ˮ��", "center", "12", "FLOWSN", "false", "0");
    dbGrid.setField("ҵ������", "dropdown", "8", "APPT_BIZ_CODE", "true", "APPTBIZCODE");
    dbGrid.setField("ԤԼʱ��", "center", "12", "APPT_HDL_DATE_TMP", "true", "0");
    dbGrid.setField("�ſʽ", "dropdown", "6", "RELEASECONDCD", "true", "RELEASECONDCD");

    //dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) order by b.appt_date_apply desc, b.appt_time_apply desc, b.mortecentercd, a.bankid, b.mortid ");
    if ("1".equals(ploanProxyDept)) {
        dbGrid.setWhereStr(" and b.mortecentercd in (select mortecentercd from LN_MORTCENTER_APPT where deptid='" + deptId + "' and typeflag='0') order by b.appt_date_apply desc, b.appt_time_apply desc, b.mortecentercd, a.bankid, b.mortid ");
    } else {
        dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='" + deptId + "' connect by prior deptid=parentdeptid) order by b.appt_date_apply desc, b.appt_time_apply desc, b.mortecentercd, a.bankid, b.mortid ");
    }
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    dbGrid.setbuttons("�鿴����=loanQuery,�鿴��Ѻ=query,����������=batchEdit,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <input type="hidden" id="ploanProxyDept" name="ploanProxyDept"  value="<%=ploanProxyDept%>"/>
            <tr height="20">
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ���������
                </td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs;
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                            zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from LN_MORTCENTER_APPT where deptid='" + deptId + "' and typeflag='0'  order by mortecentercd");
                        }else{
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "MORTECENTERCD");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("bankid", "", "371980000");
                            zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                    + " start with deptid = '" + "371980000" + "'"
                                    + " connect by prior deptid = parentdeptid");
                        }else{
                            zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                            zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                    + " start with deptid = '" + deptId + "'"
                                    + " connect by prior deptid = parentdeptid");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
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


                <td align="center" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable"  type="reset" value="����"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
            <tr height="20">
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ��Ŀ���
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="proj_name_abbr" name="proj_name_abbr" style="width:90%">
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
