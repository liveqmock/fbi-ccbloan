<!--
/*********************************************************************
* ��������: ϵͳ��־
* �� ��: leonwoo
* ��������: 2010/01/16
* �� �� ��:
* �޸�����:
* �� Ȩ: ��˾
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="promotionList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
//    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();
//    String

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("promotionTab");
    dbGrid.setGridType("edit");

    //ֻ�ܱ༭��Щδ������Ѻ�Ǽǵ�
    String sql = "select t.PROMCUST_NO,t.cust_name,CUST_ID," +
            " (select code_desc from ln_odsb_code_desc where code_type_id='053' and code_id = t.ln_typ) as ln_typ," +
            " t.rt_orig_loan_amt,RT_TERM_INCR,(select deptname from ptdept where deptid=t.bankid)as deptname," +
            " t.prommgr_name,status,CUST_PHONE,OPERDATE " +
            " from ln_promotioncustomers t where status=0 " +
            " and t.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("�ͻ����", "text", "2", "PROMCUST_NO", "false", "-1");
    dbGrid.setField("�ͻ�����", "center", "8", "cust_name", "true", "0");
    dbGrid.setField("֤������", "center", "14", "CUST_ID", "true", "0");
    dbGrid.setField("��������", "center", "12", "ln_typ", "true", "0");
    dbGrid.setField("������", "money", "10", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("��������", "center", "8", "RT_TERM_INCR", "true", "0");
    dbGrid.setField("Ӫ������", "center", "10", "deptname", "true", "0");
    dbGrid.setField("Ӫ������", "center", "8", "prommgr_name", "true", "0");;
    dbGrid.setField("���״̬", "dropdown", "8", "status", "true", "RELEASECHECK");
    dbGrid.setField("�ͻ��绰", "text", "9", "CUST_PHONE", "true", "0");
    dbGrid.setField("�ύʱ��", "text", "14", "OPERDATE", "true", "0");
    dbGrid.setWhereStr(" order by OPERDATE desc");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,���=appendRecord,�޸�=editRecord,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <tr height="20">
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ���������
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                </td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">����</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("bankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td align="center" nowrap="nowrap"><input name="cbRetrieve" type="button" class="buttonGrooveDisable"
                                                          id="button" onClick="cbRetrieve_Click(document.queryForm)"
                                                          value="����">
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
</body>
</html>
