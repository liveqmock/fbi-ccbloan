<!--
/*********************************************************************
* ��������: ǩԼ�ſ��δ��֤���˱�һ
* �� ��:
* ��������:
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
    <script language="javascript" src="noRtnQueryList02.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <LINK href="/css/newccb.css" type="text/css" rel="stylesheet">

</head>
<%
    String basedate_kaohe = "2010-07-01";
    try {
        DatabaseConnection conn = ConnectionManager.getInstance().get();
        RecordSet rs = conn.executeQuery("select enuitemlabel from ptenudetail where enutype = 'PAYBILLBASEDATE'  and enuitemvalue = '01'");
        while (rs.next()) {
            basedate_kaohe = rs.getString(0);
        }
    } finally {
        ConnectionManager.getInstance().release();
    }

%>
<body onload="formInit()" bgcolor="#ffffff" class="Bodydefault">

<fieldset style="padding:40px 25px 0px 25px;margin:0px 20px 0px 20px">

    <legend>ͳ������</legend>
    <br>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">

            <!-- ��ϲ�ѯͳ������һ -->
            <input type="hidden" value="miscRpt03" id="rptType" name="rptType"/>
            <input type="hidden" value="<%=basedate_kaohe%>" id="basedate_kaohe" name="basedate_kaohe"/>
            <tr>
                <td width="25%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="20%" nowrap="nowrap" class="data_input"><input type="text" id="ACCTOPENDATE1"
                                                                          name="ACCTOPENDATE1" onClick="WdatePicker()"
                                                                          fieldType="date" size="20"
                                                                          isNull="false"><span class="red_star">*</span>
                </td>
                <td width="5%" nowrap="nowrap" class="lbl_right_padding">��</td>
                <td width="50%" nowrap="nowrap" class="data_input"><input type="text" id="ACCTOPENDATE2"
                                                                          name="ACCTOPENDATE2" onClick="WdatePicker()"
                                                                          fieldType="date" size="20"
                                                                          isNull="false"><span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td colspan="4" nowrap="nowrap" align="center" style="padding:20px">
                    <input name="expExcel" class="buttonGrooveDisableExcel" type="button"
                           onClick="loanTab_expExcel_click()" value="����excel">
                    <input type="reset" value="����" class="buttonGrooveDisable">
                </td>
            </tr>

        </form>
    </table>
</fieldset>

<br/>
<br/>
<br/>

<div class="help-window">
    <DIV class=formSeparator>
        <H2>[ǩԼ�ſ��֤���˱��]</H2>
    </DIV>
    <div class="help-info">
        <ul>
            <li>ͳ������1��ǩԼ�ſ�����ǩԼ�ſ�����.</li>
            <li>ͳ������2���ѻ�֤�һ�֤������ͳ��������.</li>
            <li>ͳ������3����֤���� - ���������� <= 32��.</li>
            <li>ͳ������4��ͳ���������ʼ���ڲ�����<%=basedate_kaohe%>.</li>
            <li>�������ڵ�ͳ��������ָ��Ѻ��������������.</li>
            <li>ͳ�Ʊ���ڱ�1Ϊ�������ܼƱ����Ծ�������Ļ����������.</li>
            <li>ͳ�Ʊ���ڱ�2Ϊ���������ͻ�����ϼƱ����Ծ�������Ļ�����ż��ͻ�����ı������.</li>
            <li>ͳ�Ʊ���ڱ�3Ϊ����ϸ���ݱ����Ծ�������Ļ�����š��ͻ�����ı�š��ͻ���������.</li>
        </ul>
    </div>
</div>


</body>
</html>
