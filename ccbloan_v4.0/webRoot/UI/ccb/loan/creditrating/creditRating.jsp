<!--
/*********************************************************************
* ��������: ��������ҳ��֧��
* �޸���: nanmeiying
* �޸�����: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.db.DBGrid" %>
<%@page import="pub.platform.system.manage.dao.PtDeptBean" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>��������</title>
    <script language="javascript" src="creditRating.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    PtDeptBean ptOperBean = omgr.getOperator().getPtDeptBean();
    DBGrid dbGrid = new DBGrid();
    String deptid = ptOperBean.getDeptid();
    dbGrid.setGridID("creditraTable");
    dbGrid.setGridType("edit");
    String sql = "select a.CUSTNO,a.CUSTNAME,a.AGE,decode(a.sex,'1','��','0','Ů') as SEX," +
            "a.BIRTHDAY,a.IDNO,a.CORPTEL,a.CORPADDR,a.HOMEADDR,a.TEL1,a.MOBILE1," +
            "(select ENUITEMLABEL from ptenudetail where ENUTYPE='EDUCATION' and ENUITEMVALUE = a.EDUCATION) as EDUCATION," +
            "(select ENUITEMLABEL from ptenudetail where ENUTYPE='MARISTA' and ENUITEMVALUE = a.MARISTA) as MARISTA," +
            "a.WORKYEARS,a.INCOME,a.HOMEPERSONS," +
            "decode(a.HEALTH,'01','����','02','һ��','03','�ϲ�') as HEALTH," +
            "decode(a.MEMBERFLG,'1','��','0','��') as MEMBERFLG," +
            "a.SPOUSENAME,a.SPOUSETEL,a.REMARK,a.DEPTID," +
            "(select DEPTNAME || '('|| DEPTID || ')' from ptdept where DEPTID = a.DEPTID) as DEPTNAME," +
            "a.OPERID,a.OPERDATE,a.UPDOPERID,a.UPDDATE,a.VALIDITYTIME,SYSDATE,a.VALIDITYTIMETWO from ln_pcif a where recsta = '1' ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("�ͻ���", "center", "18", "custno", "true", "-1");
    dbGrid.setField("�ͻ���", "text", "16", "custname", "true", "0");
    dbGrid.setField("����", "center", "10", "age", "true", "0");
    dbGrid.setField("�Ա�", "center", "10", "sex", "true", "0");
    dbGrid.setField("��������", "center", "18", "birthday", "true", "0");
    dbGrid.setField("֤������", "center", "26", "idno", "true", "0");
    dbGrid.setField("��λ�绰", "center", "16", "corptel", "true", "0");
    dbGrid.setField("��λ��ַ", "text", "17", "corpaddr", "true", "0");
    dbGrid.setField("��ͥ��ַ", "text", "17", "homeaddr", "true", "0");
    dbGrid.setField("�����绰1", "center", "16", "tel1", "true", "0");
    dbGrid.setField("�ֻ�1", "center", "16", "mobile1", "true", "0");
    dbGrid.setField("�Ļ��̶�", "text", "15", "education", "true", "0");
    dbGrid.setField("����״��", "text", "15", "marista", "true", "0");
    dbGrid.setField("����λ��������", "number", "10", "workyears", "true", "0");
    dbGrid.setField("����������", "number", "16", "income", "true", "0");
    dbGrid.setField("��ͥ�˿���", "number", "10", "homepersons", "true", "0");
    dbGrid.setField("����˽���״��", "center", "20", "health", "true", "0");
    dbGrid.setField("�Ƿ���Ա��", "center", "12", "memberflg", "true", "0");
    dbGrid.setField("��ż����", "text", "14", "spousename", "true", "0");
    dbGrid.setField("��ż�绰", "center", "16", "spousetel", "true", "0");
    dbGrid.setField("��ע", "text", "12", "remark", "true", "0");
    dbGrid.setField("����������", "center", "16", "deptid", "false", "0");
    dbGrid.setField("��������", "text", "30", "deptname", "true", "0");
    dbGrid.setField("������Ա", "text", "14", "operid", "true", "0");
    dbGrid.setField("��������", "center", "18", "operdate", "true", "0");
    dbGrid.setField("�޸Ĺ�Ա", "text", "14", "updoperid", "true", "0");
    dbGrid.setField("�޸�����", "center", "18", "upddate", "true", "0");
    dbGrid.setField("��Ч����", "center", "18", "validitytime", "false", "0");
    dbGrid.setField("��ǰ����", "center", "18", "sysdate", "false", "0");
    dbGrid.setField("��Ч���ڶ�", "center", "18", "validitytimetwo", "false", "0");
    dbGrid.setWhereStr(" order by operdate desc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,�鿴�ͻ�����=query,��������=creditRating,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ϵͳ��־��ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" class="lbl_right_padding"> �ͻ���</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="custno" size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">֤������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="idno" size="60" style="width:90% ">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custname" size="60" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding"> ����������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="deptid" size="60" value="<%=deptid%>" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="�� ��">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" id="operid" size="60" style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�޸Ĺ�Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" id="updoperid" size="60" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="�� ��"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> �ͻ���Ϣ</legend>
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
