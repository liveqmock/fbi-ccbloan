<!--
/*********************************************************************
* ��������: �����������ϲ��� ����
* �� ��: zr
* ��������: 2013/03/10
* �� �� ��:
* �޸�����:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.*" %>
<%
    // �û�����
    PTOPER oper = null;
    // �ͻ�����ID
    String custmgrId = "";

    // ��ʼ��ҳ��
    LNARCHIVEINFO bean = new LNARCHIVEINFO();
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

    //List
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("loanTab");
    dbGrid.setGridType("edit");
    String commSql = "select a.flowsn, a.cust_name, a.rt_orig_loan_amt, a.rt_term_incr, "
            + " (select deptname from ptdept where deptid=a.bankid) as bankname, "
            + " (select prommgr_name from ln_prommgrinfo where prommgr_id=a.custmgr_id) as custmgr_name,"
            + " (select deptname from ptdept where deptid=a.cust_bankid) as cust_bankname, "
            + " (select opername from ptoper where operid=a.realcustmgr_id) as realcustmgr_name,"
            + " a.operdate,a.bankid,a.custmgr_id,a.cust_bankid, a.realcustmgr_id, b.flowstat as af_flowstat, b.remark as af_remark, "
            + " a.recversion, b.pkid as af_pkid, b.recversion as af_recversion " +
            " from ln_archive_info a  " +
            "  left join ln_archive_flow b on a.flowsn = b.flowsn and a.operid = b.operid " +
            " where 1=1 " +
            " and b.operdate||b.opertime = (select max(operdate||opertime) from ln_archive_flow  where flowsn = a.flowsn and operid = a.operid) " +
            " and not exists (select 1 from ln_archive_flow where flowsn = a.flowsn and operid <> a.operid) " +
            " and a.operid = '" + omgr.getOperatorId() + "'";

    dbGrid.setfieldSQL(commSql);

    dbGrid.setField("ҵ����ˮ��", "center", "8", "flowsn", "true", "0");
    dbGrid.setField("�����", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("������", "money", "6", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("��������", "center", "5", "rt_term_incr", "true", "0");
    dbGrid.setField("�������", "center", "5", "bankname", "true", "0");
    dbGrid.setField("Ӫ������", "center", "5", "custmgr_name", "true", "0");
    dbGrid.setField("��Ӫ����", "center", "5", "cust_bankname", "true", "0");
    dbGrid.setField("�ͻ�����", "center", "5", "realcustmgr_name", "true", "0");
    dbGrid.setField("��������", "center", "5", "operdate", "true", "0");
    dbGrid.setField("�������ID", "center", "5", "bankid", "false", "0");
    dbGrid.setField("Ӫ������ID", "center", "5", "custmgr_id", "false", "0");
    dbGrid.setField("��Ӫ����ID", "center", "5", "cust_bankid", "false", "0");
    dbGrid.setField("�ͻ�����ID", "center", "5", "realcustmgr_id", "false", "0");
    dbGrid.setField("����״̬", "dropdown", "5", "af_flowstat", "true", "ARCHIVEFLOW");
    dbGrid.setField("���̱�ע", "center", "5", "af_remark", "true", "0");
    dbGrid.setField("��¼�汾", "center", "5", "recversion", "false", "0");
    dbGrid.setField("��������", "center", "5", "af_pkid", "false", "0");
    dbGrid.setField("���̰汾", "center", "5", "af_recversion", "false", "0");

    dbGrid.setWhereStr(" order by b.operdate desc, b.opertime desc ");
    dbGrid.setpagesize(10);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("�༭��������=editRecord,ɾ����������=deleteRecord,moveFirst,prevPage,nextPage,moveLast");
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>������Ϣ</title>

    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="flowInfoList.js"></script>

</head>
<%--<body onload="formInit();" class="Bodydefault">--%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">

<form id="queryForm" name="queryForm">
    <fieldset style="padding: 15px">
        <legend style="margin-bottom: 10px">���������������</legend>
        <table width="100%" cellspacing="0" border="0">

            <input type="hidden" id="recversion" value=""/>
            <input type="hidden" id="af_recversion" value=""/>
            <input type="hidden" id="af_pkid" value=""/>
            <input type="hidden" id="deptid" value="<%=omgr.getOperator().getDeptid()%>"/>
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">ҵ����ˮ��</td>
                <td width="30%" class="data_input"><input type="text" id="FLOWSN" name="FLOWSN" value=""
                                                          textLength="100"
                                                          style="width:90% " isNull="false"><span
                        class="red_star">*</span>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">���������</td>
                <td width="35%" class="data_input"><input type="text" id="CUST_NAME" name="CUST_NAME" style="width:90%"
                                                          textLength="40" isNull="false"><span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">������</td>
                <td width="35%" class="data_input"><input type="text" id="RT_ORIG_LOAN_AMT" name="RT_ORIG_LOAN_AMT"
                                                          value=""
                                                          onblur="Txn_GotFocus(this);" style="width:90%" intLength="18"
                                                          floatLength="2"></td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="35%" class="data_input"><input type="text" id="RT_TERM_INCR" name="RT_TERM_INCR" value=""
                                                          style="width:90%" intLength="12"></td>

            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ӫ����</td>
                <td width="35%" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("CUST_BANKID", "", "");
                        zs.setSqlString("select deptid, deptname  from ptdept where FILLSTR10='3'"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid order by deptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("onchange", "reSelectCustBank()");
                        zs.addOption("", "");
                        zs.addAttr("isNull", "true");
                        out.print(zs);
                    %>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>
                <td width="35%" class="data_input">
                    <%
                        zs = new ZtSelect("REALCUSTMGR_ID", "", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "true");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="35%" class="data_input">
                    <%
                        zs = new ZtSelect("BANKID", "", "");
                        zs.setSqlString("select deptid, deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid  order by FILLSTR20,deptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("onchange", "reSelect()");
                        zs.addOption("", "");
                        zs.addAttr("isNull", "false");
                        out.print(zs);
                    %><span class="red_star">*</span>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">Ӫ������</td>
                <td width="35%" class="data_input">
                    <%
                        zs = new ZtSelect("CUSTMGR_ID", "", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("onchange", "promMgrReSelect()");
                        zs.addAttr("isNull", "false");
                        zs.addOption("", "");
                        out.print(zs);
                    %><span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">����״̬</td>
                <td width="35%" class="data_input" colspan="3">
                    <input id="FLOWSTAT1" type="radio" checked="checked" name="FLOWSTAT" value="10"/>��������
                    <input id="FLOWSTAT2" type="radio" name="FLOWSTAT" value="20"/>�������
            </tr>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">���̱�ע</td>
                <td width="35%" class="data_input" colspan="3">
                    <textarea id="AF_REMARK" name="AF_REMARK" rows="10" value="" style="width:96%" textLength="500">
                    </textarea>
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
                           onmouseout="button_onmouseout()" type="button" value="�ύ" onclick="saveClick();">
                </td>
            </tr>
        </table>
    </fieldset>
</form>

<fieldset>
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
</body>
</html>
