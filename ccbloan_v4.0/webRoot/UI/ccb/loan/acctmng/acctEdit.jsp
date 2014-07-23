<!--
/*********************************************************************
* 功能描述: 抵押信息管理贷款详细页面
*
* 作 者: leonwoo
* 开发日期: 2010/01/16
* 修 改 人:
* 修改日期:
* 版 权: 公司
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>

<%@ page import="com.ccb.dao.*" %>
<%@ page import="com.ccb.util.*" %>

<%
    //账户编号
    String acctid = "";
    // 贷款申请序号
    String loanid = "";
    // 操作类型
    String doType = "";
    // 用户对象
    PTOPER oper = null;
    // 账户名称
    String custname = "";

    if (request.getParameter("loanid") != null){
        loanid = request.getParameter("loanid");
    }
    if (request.getParameter("doType") != null){
        doType = request.getParameter("doType");
    }
    if (request.getParameter("custname") != null){
        custname = request.getParameter("custname");
        custname = new String(custname.getBytes("ISO8859-1"),"GBK");
    }
    if (request.getParameter("acctid") != null){
        acctid = request.getParameter("acctid");
    }

    // 初始化页面
    LNACCTINFO bean = LNACCTINFO.findFirst("where acct_id='" + acctid + "'");
    if (bean != null) {
        StringUtils.getLoadForm(bean, out);
    }

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    //取出用户的姓名
    if (bean != null) {
        oper = PTOPER.findFirst("where operid='" + bean.getOperid() + "'");
    }
    if (oper == null) {
        oper = new PTOPER();
    }
%>
<html>

<head>

    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>缴款人账户信息</title>

    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="acctEdit.js"></script>


</head>
<body onload="formInit();" class="Bodydefault">

<form id="editForm" name="editForm">
<fieldset style="padding: 15px">
    <legend style="margin-bottom: 10px">基本信息</legend>
    <table width="100%" cellspacing="0" border="0">
        <input type="hidden" id="acctid" value="<%=acctid%>">
        <input type="hidden" id="doType" value="<%=doType%>">
        <input type="hidden" id="recversion" value=""/>
        <!-- 流水日志表使用 -->
        <input type="hidden" id="busiNode" name="busiNode" value=""/>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">贷款申请号</td>
            <td width="30%" class="data_input" colspan="3"><input type="text" id="LOANID" name="LOANID" value="<%=loanid%>"
                                                      intLength="24" style="width:90% " isNull="false"  disabled="disabled"><span
                    class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">委扣账户名称</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_NAME" name="ACCT_NAME" style="width:90%" value="<%=custname%>"
                                                      textLength="50" isNull="false"><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">委扣收款账号</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_NO" name="ACCT_NO" style="width:90%"
                                                      textLength="30" isNull="false"><span class="red_star">*</span>
            </td>

        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">开户银行</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_BANK" name="ACCT_BANK" style="width:90%"
                                                      textLength="50" isNull="false"><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">抵押费金额</td>
            <td width="35%" class="data_input"><input type="text" id="ACCT_AMT" name="ACCT_AMT" value=""
                                                      onblur="Txn_GotFocus(this);" style="width:90%" intLength="18"
                                                      floatLength="2"
                                                      isNull="false"><span class="red_star">*</span></td>

        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">抵押类型</td>
            <td width="35%" class="data_input">
                <%
                    ZtSelect zs;
                    zs = new ZtSelect("APPT_TYPE", "APPTTYPE", "1");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    zs.addOption("", "");
                    out.print(zs);
                %><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">备注</td>
            <td width="35%" class="data_input"><input type="text" id="REMARK" name="REMARK" value=""
                                                      style="width:90%"
                                                      intLength="100"></td>
        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">操作人员</td>
            <td width="35%" class="data_input"><input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%"
                                                      disabled="disabled"></td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">操作时间</td>
            <td width="35%" class="data_input"><input type="text" value="<%=BusinessDate.getToday() %>"
                                                      style="width:90%"
                                                      disabled="disabled"></td>
        </tr>
    </table>
</fieldset>
<fieldset>
    <legend>操作</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td align="center">
                <!--查询-->
                <%if (doType.equals("select")) { %>
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="关闭" onclick="window.close();">
                <%} else if (doType.equals("edit") || doType.equals("add")) { %>
                <!--增加，修改-->
                <input id="savebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="保存" onclick="saveClick();">
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="取消" onclick="window.close();">
                <%} else if (doType.equals("delete")) { %>
                <!--删除-->
                <input id="deletebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="删除" onclick="deleteClick();">
                <input id="closebut" class="buttonGrooveDisable" onmouseover="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="取消" onclick="window.close();">
                <%} %>
            </td>
        </tr>
    </table>
</fieldset>

</form>
</body>
</html>
