<!--
/*********************************************************************
* ��������: ������ͳ�Ʊ�
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="payBillList101.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <LINK href="/css/newccb.css" type="text/css" rel="stylesheet">

</head>

<%
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();

    String baseval1="";
    String baseval2="";
    String baseval3="";
    String baseval4="";
//    String baseval5="";
    try {
        RecordSet chrs = dc.executeQuery("select t.enuitemexpand from ptenudetail t where t.enutype='BIZPARAM' and t.enuitemvalue like 'PayBillRpt101_%'");
        if  (chrs != null && chrs.next()) {
            baseval1 =  chrs.getString("enuitemexpand");
        }
        if  (chrs != null && chrs.next()) {
            baseval2 =  chrs.getString("enuitemexpand");
        }
        if  (chrs != null && chrs.next()) {
            baseval3 =  chrs.getString("enuitemexpand");
        }
        if  (chrs != null && chrs.next()) {
            baseval4 =  chrs.getString("enuitemexpand");
        }
/*
        if  (chrs != null && chrs.next()) {
            baseval5 =  chrs.getString("enuitemexpand");
        }
*/
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
//         if ( isAutoRelease )
        cm.release();
    }

%>


<body onload="formInit()" bgcolor="#ffffff" class="Bodydefault">
<form id="queryForm" name="queryForm">
    <fieldset style="padding:40px 25px 0px 25px;margin:0px 20px 0px 20px">
        <legend>��������</legend>
        <table border="0" cellspacing="0" cellpadding="0" width="90%" style="margin-top: 25px" align="center">
            <input type="hidden" value="miscRpt03" id="rptType" name="rptType"/>
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">ͳ����ʼ����</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE"
                                                                          name="MORTEXPIREDATE" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
            </tr>
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">ͳ�ƽ�ֹ����</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE2"
                                                                          name="MORTEXPIREDATE2" onClick="WdatePicker()"
                                                                          fieldType="date" size="20%"></td>
            </tr>
        </table>
        <table border="0" cellspacing="0" cellpadding="0" width="90%" style="margin-top: 25px" align="center">
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">����ס������ ÿ��Ԫ�򵥼۸�</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="baseval1" value="<%=baseval1%>"
                                                                          name="baseval1" size="20%" style="text-align: right"></td>
            </tr>
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">�����ٽ��״��� ÿ��Ԫ�򵥼۸�</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="baseval2" value="<%=baseval2%>"
                                                                          name="baseval2" size="20%" style="text-align: right"></td>
            </tr>
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">����֧ũ���� ÿ��Ԫ�򵥼۸�</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="baseval3" value="<%=baseval3%>"
                                                                          name="baseval3" size="20%" style="text-align: right" ></td>
            </tr>
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">������������� ÿ��Ԫ�򵥼۸�</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="baseval4" value="<%=baseval4%>"
                                                                          name="baseval4" size="20%" style="text-align: right"></td>
            </tr>
<%--
            <tr>
                <td width="40%" nowrap="nowrap" class="lbl_right_padding">������������� ÿ��Ԫ�򵥼۸�</td>
                <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="baseval5"  value="<%=baseval5%>"
                                                                          name="baseval5" size="20%" style="text-align: right"></td>
            </tr>
--%>
            <tr>
                <td colspan="4" nowrap="nowrap" align="center" style="padding:20px">
                    <input name="expExcel" class="buttonGrooveDisableExcel" type="button"
                           onClick="loanTab_expExcel_click()" value="����excel">
                    <input type="reset" value="����" class="buttonGrooveDisable">
                </td>
            </tr>
        </table>
    </fieldset>
</form>

<br/>
<br/>
<br/>

<div class="help-window">
    <DIV class=formSeparator>
        <H2>[������ͳ��]</H2>
    </DIV>
    <div class="help-info">
        <ul>
            <li>���߰棺2013-07-30.</li>
            <li>���߰棺��ԭ�������ֱ�Ϊ���֣�����ס�����һ�ַ������ַ����ֳɸ���ס������͸����ٽ��״���������������ֳɸ���֧ũ������������������.</li>
            <li>���߰棺���ݴ������࣬�򵥼۸���б仯.</li>
            <li>�����棺2013-04-27.</li>
            <li>�����棺����������»��� 1������ס���������һ�ַ������ַ�������������.</li>
            <li>�����棺��������㼶���»���.</li>
            <li>����棺2012-09-18.</li>
            <li>����棺�ֱ�������ס���������һ�ַ������ַ����͸�����ҵ�÷����Ч����.</li>
            <li>����棺����ס����������ִ��ˮƽ����ϵ�� = 1 +������λ����ס�������Ȩƽ���ϸ��� - ȫ�и���ס������ƽ���ϸ��ʣ��� 3.5.</li>
            <li>���İ棺2012-07-20.</li>
            <li>���İ棺�޸��Ű棬����Excel���㹫ʽ.</li>
            <li>�����棺2012-06-25.</li>
            <li>�����棺���Ӹ���ס���������.</li>
            <li>�����棺����֧�С�����֧�С�ȫ����֧�С�����һ�����ܶ����з����������.</li>
            <li>�ڶ��棺2012-05-25.</li>
            <li>�ڶ��棺����֧ũ�������.</li>
            <li>���棺2012-05-05.</li>
            <li>EXCEL����˵����������Ϻ󣬴�EXCEL�ļ����� Ctrl+Alt+Shift+F9 ���й�ʽ����.</li>
        </ul>
    </div>
</div>


</body>
</html>
