<!--
/*********************************************************************
* 功能描述: 条形码编辑
* 修改人: nanmeiying
* 修改日期: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.utils.BusinessDate" %>
<%@page import="pub.platform.utils.StringUtils" %>
<%@ page import="com.ccb.dao.LNSPCLBUSCUST" %>
<%
    String custno = "";  //客户号
    String doType = "";   // 操作类型
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();
    if (request.getParameter("custno") != null) {
        custno = request.getParameter("custno");
    }
    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

    LNSPCLBUSCUST lnspclbuscust = new LNSPCLBUSCUST();
    String operName = "";
    String operid="";
    String mobilephone="";
    if (custno != null) {
        lnspclbuscust = LNSPCLBUSCUST.findFirst("where custno='" + custno + "'");

        if (lnspclbuscust != null) {
            RecordSet rs = dc.executeQuery("select opername,operid,mobilephone from ptoper where operid = '" + lnspclbuscust.getOperid() + "'");
            if (rs.next()) {
                operName = rs.getString("opername");
                operid=rs.getString("operid");
                mobilephone= rs.getString("mobilephone");
            }
            StringUtils.getLoadForm(lnspclbuscust, out);
        }

    }
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>条形码编辑</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="spclBusBarCodeEdit.js"></script>
    <script type="text/javascript" language="javascript">
        document.onkeydown = function TabReplace() {
            if (event.keyCode == 13) {
                if (event.srcElement.tagName != 'BUTTON')
                    event.keyCode = 9;
                else{
                    event.srcElement.click();
                }
            }
     }
    </script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();" class="Bodydefault">
<form id="editForm" name="editForm">
    <!-- 合作项目状态 -->
    <input type="hidden" id="MYPROJSTATUS">
    <br>
    <fieldset>
        <legend>基本信息</legend>
        <table width="100%" cellspacing="0" border="0">
            <!-- 操作类型 -->
            <input type="hidden" id="doType" value="<%=doType%>">
            <!-- 版本号 -->
            <input type="hidden" id="recVersion" value="">
            <!-- 系统日志使用 -->
            <input type="hidden" id="busiNode"/>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">业务流水号</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custno" name="custno" value="" textLength="200"
                           style="width:90%"
                           disabled="disabled">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">申请人名称</td>
                <td width="30%" class="data_input">
                    <input type="text" id="custname" name="custname" value="" textLength="200" style="width:90%" disabled="disabled">
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">贷款种类</td>
                <td width="30%" class="data_input">
                    <input type="text" id="inioperid" name="inioperid" value="" textLength="200"
                           style="width:90% " disabled="disabled">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">申请业务种类</td>
                <td width="30%" class="data_input">
                    <%
                        ZtSelect zs = new ZtSelect("bustype", " ", "");
                        zs.setSqlString("select EnuItemValue as value,EnuItemLabel as text from ptEnuDetail where EnuType = 'SPCLBUSTYPE' order by EnuItemValue");
                        zs.addAttr("style", "width: 90%");
                        zs.addAttr("fieldType", "text");
                        zs.addAttr("isNull", "false");
                        zs.addAttr("disabled", "disabled");
                        zs.addOption("", "");
                        out.print(zs);
                    %>
                </td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">客户经理姓名</td>
                <input id="" name="opername" value="<%=operName%>" type="hidden" value=""/>
                <td width="30%" class="data_input">
                    <input type="text"  value="<%=operid%>" textLength="200"
                           style="width:90% "
                           disabled="disabled">

                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">客户经理联系电话</td>
                <td width="30%" class="data_input">
                    <input type="text" value="<%=mobilephone%>" textLength="200"
                           style="width:90% "
                           disabled="disabled">

                </td>
            </tr>

        </table>
    </fieldset>
    <br>
    <fieldset>
        <legend>操作信息</legend>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作人员</td>
                <td width="30%" class="data_input">
                    <input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%" disabled="disabled">
                </td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作时间</td>
                <td width="30%" class="data_input">
                    <input type="text" value="<%=BusinessDate.getToday() %>" style="width:90%" disabled="disabled">
                </td>
            </tr>
        </table>
    </fieldset>
    <br>
    <fieldset>
        <legend>操作</legend>
        <table width="100%" class="title1" cellspacing="0">
            <tr>
                <td align="center">
                    <% if (doType.equals("edit")) { %>   <!--增加，修改-->
                    <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="保存" onclick="saveClick();">
                    <button id="outputReport"
                            onclick="window.open('${pageContext.request.contextPath}/servlet/SpclBusBarCodeXMServlet?custno=<%=custno%>' +'&opername=<%=operName%>'+'&mobilephone=<%=mobilephone%>',null,null);">
                        输出条形码
                    </button>
                    <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                           onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;"
                           onclick="window.close();">
                    <%} %>  <!--删除-->
                </td>
            </tr>
        </table>
    </fieldset>
    <br>
</form>
</body>
</html>
