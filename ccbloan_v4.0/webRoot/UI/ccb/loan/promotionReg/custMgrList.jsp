<%--
  Created by IntelliJ IDEA.
  User: haiyuhuang
  Date: 11-7-29
  Time: ����4:41
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="custMgrList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String operid = omgr.getOperatorId();

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("promotionTab");
    dbGrid.setGridType("edit");

    //ֻ�ܱ༭��Щδ������Ѻ�Ǽǵ�
    String sql = "select t.PROMCUST_NO,t.cust_name,t.CUST_ID," +
            " (select code_desc from ln_odsb_code_desc where code_type_id='053' and code_id = t.ln_typ) as ln_typ," +
            " t.rt_orig_loan_amt,RT_TERM_INCR,(select deptname from ptdept where deptid=t.bankid)as deptname," +
            " t.prommgr_name," +
            " (select deptname from ptdept where deptid=t.cust_bankid)as custdeptname," +
            " (select opername from ptoper where operid=t.custmgr_id) as custmgr_id," +
            " status,CUST_PHONE,remark,OPERDATE" +
            " from ln_promotioncustomers t where status in (0,1,2,3) " +
            " and t.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("�ͻ����","text","2","PROMCUST_NO","false","-1");
    dbGrid.setField("�ͻ�����", "center", "8", "taskid", "true", "0");
    dbGrid.setField("֤������", "center", "14", "CUST_ID", "true", "0");
    dbGrid.setField("��������", "center", "12", "ln_typ", "true", "0");
    dbGrid.setField("������", "money", "12", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("��������", "center", "8", "RT_TERM_INCR", "true", "0");
    dbGrid.setField("Ӫ������", "center", "12", "deptname", "true", "0");
    dbGrid.setField("Ӫ������", "center", "8", "prommgr_name", "true", "0");
    dbGrid.setField("��Ӫ����", "center", "12", "custdeptname", "true", "0");
    dbGrid.setField("�ͻ�����", "center", "8", "custmgr_id", "true", "0");
    dbGrid.setField("���״̬", "dropdown", "8", "status", "true", "RELEASECHECK");
    dbGrid.setField("�ͻ��绰","text","10","CUST_PHONE","true","0");
    dbGrid.setField("��ע", "text", "14", "remark", "true", "0");
    dbGrid.setField("�ύʱ��", "text", "14", "OPERDATE", "true", "0");
    dbGrid.setWhereStr(" and status='0' order by OPERDATE desc ");
//    dbGrid.setCheck(true);
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,���=editRecord,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <input type="hidden" id="hidoperid" value="<%=operid%>" />
            <tr height="20">
                <td width="10%" align="right" nowrap="nowrap" class="lbl_right_padding">
                    ���������
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="cust_name" name="cust_name" style="width:90%">
                    <%--class="ajax-suggestion url-getPull.jsp">--%>
                </td>

                <td width="10%" nowrap="nowrap" class="lbl_right_padding">����</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("custbankid", "", omgr.getOperator().getDeptid());
                        zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %>
                </td>
                <td width="10%" nowrap="nowrap" class="lbl_right_padding">���״̬</td>
                <td width="20%" nowrap="nowrap" class="data_input">
                    <%
                        zs = new ZtSelect("RELEASECHECK", "RELEASECHECK", "0");
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
