<!--
/*********************************************************************
* ��������: ��Ѻ����ԤԼ����
* ��������: 2013/05/22
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>

    <script language="javascript" src="apptApplyParamList.js"></script>
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

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("mainTab");
    dbGrid.setGridType("edit");

    String sql = "select a.ln_typ, a.mortecentercd,a.limitdate "
            + " from ln_mortlimit a  "
            + "  where a.ln_typ = '009' "
            + " ";
/*
    String sql = "select a.nbxh, b.mortecentercd, "
            + "     (select deptname from ptdept where deptid=a.bankid) as deptname,"
            + "     a.loanid,a.cust_name, "
            + "     (select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = a.ln_typ) as ln_typ,"
            + "     a.RT_ORIG_LOAN_AMT, b.mortid,"
            + "     c.PROJ_NAME_ABBR, "
            + "     b.mortstatus, b.apptstatus,"
            + "     b.recVersion, b.FLOWSN "
            + " from ln_loanapply a,ln_mortinfo b,ln_coopproj c  "
            + "  where a.loanid = b.loanid "
            + "   and a.proj_no = c.proj_no "
            + "   and (b.apptstatus is null or b.apptstatus = '01' or b.apptstatus = '02' or  b.apptstatus = '40')  "
            + " ";
*/
    dbGrid.setfieldSQL(sql);

    dbGrid.setField("ln_typ", "center", "0", "ln_typ", "false", "0");
    dbGrid.setField("��������", "dropdown", "6", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("��������", "center", "10", "limitdate", "true", "0");

    dbGrid.setpagesize(30);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    dbGrid.setbuttons("�����޸�=batchEdit,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ����ʹ�� -->
            <input type="hidden" id="apptbizcode_tmp" name="apptbizcode_tmp" value=""/>
            <input type="hidden" id="user_deptid" name="user_deptid"  value="<%=deptId%>"/>
            <input type="hidden" id="ploanProxyDept" name="ploanProxyDept"  value="<%=ploanProxyDept%>"/>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend>
              ������Ϣ
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
