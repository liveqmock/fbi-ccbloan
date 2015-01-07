 <!--
/*********************************************************************
* 功能描述: 抵押预约确认处理：确认
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.DateTime" %>
<%
    String doType = "";
    String clientNames = "";
    String strLoanid="";
    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

    strLoanid=request.getParameter("strLoanid");
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>账户信息</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="acctFieldConfirmPay.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<div id="container">
    <form id="editForm" name="editForm">
        <fieldset>
            <legend>缴费报销确认</legend>
            <table width="100%" cellspacing="0" border="0">
                <!-- 操作类型 -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <!--隐藏的loanid-->
                <input type="hidden" id="strLoanid" name="strLoanid" value="<%=strLoanid%>">

                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">报销金额</td>
                    <td width="35%" colspan="3" class="data_input"><input type="text" isNull="false" name="acct_amt" rows="10"
                                                                             id="acct_amt" style="width:90.4%"
                                                                             textLength="200"/> <span class="red_star">*</span></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">确认备注</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="remark" rows="10"
                                                                             id="remark" style="width:90.4%"
                                                                             textLength="200"></textarea></td>
                </tr>
                <tr>
                    <td width="15%" nowrap="nowrap" class="lbl_right_padding">借款人姓名</td>
                    <td width="35%" colspan="3" class="data_input"><textarea name="clientNames" rows="2"
                                                                             id="clientNames" style="width:90.4%" readonly="true"
                                                                             ></textarea></td>
                </tr>
            </table>
        </fieldset>
        <fieldset>
            <legend>操作</legend>
            <table width="100%" class="title1" cellspacing="0">
                <tr>
                    <td align="center">
                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="保存" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                               onMouseOut="button_onmouseout()" type="button" value="取消" onClick="window.close();">
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
</body>
</html>
