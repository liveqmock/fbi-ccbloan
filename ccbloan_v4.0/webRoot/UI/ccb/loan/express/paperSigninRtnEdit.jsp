<!--
/*********************************************************************
*    功能描述: 权证签收
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK"%>
<%@include file="/global.jsp"%>
<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*"%>
<%
    // 贷款申请序号
    String loanID = "";
    // 操作类型
    String doType = "";
    // 抵押编号
    String mortID = "";
    String recVersion = "";

    if (request.getParameter("loanID") != null)
        loanID = request.getParameter("loanID");
    if (request.getParameter("recVersion") != null)
        recVersion = request.getParameter("recVersion");

    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");
    if ("add".equalsIgnoreCase(doType)) {
        // 自动取出抵押编号
        //mortID = SeqUtil.getSeq(CcbLoanConst.MORTTYPE);
    } else {
        if (request.getParameter("mortID") != null)
            mortID = request.getParameter("mortID");
        // 初始化页面
        LNMORTINFO bean = LNMORTINFO.findFirst("where mortid='" + mortID + "'");
        if (bean != null){
            StringUtils.getLoadForm(bean,out);
        }
    }

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);

%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>权证签收</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="paperSigninRtnEdit.js"></script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();"  class="Bodydefault" >
<div id="container"> <br>
    <form id="editForm" name="editForm" >
        <fieldset >
            <legend>权证签收</legend>
            <table width="100%"  cellspacing="0" border="0">
                <!-- 操作类型 -->
                <input type="hidden" id="doType" value="<%=doType%>">
                <!-- 版本号 -->
                <input type="hidden" id="recVersion" value="<%=recVersion%>">
                <!-- 抵押登记状态 -->
                <%--<input type="hidden" id="MORTSTATUS" value="<%=CcbLoanConst.NODE_RTN_PAPER %>">--%>
                <input type="hidden" id="MORTSTATUS" value=""/>
                <!-- 业务节点 -->
                <input type="hidden" id="busiNode" value="">
                <tr>
                    <td width="20%"  nowrap="nowrap" class="lbl_right_padding">贷款申请序号</td>
                    <td width="30%"  class="data_input" ><input type="text" id="loanID" name="loanID"  value="<%=loanID%>" style="width:90% " disabled="disabled" >
                    </td>
                    <td width="20%"  nowrap="nowrap" class="lbl_right_padding">抵押编号</td>
                    <td width="30%"  class="data_input" ><input type="text" id="mortID" name="mortID"  value="<%=mortID%>" style="width:90%" disabled="disabled" >
                    </td>
                </tr>
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">权证签收日期</td>
                    <td width="30%" class="data_input"><input  name="EXP_DATA_SIGNIN_DATE"  type="text" id="EXP_PAPER_SIGNIN_DATE"  style="width:90%" onClick="WdatePicker()" fieldType="date" isNull="false">
                        <span class="red_star">*</span></td>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding"></td>
                    <td width="30%" class="data_input"> </td>
                </tr>
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">权证签收备注</td>
                    <td width="30%" colspan="3" class="data_input"><textarea rows="3" style="width:96.4%" id="EXP_PAPER_SIGNIN_REMARK" textLength="500"></textarea>
                    </td>
                </tr>
                <tr>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作人员</td>
                    <td width="30%" class="data_input"><input type="text"  value="<%=omgr.getOperatorName()%>" style="width:90%" disabled="disabled" ></td>
                    <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作时间</td>
                    <td width="30%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>" style="width:90%" disabled="disabled" ></td>
                </tr>
            </table>
        </fieldset>
        <fieldset >
            <legend>操作</legend>
            <table width="100%" class="title1"  cellspacing="0">
                <tr >
                    <td align="center" ><!--查询-->
                        <%if (doType.equals("select")) {      %>
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()" type="button" value="关闭" onClick="window.close();">
                        <%} else if (doType.equals("edit") || doType.equals("add")) {      %>
                        <!--增加，修改-->
                        <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()" type="button" value="保存" onClick="saveClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()" type="button" value="取消" onClick="window.close();">
                        <%} else if (doType.equals("delete")) {      %>
                        <!--删除-->
                        <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()" type="button" value="删除" onClick="deleteClick();">
                        <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()" type="button" value="取消" onClick="window.close();">
                        <%}      %>
                    </td>
                </tr>
            </table>
        </fieldset>
    </form>
</div>
<div id="search-result-suggestions">
    <div id="search-results"> </div>
</div>
</body>
</html>
