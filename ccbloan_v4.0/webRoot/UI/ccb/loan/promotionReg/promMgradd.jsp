<!--
/*********************************************************************
* ��������: Ӫ������¼���ƽ����Ϣ
*
* �� ��: haiyuhuang
* ��������: 2011/07/22
* �� �� ��:
* �޸�����:
* �� Ȩ:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%
    String doType = request.getParameter("doType");
     String deptid = request.getParameter("deptid");
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>�ͻ���Ϣ</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="promMgradd.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container"><br>
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>�ͻ������޸��ƽ���Ϣ</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- �������� -->
                <input type="hidden" id="deptid" value="<%=deptid%>">
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">Ӫ��������</td>
                    <td class="data_input"><input type="text" id="PROMMGR_NAME" name="PROMMGR_NAME" value=""
                                                              style="width:90% " isNull="false">
                        <span class="red_star">*</span>
                    </td>
                </tr>
            </table>
        </fieldset>
        <br>
        <fieldset>
            <legend>����</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center"><!--��ѯ-->
                        <%if (doType.equals("select")) { %>
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="�ر�" onClick="window.close();">
                        <%} else if (doType.equals("edit") || doType.equals("add")) { %>
                        <!--���ӣ��޸�-->
                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="����" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
                        <%} else if (doType.equals("delete")) { %>
                        <!--ɾ��-->
                        <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ɾ��" onClick="deleteClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">
                        <%} %>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
<div id="search-result-suggestions">
    <div id="search-results"></div>
</div>
</body>
</html>