<%@ page import="java.text.SimpleDateFormat" %>
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
    <script language="javascript" src="noRtnQueryList01.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <LINK href="/css/newccb.css" type="text/css" rel="stylesheet">

</head>
<%
    Calendar calendar = new GregorianCalendar();
    Calendar calendar1 = new GregorianCalendar(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH) - 1, 1);
    Date lastmonth = calendar1.getTime();
    String ACCTOPENDATE1 = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

    calendar1.set(Calendar.DAY_OF_MONTH, calendar1.getActualMaximum(Calendar.DAY_OF_MONTH));
    lastmonth = calendar1.getTime();
    String basedate_kaohe = "2011-01-01";
    String ACCTOPENDATE2 = new SimpleDateFormat("yyyy-MM-dd").format(lastmonth);

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
                <%--
                                <td width="25%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                                <td width="20%" nowrap="nowrap" class="data_input"><input type="text" id="ACCTOPENDATE1"
                                                                                          name="ACCTOPENDATE1" onClick="WdatePicker()" value="<%=ACCTOPENDATE1%>"
                                                                                          fieldType="date" size="20" isNull="false"><span class="red_star">*</span></td>
                                <td width="5%" nowrap="nowrap" class="lbl_right_padding">��</td>
                                <td width="50%" nowrap="nowrap" class="data_input"><input type="text" id="ACCTOPENDATE2"
                                                                                          name="ACCTOPENDATE2" onClick="WdatePicker()" value="<%=ACCTOPENDATE2%>"
                                                                                          fieldType="date" size="20" isNull="false"><span class="red_star">*</span></td>
                --%>
                <td width="30%" nowrap="nowrap" class="lbl_right_padding">����ͳ�ƽ�ֹ����:</td>
                <td width="70%" nowrap="nowrap" class="data_input">
                    <input type="text" id="ACCTOPENDATE2"
                           name="ACCTOPENDATE2" onClick="WdatePicker()"
                           value="<%=ACCTOPENDATE2%>"
                           fieldType="date" size="40"
                           isNull="false"/>
                    <span class="red_star">*</span>
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
        <H2>[ǩԼ�ſ��֤���˱�һ]</H2>
    </DIV>
    <div class="help-info">
        <ul>
            <li>ͳ������1��ǩԼ�ſ�����ǩԼ�ſ�.</li>
            <li>ͳ������2��δ��֤���ѻ�֤����֤�����ڿ���ͳ�ƽ�ֹ����֮��.</li>
            <li>ͳ������3����Ѻ����������+60��������ڿ���ͳ�ƽ�ֹ����֮ǰ������.</li>
            <li>ͳ�Ʊ���ڱ�1Ϊ�������ܼƱ����Ծ�������Ļ����������.</li>
            <li>ͳ�Ʊ���ڱ�2Ϊ���������ͻ�����ϼƱ����Ծ�������Ļ�����ż��ͻ�����ı������.</li>
            <li>ͳ�Ʊ���ڱ�3Ϊ����ϸ���ݱ����Ծ�������Ļ�����š��ͻ�����ı�š��ͻ���������.</li>

        </ul>
    </div>
</div>


</body>
</html>
