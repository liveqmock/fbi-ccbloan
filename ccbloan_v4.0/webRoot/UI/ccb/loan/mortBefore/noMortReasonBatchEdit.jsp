<!--
/*********************************************************************
* ��������: ��Ѻ��Ϣ�����Ѻ��ϸҳ��;ǩԼ�ſ�δ���Ѻԭ��Ǽǡ�
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
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>ǩԼ�ſ�δ�����Ѻԭ��Ǽ�</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="noMortReasonEdit.js"></script>
    <script type="text/javascript" language="javascript">
        function formInit() {
            // δ�����Ѻԭ�� ��Ĭ��ֵ 07
            if (document.getElementById("NOMORTREASONCD").value == "") {
                document.getElementById("NOMORTREASONCD").value = "07";
            }
            // ��ʼ�����ݴ��ڣ�У���ʱ����
            dw_column = new DataWindow(document.getElementById("editForm"), "form");
            // ����Ĭ�Ͻ��㣻δ�����Ѻԭ��
            if (operation != "select") {
                document.getElementById("NOMORTREASONCD").focus();
            }
        }
        function saveClick() {
            var arg = new Object();
            if (operation = "edit") {
                arg.nomortreasoncd = document.getElementById("NOMORTREASONCD").value;
                arg.nomortreason = document.getElementById("NOMORTREASON").value;
                window.returnValue = arg;
                window.close();
            }
        }
    </script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container" style="margin: 10px">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>ǩԼ�ſ�δ�����Ѻԭ��Ǽ�</legend>
            <table width="100%" cellspacing="0" border="0">
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">δ�����Ѻԭ��</td>
                    <td width="30%" class="data_input"><%
                        ZtSelect zs = new ZtSelect("NOMORTREASONCD", "NOMORTREASONCD", "07");
                        Set noUseSet=new HashSet();
                        noUseSet.add("03");
                        noUseSet.add("04");
                        zs.setNosedValue(noUseSet);
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "false");
                        //zs.addOption("", "");
                        out.print(zs);
                    %>
                        <span class="red_star">*</span></td>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding"></td>
                    <td width="30%" class="data_input"></td>
                </tr>
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">δ�����Ѻԭ��ע</td>
                    <td width="30%" colspan="3" class="data_input"><textarea name="NOMORTREASON" rows="4"
                                                                             id="NOMORTREASON" style="width:96%"
                                                                             textLength="500"></textarea>
                </tr>
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                    <td width="30%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>"
                                                              style="width:90%" disabled="disabled"></td>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
                    <td width="30%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                              style="width:90%" disabled="disabled"></td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>����</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center"><!--��ѯ-->

                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="����" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="ȡ��" onClick="window.close();">

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
