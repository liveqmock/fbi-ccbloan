<!--
/*********************************************************************
* ��������: �������
* �� ��: leonwoo
* ��������: 2010/01/16
* �� �� ��:
* �޸�����:
* �� Ȩ: ��˾
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="acctInfo.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
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
    String menuAction = "";
    if (request.getParameter(CcbLoanConst.MENU_ACTION) != null) {
        menuAction = request.getParameter(CcbLoanConst.MENU_ACTION);
    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

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

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("acctTab");
    dbGrid.setGridType("edit");
    String commSql = "select a.acct_id, ( select deptname from ptdept where deptid=b.bankid )as deptname, " +
            " a.loanid, b.cust_name, " +
            " ( select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = b.ln_typ ) ln_typ, " +
            " b.rt_orig_loan_amt,( select proj_name from ln_coopproj where proj_no=b.proj_no ) proj_name," +
            " ( select enuitemlabel from PTENUDETAIL where enutype = 'APPTTYPE' and enuitemvalue = a.appt_type) appt_type," +
            " a.acct_name,a.acct_no,a.acct_bank,a.acct_amt,a.pay_date,a.operid,a.recversion " +
            " from ln_acctinfo a " +
            " inner join ln_loanapply b on a.loanid = b.loanid  " +
            " where 1 =1 "+
            " and a.deptid in (" +
            " select deptid from ptdept " +
            " start with deptid = '" + omgr.getOperator().getDeptid() +"'" +
            " connect by prior deptid = parentdeptid" +
            " )";
//    if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
//        commSql += " and not exists (select 1 from ln_mortinfo b where b.loanid=a.loanid)  ";
//    }
//    //commSql += " and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) ";
//    commSql += "  and exists (select  1 from (select deptid from ptdept start with deptid = '" + omgr.getOperator().getDeptid() + "' connect by prior deptid = parentdeptid)  where a.bankid = deptid) ";

    //ֻ�ܱ༭��Щδ������Ѻ�Ǽǵ�,��ѯ�����е�
    /*
        if (!menuAction.equals(CcbLoanConst.MENU_SELECT)) {
            commSql += " and a.operdate=to_char(sysdate,'yyyy-MM-dd') ";
        }
    */
    dbGrid.setfieldSQL(commSql);
    dbGrid.setField("�˻����", "center", "5", "acct_id", "false", "0");
    dbGrid.setField("������", "center", "5", "deptname", "true", "0");
    dbGrid.setField("�����������", "text", "8", "loanid", "true", "0");
    dbGrid.setField("���������", "center", "5", "cust_name", "true", "0");
//    dbGrid.setField("��Ѻ������", "center", "5", "apptName", "true", "0");
    dbGrid.setField("��������", "center", "5", "ln_typ", "true", "0");
    dbGrid.setField("������", "money", "6", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("��Ŀ���", "center", "10", "proj_name", "true", "0");
    dbGrid.setField("��Ѻ����", "center", "6", "appt_type", "true", "0");
    dbGrid.setField("�˻�����", "center", "5", "acct_name", "true", "0");
    dbGrid.setField("�տ��˺�", "center", "10", "acct_no", "true", "0");
    dbGrid.setField("��������", "center", "10", "acct_bank", "true", "0");
    dbGrid.setField("��Ѻ�ѽ��", "center", "4", "acct_amt", "true", "0");
    dbGrid.setField("�ɽ�����", "center", "6", "pay_date", "true", "0");
    dbGrid.setField("������", "center", "5", "operid", "true", "0");
    dbGrid.setField("�汾��", "text", "4", "recVersion", "false", "0");

    String whereStr = " and a.print_flag = '0' ";
    whereStr = whereStr +  " order by a.loanid ";
    dbGrid.setWhereStr(whereStr);
    dbGrid.setpagesize(15);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    if (menuAction.equals(CcbLoanConst.MENU_SELECT)) {
        dbGrid.setbuttons("�鿴����=query,moveFirst,prevPage,nextPage,moveLast");
    } else {
        dbGrid.setbuttons("�ɷѱ���=batchEdit,֪ͨ���ӡ=filePrint,���ܵ���=allExport,moveFirst,prevPage,nextPage,moveLast");
    }
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- �����ֶ� -->
            <input type="hidden" id="ploanProxyDept" name="ploanProxyDept"  value="<%=ploanProxyDept%>"/>
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <input type="hidden" id="acctid" name="acctid"/>
            <tr height="20">
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs;
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
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> ���������</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" size="50" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> ��Ѻ������</td>
                <td width="15%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="appt_name" name="appt_name" size="50" style="width:90% ">
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="15%" nowrap="nowrap" class="data_input">
                    <%
                        if ("1".equals(ploanProxyDept)) {
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                            zs.setSqlString("select mortecentercd, (select t.enuitemlabel from PTENUDETAIL t where t.enutype = 'MORTECENTERCD' and t.enuitemvalue = mortecentercd) from LN_MORTCENTER_APPT where deptid='" + deptId + "' and typeflag='0' order by mortecentercd");
                        }else{
                            zs = new ZtSelect("mortecentercd", "mortecentercd", "MORTECENTERCD");
                        }
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td align="center" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable"
                                                          id="button" onClick="cbRetrieve_Click(document.queryForm)"
                                                          value="����">
                </td>
            </tr>
            <tr>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> ������Ŀ���</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding"> �Ƿ��Ѿ��ɷѱ���</td>
                <td width="15%" align="right" nowrap="nowrap"
                    class="data_input">
                    <%
                        zs = new ZtSelect("pay_flag", "BOOLTYPE", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("isNull","false");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">������ʼ����</td>
                <td width="15%" nowrap="nowrap" class="data_input"><input type="text" id="PAY_DATE1"
                                                                          name="PAY_DATE1" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">������ֹ����</td>
                <td width="15%" nowrap="nowrap" class="data_input"><input type="text" id="PAY_DATE2"
                                                                          name="PAY_DATE2" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
                <td align="center" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="����">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> ������Ϣ</legend>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> ����</LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
<div id="search-result-suggestions">
    <div id="search-results"></div>
</div>
<script type="text/javascript">
    // Initialize the input highlight script
    //initInputHighlightScript();
</script>
</body>
</html>
