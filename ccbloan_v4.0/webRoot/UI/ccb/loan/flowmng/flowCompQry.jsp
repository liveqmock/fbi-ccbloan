<!--
/*********************************************************************
* ��������: ���̴����ۺϲ�ѯ
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

    //���̻�����Ϣ��
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("flowInfoTab");
    dbGrid.setGridType("edit");
    String infoSql = "select a.flowsn as keycode,\n" +
            "       decode(b.loanid, null, a.cust_name, b.cust_name) cust_name,\n" +
            "       decode(b.loanid, null, a.rt_orig_loan_amt, b.rt_orig_loan_amt) rt_orig_loan_amt,\n" +
            "       decode(b.loanid, null, a.rt_term_incr, b.rt_term_incr)  rt_term_incr,\n" +
            "       (select deptname from ptdept where deptid = decode(b.loanid, null, a.bankid, b.bankid)) as bankname,\n" +
            "       (select prommgr_name  from ln_prommgrinfo where prommgr_id = decode(b.loanid, null, a.custmgr_id, b.custmgr_id)) as custmgr_name,\n" +
            "       (select deptname from ptdept where deptid = decode(b.loanid, null, a.cust_bankid, c.cust_bankid)) as cust_bankname,\n" +
            "       (select opername from ptoper where operid = decode(b.loanid, null, a.realcustmgr_id, c.custmgr_id)) as realcustmgr_name,\n" +
            "       (select  code_desc  from ln_odsb_code_desc where code_type_id='053' and code_id = c.ln_typ) as ln_typ,\n" +
            "       a.operdate\n" +
            "  from ln_archive_info a, ln_loanapply b, ln_promotioncustomers c\n" +
            " where 1 = 1\n" +
            "   and a.loanid = b.loanid(+)\n" +
            "   and a.loanid = c.loanid(+)\n" +
            " ";

    infoSql += "  and exists (select  1 from (select deptid from ptdept start with deptid = '" + omgr.getOperator().getDeptid() + "' connect by prior deptid = parentdeptid)  where a.bankid = deptid) ";

    dbGrid.setfieldSQL(infoSql);

    dbGrid.setField("ҵ����ˮ��", "center", "8", "keycode", "true", "-1");
    dbGrid.setField("�����", "center", "5", "cust_name", "true", "0");
    dbGrid.setField("������", "money", "5", "rt_orig_loan_amt", "true", "0");
    dbGrid.setField("��������", "center", "5", "rt_term_incr", "false", "0");
    dbGrid.setField("�������", "center", "5", "bankname", "true", "0");
    dbGrid.setField("Ӫ������", "center", "5", "custmgr_name", "true", "0");
    dbGrid.setField("��Ӫ����", "center", "5", "cust_bankname", "true", "0");
    dbGrid.setField("�ͻ�����", "center", "5", "realcustmgr_name", "true", "0");
    dbGrid.setField("��������", "center", "5", "ln_typ", "true", "0");
    dbGrid.setField("��������", "center", "5", "operdate", "false", "0");

    dbGrid.setWhereStr(" and 1=2 order by a.operdate desc ");
    dbGrid.setpagesize(5);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("moveFirst,prevPage,nextPage,moveLast");


    //���̽ڵ��
    DBGrid dbGridDetail = new DBGrid();
    dbGridDetail.setGridID("flowNodeTab");
    dbGridDetail.setGridType("edit");
    String detailSql = "select (select roledesc from ptrole where roleid = b.roleid) as roledesc," +
            "       a.operdate," +
            "       a.opertime," +
            "       (select opername from ptoper where operid = a.operid) as opername," +
            "       a.flowstat," +
            "       a.remark" +
            "  from ln_archive_flow a" +
            "  left join ptoperrole b" +
            "    on a.operid = b.operid" +
            " where " +
            "   b.roleid =" +
            "       (select min(roleid) from ptoperrole where operid = a.operid and roleid like 'WF%') ";
    dbGridDetail.setWhereStr(" and 1=2 order by a.operdate desc,a.opertime desc ");
    dbGridDetail.setfieldSQL(detailSql);

    dbGridDetail.setField("��λ����", "center", "5", "roledesc", "true", "0");
    dbGridDetail.setField("��������", "center", "5", "operdate", "true", "0");
    dbGridDetail.setField("����ʱ��", "center", "5", "opertime", "true", "0");
    dbGridDetail.setField("������Ա", "center", "5", "opername", "true", "0");
    dbGridDetail.setField("����״̬", "dropdown", "5", "flowstat", "true", "ARCHIVEFLOW");
    dbGridDetail.setField("����˵��", "center", "15", "remark", "true", "0");

    dbGridDetail.setpagesize(15);
    dbGridDetail.setdataPilotID("detaildatapilot");
    //dbGridDetail.setbuttons("default");
    dbGridDetail.setbuttons("moveFirst,prevPage,nextPage,moveLast");
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
    <script language="javascript" src="flowCompQry.js"></script>

</head>
<%--<body onload="formInit();" class="Bodydefault">--%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">

<form id="queryForm" name="queryForm">
    <fieldset style="padding: 15px">
        <legend style="margin-bottom: 10px">��ѯ����</legend>
        <table width="100%" cellspacing="0" border="0">

            <input type="hidden" id="recversion" value=""/>
            <input type="hidden" id="af_recversion" value=""/>
            <input type="hidden" id="af_pkid" value=""/>
            <input type="hidden" id="deptid" value="<%=omgr.getOperator().getDeptid()%>"/>
            <input type="hidden" id="busiNode" name="busiNode" value=""/>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">ҵ����ˮ��</td>
                <td width="30%" class="data_input"><input type="text" id="FLOWSN" name="FLOWSN" value=""
                                                          textLength="100" style="width:90% ">
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">�����</td>
                <td width="35%" class="data_input"><input type="text" id="CUST_NAME" name="CUST_NAME" style="width:90%"
                                                          textLength="40"  >
                </td>
            </tr>
            <%--<tr>--%>
                <%--<td width="15%" nowrap="nowrap" class="lbl_right_padding">������</td>--%>
                <%--<td width="35%" class="data_input"><input type="text" id="RT_ORIG_LOAN_AMT" name="RT_ORIG_LOAN_AMT"--%>
                                                          <%--value=""--%>
                                                          <%--onblur="Txn_GotFocus(this);" style="width:90%" intLength="18"--%>
                                                          <%--floatLength="2"--%>
                                                           <%--></td>--%>
                <%--<td width="15%" nowrap="nowrap" class="lbl_right_padding">��������</td>--%>
                <%--<td width="35%" class="data_input"><input type="text" id="RT_TERM_INCR" name="RT_TERM_INCR" value=""--%>
                                                          <%--style="width:90%" intLength="12" ></td>--%>

            <%--</tr>--%>
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="35%" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("BANKID", "", "");
                        zs.setSqlString("select deptid, deptname  from ptdept"
                                + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                                + " connect by prior deptid = parentdeptid  order by FILLSTR20,deptid");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("onchange", "reSelect()");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">Ӫ������</td>
                <td width="35%" class="data_input">
                    <%
                        zs = new ZtSelect("CUSTMGR_ID", "", "");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        //zs.addAttr("onchange", "promMgrReSelect()");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
            </tr>
            <%--<tr>--%>
                <%--<td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ӫ����</td>--%>
                <%--<td width="35%" class="data_input">--%>
                    <%--<%--%>
                        <%--zs = new ZtSelect("CUST_BANKID", "", "");--%>
                        <%--zs.setSqlString("select deptid, deptname  from ptdept where FILLSTR10='3'"--%>
                                <%--+ " start with deptid = '" + omgr.getOperator().getDeptid() + "'"--%>
                                <%--+ " connect by prior deptid = parentdeptid order by deptid");--%>
                        <%--zs.addAttr("style", "width: 90%");--%>
                        <%--zs.addAttr("fieldType", "text");--%>
                        <%--zs.addAttr("onchange", "reSelectCustBank()");--%>
                        <%--zs.addOption("", "");--%>
                        <%--//zs.addAttr("isNull", "false");--%>
                        <%--out.print(zs);--%>
                    <%--%>--%>
                <%--</td>--%>
                <%--<td width="15%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>--%>
                <%--<td width="35%" class="data_input">--%>
                    <%--<%--%>
                        <%--zs = new ZtSelect("REALCUSTMGR_ID", "", "");--%>
                        <%--zs.addAttr("style", "width: 90%");--%>
                        <%--zs.addAttr("fieldType", "text");--%>
                        <%--//zs.addAttr("isNull", "false");--%>
                        <%--zs.addOption("", "");--%>
                        <%--out.print(zs);--%>
                    <%--%>--%>
                <%--</td>--%>
            <%--</tr>--%>
<%--
            <tr>
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">������������״̬</td>
                <td width="35%" class="data_input" >
                    <input id="FLOWSTAT0" type="radio" checked="checked" name="FLOWSTAT" value="00"/>ȫ��
                    <input id="FLOWSTAT1" type="radio" name="FLOWSTAT" value="10"/>��������
                    <input id="FLOWSTAT2" type="radio" name="FLOWSTAT" value="20"/>�������
                <td width="15%" nowrap="nowrap" class="lbl_right_padding">��������ע˵��</td>
                <td width="35%" class="data_input" >
                    <input id="AF_REMARK" name="AF_REMARK" value="" style="width:90%" textLength="500">
                    </input>
                </td>

            </tr>
--%>

        </table>
    </fieldset>

    <fieldset>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td align="center">
                    <!--���ӣ��޸�-->
                    <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="����" onclick="onSearch();">
                    <input name="" class="buttonGrooveDisable" type="reset" value="����" onmouseover="button_onmouseover()" onmouseout="button_onmouseout()">
                </td>
            </tr>
        </table>
    </fieldset>
</form>

<fieldset>
    <LEGEND> ��������������Ϣ�б�</LEGEND>
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
    <LEGEND> ҵ��������Ϣ�б�</LEGEND>
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
