<!--
/*********************************************************************
* ��������: ��ѯ������Ŀ����
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.security.OperatorManager" %>
<%@page import="pub.platform.form.config.SystemAttributeNames" %>
<%@page import="pub.platform.db.DBGrid" %>
<%@page import="pub.platform.html.ZtSelect" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="coopprojQuery.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>

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

    //test
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();

    StringBuilder deptAll = new StringBuilder(" ");
    try {
        RecordSet chrs = dc.executeQuery("select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid");
        while (chrs != null && chrs.next()) {
            deptAll.append("'" + chrs.getString("deptid") + "',");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        cm.release();
    }

    deptAll = deptAll.deleteCharAt(deptAll.length() - 1);

    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("coopprojTable");
    dbGrid.setGridType("edit");

    String sql = "select proj_nbxh," +
            //"(select enuitemlabel from ptenudetail where enutype='COOPAGREEMENTCD' and enuitemvalue=a.AGREEMENTCD)||AGREEMENTNO as AGREEMENTCD," +
            //"otherpromise," +
            "proj_no,  " +
            "proj_name," +
            "proj_name_abbr," +
            "corpname," +
            //"(select enuitemlabel from ptenudetail where enutype='RELEASECONDCD' and enuitemvalue=a.RELEASECONDCD)as RELEASECONDCD," +
            //"MAXLNPERCENT," +
            //"coopperiod, " +
            //"COOPLIMITAMT," +
            "(select deptname from ptdept where deptid=a.bankid)as bankid " +
            "from ln_coopproj a where 1=1  " +
            " ";

    dbGrid.setfieldSQL(sql);

    dbGrid.setField("�ڲ����", "center", "10", "proj_nbxh", "false", "-1");
    //dbGrid.setField("����Э��", "text", "24", "agreementcd", "true", "0");
    //dbGrid.setField("��������Լ��", "text", "10", "otherpromise", "true", "0");
    dbGrid.setField("������Ŀ���", "center", "14", "proj_no", "true", "0");
    dbGrid.setField("������Ŀ����", "text", "14", "proj_name", "true", "0");
    dbGrid.setField("������Ŀ���", "text", "8", "proj_name_abbr", "true", "0");
    dbGrid.setField("������������", "text", "14", "corpname", "true", "0");
    //dbGrid.setField("Լ���ſʽ", "center", "8", "releasecondcd", "true", "0");
    //dbGrid.setField("��ߴ������", "number", "8", "maxlnpercent", "true", "0");
    //dbGrid.setField("��������(��)", "number", "8", "coopperiod", "true", "0");
    //dbGrid.setField("�������", "number", "8", "cooplimitamt", "true", "0");
    dbGrid.setField("������", "center", "10", "bankid", "true", "0");
    dbGrid.setWhereStr(" and a.bankid in(" + deptAll + ") order by proj_no asc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");

    dbGrid.setbuttons("�鿴��Ŀ=query,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ���  �������ֶ���Ϊ��ɾ��֮�� -->
            <input type="hidden" id="proj_nbxh" value="">
            <!-- ϵͳ��־��ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" class="lbl_right_padding"> ������Ŀ���</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="proj_name_abbr" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ������Ŀ����</td>
                <td width="30%" align="right" nowrap="nowrap"
                    class="data_input"><%--<input type="text" id="proj_name" size="40" class="ajax-suggestion url-getPull.jsp">--%>
                    <input type="text" id="proj_name" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ������������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input"><input type="text" id="corpname"
                                                                                        size="60" style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�Ƿ���</td>
                <td width="30%" class="data_input"><%
                    ZtSelect zs = new ZtSelect("maturityflag", "coopmaturityflag", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                </td>
                <td  align="right" nowrap="nowrap"><input name="cbRetrieve" type="button"
                                          id="button" onClick="queryClick()" value="  ����  ">
                </td>
            </tr>
            <tr>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ������</td>
                <td width="30%" class="data_input"><%
                    zs = new ZtSelect("bankid", "", "");
                    zs.setSqlString("select deptid, LPad('&nbsp;', (level - 1) * 36, '&nbsp;') || deptname  from ptdept"
                            + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                            + " connect by prior deptid = parentdeptid");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    out.print(zs);
                %>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��Ӫ����</td>
                <td width="30%" class="data_input"><%
                    zs = new ZtSelect("cust_bankid", "", "");
                    zs.setSqlString("select deptid, deptname  from ptdept where FILLSTR10='3'"
                            + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                            + " connect by prior deptid = parentdeptid  order by deptid");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <td width="10%" align="right" nowrap="nowrap"><input name="Input" type="reset" value="  ����  ">
            </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> ������Ŀ��Ϣ</legend>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%></td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND>����</LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%></td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>
