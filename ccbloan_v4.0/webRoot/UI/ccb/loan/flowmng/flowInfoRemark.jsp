<!--
/*********************************************************************
* ��������: ��Ѻ��Ϣ���������ϸҳ��
*
* �� ��: leonwoo
* ��������: 2010/01/16
* �� �� ��:
* �޸�����:
* �� Ȩ: ��˾
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*" %>

<%
    // ��ע
    String remark = "";
    // ��������
    String doType = "";


    if (request.getParameter("remark") != null)
        remark=new String(request.getParameter("remark").getBytes("ISO8859-1"),"GBK");
    if (request.getParameter("doType") != null){
        doType = request.getParameter("doType");
    }
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>������Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
</head>
<body class="Bodydefault">

<form id="editForm" name="editForm">
<fieldset style="padding: 15px">
    <legend style="margin-bottom: 10px">ҵ�����̱�ע</legend>
    <textarea rows="20" cols="80" id="remark"><%=remark%></textarea>
</fieldset>
<fieldset>
    <legend>����</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td align="center">
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="�ر�" onclick="window.close();">
            </td>
        </tr>
    </table>
</fieldset>
</form>
</body>
</html>
