<!--
/*********************************************************************
* ��������: �����ͻ��б�
* �޸���: nanmeiying
* �޸�����: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.db.DBGrid" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>����ͨ��������</title>
    <script language="javascript" src="uncomcreditList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>

    <script type="text/javascript">
        function checkDateEnd(input) {
            var ibdStr = document.getElementById("queryDateBeg").value;
            var iedStr = input.value;
            if (iedStr.length == 0) {
                return;
            }
            if (iedStr <= ibdStr) {
                alert("Ӧ���ڳ�ʼ���ڣ�");
                input.value = "";
                return;
            }
        }
    </script>
</head>
<%
    DBGrid dbGrid = new DBGrid();
    dbGrid.setGridID("creditraTable");
    dbGrid.setGridType("edit");
    String sql = "select t.pkid,t.creditratingno," +
            "(select ENUITEMLABEL from ptenudetail where ENUTYPE='IDTYPE' and ENUITEMVALUE = t.idtype) as idtype," +
            "t.idno,t.custname," +
            "(select ENUITEMLABEL from ptenudetail where ENUTYPE='JUDGETYPE' and ENUITEMVALUE = t.judgetype) as judgetype," +
            "t.judgelevel,t.judgeprice,t.timelimit,t.begdate,t.enddate,t.birthday,t.age," +
            "decode(t.sex,'1','��','0','Ů') as sex," +
            "t.post,t.income,t.formalworker,t.judgeoperid," +
            "(select opername from ptoper where operid = t.JUDGEOPERID) as opername," +
            "t.judgedate,t.judgedeptid," +
            "(select deptname from ptdept where deptid = t.judgedeptid ) as deptname,t.docid " +
            "from ln_uncomcredit t where recsta = '1' ";
    dbGrid.setfieldSQL(sql);
    dbGrid.setField("����", "center", "7", "pkid", "false", "-1");
    dbGrid.setField("����������", "center", "7", "creditratingno", "true", "-1");
    dbGrid.setField("֤������", "center", "9", "idtype", "true", "0");
    dbGrid.setField("֤������", "center", "8", "idno", "true", "0");
    dbGrid.setField("�ͻ�����", "text", "4", "custname", "true", "0");
    dbGrid.setField("���ŷ�ʽ", "center", "4", "judgetype", "true", "0");
    dbGrid.setField("���ŵȼ�", "center", "4", "judgelevel", "true", "0");
    dbGrid.setField("���Ž��(��)", "number", "5", "judgeprice", "true", "0");
    dbGrid.setField("����(��)", "number", "3", "timelimit", "true", "0");
    dbGrid.setField("��Ч��������", "center", "5", "begdate", "true", "0");
    dbGrid.setField("��Ч����ֹ��", "center", "5", "enddate", "true", "0");
    dbGrid.setField("��������", "center", "5", "birthday", "true", "0");
    dbGrid.setField("����", "center", "2", "age", "true", "0");
    dbGrid.setField("�Ա�", "center", "2", "sex", "true", "0");
    dbGrid.setField("ְ��", "center", "4", "post", "true", "0");
    dbGrid.setField("������(Ԫ)", "center", "4", "income", "true", "0");
    dbGrid.setField("�Ƿ���ʽԱ��", "center", "5", "formalworker", "true", "0");
    dbGrid.setField("����Ա����", "center", "4", "judgeoperid", "false", "0");
    dbGrid.setField("����Ա����", "center", "4", "opername", "true", "0");
    dbGrid.setField("��������", "center", "5", "judgedate", "true", "0");
    dbGrid.setField("���Ż�����", "center", "4", "judgedeptid", "false", "0");
    dbGrid.setField("���Ż���", "center", "4", "deptname", "true", "0");
    dbGrid.setField("������", "center", "9", "docid", "true", "0");
    dbGrid.setWhereStr(" order by judgedate desc ");
    dbGrid.setpagesize(50);
    dbGrid.setdataPilotID("datapilot");
    dbGrid.setbuttons("����Excel=excel,�鿴�ͻ�����=query,�����ͻ�=insertRecord,׷�ӿͻ�=appendRecord,�޸Ŀͻ�=editRecord,ɾ���ͻ�=deleteRecord,���������=barCodeManage,moveFirst,prevPage,nextPage,moveLast");
%>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset>
    <legend> ��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <!-- ϵͳ��־��ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <input type="hidden" id="pkid" name="pkid" value="">
            <tr>
                <td width="20%" class="lbl_right_padding">����������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="creditratingno" size="30" style="width:90% ">
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
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">���Ż�����</td>
                <td width="30%" class="data_input">
                    <input type="text" id="judgedeptid" size="60" value="" style="width:90% ">
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="cbRetrieve" type="button" class="buttonGrooveDisable" id="button"
                           onClick="queryClick();" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()"
                           value="�� ��">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����Ա����</td>
                <td width="30%" class="data_input">
                    <input type="text" id="judgeoperid" size="60" style="width:90% ">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">���ŷ�ʽ</td>
                <td width="30%" class="data_input">
                    <select id="judgetype">
                        <option value="" selected="true"></option>
                        <option value="01">��������</option>
                        <option value="02">�߶�����</option>
                        <option value="03">������</option>
                        <option value="04">��������</option>
                        <option value="05">��������</option>
                    </select>
                </td>
                <td width="10%" align="right" nowrap="nowrap">
                    <input name="Input" class="buttonGrooveDisable" type="reset" value="�� ��"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
            <tr>
                <td width="20%" class="lbl_right_padding">����������</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="queryDateBeg"
                           onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'queryDateEnd\')}'})"
                           size="30" style="width:90% ">
                </td>
                <td width="20%" align="right" nowrap="nowrap" class="lbl_right_padding">��������ֹ</td>
                <td width="30%" align="right" nowrap="nowrap" class="data_input">
                    <input type="text" id="queryDateEnd"
                           onFocus="WdatePicker({minDate:'#F{$dp.$D(\'queryDateBeg\')}'})"
                           size="60" style="width:90% ">
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
