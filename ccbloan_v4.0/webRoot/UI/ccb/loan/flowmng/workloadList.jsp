<%@ page import="org.joda.time.DateTime" %>
<!--
/*********************************************************************
* ��������: ����ҵ����ͳ�Ʊ�
* �� ��: zr
* ��������: 2015/01/06
* �� �� ��:
* �޸�����:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%
    DateTime dateTime = new DateTime().minusDays(1);
    String rptdate = dateTime.toString("yyyy-MM-dd");
    String startdate = "2015-01-01";
%>

<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="workloadList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <LINK href="/css/newccb.css" type="text/css" rel="stylesheet">

</head>
<body onload="formInit()" bgcolor="#ffffff" class="Bodydefault">

<fieldset style="padding:40px 25px 0px 25px;margin:0px 20px 0px 20px">

    <legend>��ѯ����</legend>
    <br>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">

            <!-- ��ϲ�ѯͳ������һ -->
            <input type="hidden" value="miscRpt03" id="rptType" name="rptType"/>
            <tr>
                <td width="25%" nowrap="nowrap" class="lbl_right_padding">ͳ������</td>
                <td width="20%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE" value="<%=startdate%>"
                                                                          name="MORTEXPIREDATE" onClick="WdatePicker()"
                                                                          fieldType="date" size="20"></td>
                <td width="5%" nowrap="nowrap" class="lbl_right_padding">��</td>
                <td width="50%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE2" value="<%=rptdate%>"
                                                                          name="MORTEXPIREDATE2" onClick="WdatePicker()"
                                                                          fieldType="date" size="20"></td>
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
        <H2>[����ҵ����ͳ���ձ���]</H2>
    </DIV>
    <div class="help-info">
        <ul>
            <li>����ֹ����ͳ�Ƹ���λҵ����.</li>
            <li>Ĭ��ͳ����ʼ����2015-01-01.</li>
            <li>����ֹ�ľ�������.</li>
            <li>ͳ�Ʊ��Ի������ĸ�λ�������.</li>
            <li>��λֻ�����̹���ڣ�WF��ͷ��.</li>
        </ul>
    </div>
</div>


</body>
</html>
