<!--
/*********************************************************************
* ��������: �ͻ����ֵȼ�ά��
*
* �� ��: nanmeiying
* ��������: 2013/09/03
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="com.ccb.dao.LNPSCOREDETAIL" %>
<%@page import="pub.platform.utils.BusinessDate" %>
<%@page import="pub.platform.utils.StringUtils" %>
<%
    String creditratingno = "";  // �ڲ����
    String doType = "";  // ��������
    if (request.getParameter("creditratingno") != null) {
        creditratingno = request.getParameter("creditratingno");
    }
    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");
    LNPSCOREDETAIL bean = new LNPSCOREDETAIL();
    if (creditratingno != null) {
        bean = LNPSCOREDETAIL.findFirst("where creditratingno='" + creditratingno + "'");
        if (bean != null) {
            StringUtils.getLoadForm(bean, out);
        }
    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>����¼��ҳ��</title>
    <script type="text/javascript" src="/UI/support/tabpane.js"></script>
    <script type="text/javascript" src="/UI/support/common.js"></script>
    <script type="text/javascript" src="/UI/support/DataWindow.js"></script>
    <script type="text/javascript" src="/UI/support/pub.js"></script>
    <script type="text/javascript" src="pscoredetailEdit.js"></script>
    <script type="text/javascript">
        function checkNumber(input) {
            var val = input.value;
            var temp = parseInt(val);
            if (val != temp) {
                alert("����������!");
                input.value = "";
                return;
            }
            input.value = temp;
        }
    </script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<form id="editForm" name="editForm">
    <!-- ������Ŀ״̬ -->
    <input type="hidden" id="MYPROJSTATUS">
    <br>
    <fieldset>
        <legend>������Ϣ</legend>
        <table width="100%" cellspacing="0" border="0">
            <input type="hidden" id="doType" value="<%=doType%>">
            <!-- �汾�� -->
            <input type="hidden" id="recVersion" value="">
            <!-- ϵͳ��־ʹ�� -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����������</td>

                <td width="30%" class="data_input">
                    <input type="hidden" id="idno" name="idno"/>
                    <input type="text" id="creditratingno" name="creditratingno" value="" textLength="200"
                           style="width:90%"
                           isNull="false"
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ͻ���</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custno" name="custno" value="" textLength="200" style="width:90%"
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����÷�</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finscore" name="finscore" value="" textLength="200"
                           style="width:90%"
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����ȼ�</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finlevel" name="finlevel" value="" textLength="200"
                           style="width:90% "
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">�������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finamt" name="finamt" value="" textLength="200"
                           style="width:60% "
                           onchange="checkNumber(this);">(��λ:��)
                    <span class="red_star">*</span>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finoperid" name="finoperid" value="" textLength="200" style="width:90% "
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="findate" name="findate" value="" style="width:90%" onClick="WdatePicker()"
                           fieldType="date" disabled="disabled">
                    <span class="red_star">*</span>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="findeptid" name="findeptid" value="" textLength="200" style="width:90% "
                           disabled="disabled">
                    <span class="red_star">*</span>
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ч������</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finbegdate" name="finbegdate" value="" style="width:90%"
                           onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'finenddate\',{d:-1});}'})"
                           fieldType="date">
                    <span class="red_star">*</span>
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ч��ֹ��</td>
                <td width="30%" class="data_input">
                    <input type="text" id="finenddate" name="finenddate" value="" style="width:90%"
                           onFocus="WdatePicker({minDate:'#F{$dp.$D(\'finbegdate\',{d:1});}'})"
                           fieldType="date">
                    <span class="red_star">*</span>
                    <input type="hidden" id="docid" name="docid" value="">
                </td>
            </tr>
        </table>
    </fieldset>
    <br>
    <fieldset>
        <legend>������Ϣ</legend>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
                <td width="30%" class="data_input">
                    <input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%" disabled="disabled">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
                <td width="30%" class="data_input">
                    <input type="text" value="<%=BusinessDate.getToday() %>" style="width:90%" disabled="disabled">
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
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;�ر�&nbsp;&nbsp;&nbsp;"
                           onclick="window.close();">
                    <%} else if (doType.equals("edit") || doType.equals("add")) { %> <!--���ӣ��޸�-->
                    <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;"
                           onclick="saveClick();">
                    <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;"
                           onclick="window.close();">
                    <%} else if (doType.equals("delete")) { %> <!--ɾ��-->
                    <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ɾ��&nbsp;&nbsp;&nbsp;"
                           onclick="deleteClick();">
                    <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;"
                           onclick="window.close();">
                    <%} %>
                </td>
            </tr>
        </table>
    </fieldset>
</form>
</body>
</html>
