<!--
/*********************************************************************
* ��������: ��Ѻ����ǰ��Ϣ����;���п������ɱ���Ѻ�Ǽ�
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

    <script language="javascript" src="otherBankHeaderCanMortList.js"></script>
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
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanRegistedTab");
    dbGrid.setGridType("edit");

    String sql = "select a.nbxh,"
            //+ "(select enuitemlabel from ptenudetail where enutype='MORTECENTERCD' and enuitemvalue=b.MORTECENTERCD)as MORTECENTERCD,"
            + "b.mortecentercd,"
            + " (select deptname from ptdept where deptid=a.bankid) as deptname," +
            "a.loanid,a.cust_name,a.RT_ORIG_LOAN_AMT,b.mortid,b.mortdate," +
            "(select enuitemlabel from ptenudetail where enutype='SENDFLAG' and enuitemvalue=b.SENDFLAG) as SENDFLAG," +
            "b.RPTMORTDATE, " +
            "c.PROJ_NAME," +
            "(select enuitemlabel from ptenudetail where enutype='BANKFLAG' and enuitemvalue=c.BANKFLAG) as BANKFLAG, " +
            "  b.recVersion from ln_loanapply a,ln_mortinfo b,ln_coopproj c where  "
            + " a.loanid = b.loanid  and (b.SENDFLAG <> '1' and b.SENDFLAG <> '0' and  b.SENDFLAG is not null) "
            + " and a.proj_no=c.proj_no  "
            + " ";
    dbGrid.setfieldSQL(sql);

    dbGrid.setField("nbxh", "text", "0", "nbxh", "false", "0");
    dbGrid.setField("��������", "dropdown", "8", "MORTECENTERCD", "true", "MORTECENTERCD");
    //dbGrid.setField("��������", "center", "5", "MORTECENTERCD", "true", "0");
    dbGrid.setField("����", "center", "8", "deptname", "true", "0");
    dbGrid.setField("�����������", "text", "12", "loanid", "true", "0");
    dbGrid.setField("���������", "center", "8", "cust_name", "true", "0");
    dbGrid.setField("������", "money", "8", "RT_ORIG_LOAN_AMT", "true", "0");
    dbGrid.setField("��Ѻ���", "text", "8", "mortid", "true", "-1");
    dbGrid.setField("��Ѻ��������", "center", "8", "mortdate", "true", "0");
    dbGrid.setField("���ɱ�/�ɱ�", "center", "8", "SENDFLAG", "true", "0");
    dbGrid.setField("�ɱ���Ѻ����", "text", "8", "RPTMORTDATE", "true", "0");
    dbGrid.setField("��Ŀ����", "text", "12", "PROJ_NAME", "true", "0");
    dbGrid.setField("����������", "center", "5", "bankflag", "true", "0");
    dbGrid.setField("�汾��", "text", "0", "recVersion", "false", "0");
    dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid)  order by b.mortecentercd, a.bankid, b.mortid ");
//    dbGrid.setWhereStr(" order by b.mortecentercd, a.bankid, b.mortid ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setCheck(true);
    dbGrid.setbuttons("����Excel=excel,�鿴����=loanQuery,�鿴��Ѻ=query,�ɱ��Ǽ�ȷ��=editRecord,����ȷ��=BatchEditRecord,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <tr>
                <td width="15%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ������Ŀ���
                </td>
                <td width="50%" align="right" nowrap="nowrap" class="data_input" colspan="3">
                    <div><input type="text" id="proj_no" name="proj_no"    style="width:34.2% "
                                onClick="queryCoopProjNo()"  readonly="readonly"  >
                    </div>
                </td>
                <td width="15%" align="center" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="cbRetrieve_Click(document.queryForm)" onMouseOver="button_onmouseover()"
                           onMouseOut="button_onmouseout()" value="����">
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">����������</td>
                <td width="25%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("BANKFLAG", "BANKFLAG", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">����</td>
                <td width="25%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addOption("", "");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td align="center" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="����"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
            <tr>
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ���������
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                    <%--class="ajax-suggestion url-getPull.jsp">--%>
                </td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("mortecentercd", "mortecentercd", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td align="center" nowrap="nowrap">

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
