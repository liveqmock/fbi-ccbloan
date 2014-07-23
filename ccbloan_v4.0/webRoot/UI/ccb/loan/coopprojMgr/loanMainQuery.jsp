<!--
/*********************************************************************
* ��������: ���֤����������ѯ
* �� ��:
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

    <script language="javascript" src="loanMainQuery.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    //    String proj_nbxh = "";
//    if (request.getParameter("proj_nbxh") != null) {
//        proj_nbxh = request.getParameter("proj_nbxh");
//    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanRegistedTab");
    dbGrid.setGridType("edit");

    // �����ӣ��Ե�Ѻ��Ϣ��Ϊ����
    String sql = "select " +
            "       (select deptname from ptdept where deptid=a.bankid)as bankid ," +
            "       c.corpname," +
            "       c.proj_name," +
            "       a.cust_name," +
            "       a.rt_orig_loan_amt," +
            "       (select code_desc from ln_odsb_code_desc where code_type_id='053' and code_id=a.LN_TYP) as ln_typ_name," +
            "       c.assuamtpercent," +
            "       (a.rt_orig_loan_amt * c.assuamtpercent/100) as assuamttemp," +
            "       c.assuamt," +
            "       c.bankflag," +
            "       a.proj_no," +
            "       b.mortid," +
            "       a.loanid," +
            "       a.nbxh," +
            "       c.proj_nbxh" +
            "  from ln_loanapply a, ln_mortinfo b, ln_coopproj c" +
            " where a.loanid = b.loanid" +
            "   and a.proj_no = c.proj_no" +
            "   and a.loanstate = '1' " +
            "   and (b.mortstatus = '10' or b.mortstatus = '20' or b.mortstatus = '20A')" +

            //20100511 zhan
            " and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) " +
            "  ";

    //20100511 zhanrui
    sql = "select ta.bankid," +
            "       tb.corpname," +
            "       tb.proj_name," +
            "       ta.loanamt/10000," +
            "       tb.assuamtpercent," +
            "       ta.amttmp/10000," +
            "       tb.assuamt," +
            "       0 as assuacctbal," +
            "       0 as oweassu " +
            "  from (select bankid,proj_no,sum(rt_orig_loan_amt) as loanamt, sum(assuamttemp) as amttmp from (" + sql;

    dbGrid.setfieldSQL(sql);

//    dbGrid.setField("��������", "dropdown", "10", "MORTECENTERCD", "true", "MORTECENTERCD");
    dbGrid.setField("����", "center", "10", "bankid", "true", "0");
    dbGrid.setField("����������", "text", "25", "corpname", "true", "0");
    dbGrid.setField("������Ŀ", "text", "25", "proj_name", "true", "0");
    dbGrid.setField("������(��)", "money", "15", "loanamt", "true", "0");
    dbGrid.setField("��֤�����", "money", "15", "assuamtpercent", "true", "0");
    dbGrid.setField("Ӧ����֤��(��)", "money", "15", "amttmp", "true", "0");
    dbGrid.setField("��֤���˺�", "center", "20", "assuamt", "true", "0");
    dbGrid.setField("��֤���˻����(��)", "money", "15", "assuacctbal", "true", "0");
    dbGrid.setField("Ƿ����֤��(��)", "money", "15", "oweassu", "true", "0");

    dbGrid.setWhereStr(" )group by bankid,proj_no  order by bankid,proj_no  ) ta, ln_coopproj tb where ta.proj_no = tb.proj_no");
//    dbGrid.setWhereStr(" and a.bankid in(select deptid from ptdept start with deptid='"+omgr.getOperator().getDeptid()+"' connect by prior deptid=parentdeptid) order by a.bankid, c.proj_no, a.loanid ");

    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
//    dbGrid.setbuttons("����Excel=excel,�鿴����=loanQuery,�鿴��Ѻ=query,�鿴��Ŀ=projQuery,moveFirst,prevPage,nextPage,moveLast");
    dbGrid.setbuttons("����Excel=excel,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onload="body_resize()" onresize="body_resize();" class="Bodydefault">

<fieldset>
    <legend>
        ��ѯ����
    </legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="mortID" name="mortID" value="">
            <input type="hidden" id="loanID" name="loanID" value="">
            <!-- 20110701���Ӻ�������š����������ơ�������Ŀ��š�������Ŀ����-->
            <tr height="20">
                <td width="20%" class="lbl_right_padding"> ���������</td>
                <td width="30%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="corp_id" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ����������</td>
                <td width="30%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="corp_name" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" class="lbl_right_padding"> ������Ŀ���</td>
                <td width="30%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_no" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ������Ŀ����</td>
                <td width="30%" align="right" nowrap="nowrap"
                    class="data_input">
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
            </tr>
            <tr height="20">
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        out.print(zs);
                    %>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ſʽ</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("releasecondcd", "releasecondcd", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("isNull","false");
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

            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��֤������Ƿ�Ϊ��</td>
                <td width="30%" class="data_input"><%
                    zs = new ZtSelect("booltype", "booltype", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                </td>

                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="30%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("ln_typ", "", "");
                        zs.setSqlString("select code_id,code_desc from ln_odsb_code_desc where code_type_id='053' order by code_id");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>

                <%--

                                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                                    ���������
                                </td>
                                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                                    <input type="text" id="cust_name" name="cust_name" style="width:90%"
                                           class="ajax-suggestion url-getPull.jsp">
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

                --%>


                <td align="center" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="����"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
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
