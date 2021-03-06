<!--
/*********************************************************************
* 功能描述: 买单工资查询统计项目表11
* 作 者: leonwoo
* 开发日期: 2010/01/16
* 修 改 人:
* 修改日期:
* 版 权: 公司
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="appRpt.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <style type="text/css">
        .queryPanalDiv {
            width: 100%;
            margin: 5px auto;
            padding: 2px, 20px, 2px, 20px;
            text-align: center; /*border: 1px #1E7ACE solid;*/
        }

        .queryDiv {
            width: 90%;
            margin: 0px auto;
            padding: 2px, 1px, 1px, 1px;
            text-align: center; /*border: 1px #1E7ACE solid;*/
        }

        .queryButtonDiv {
            width: 100%;
            margin: 5px auto;
            padding: 10px, 5px, 2px, 2px;
            text-align: center; /*border: 1px #1E7ACE solid;*/
        }
    </style>
</head>
<body onLoad="payBillInit()" bgcolor="#ffffff" class="Bodydefault">

<br>

<div class="queryPanalDiv">
    <fieldset style="padding-top:30px;padding-bottom:0px;margin-top:0px">
        <legend>查询条件</legend>
        <form id="queryForm" name="queryForm">
            <div class="queryDiv">
                <table border="0" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <td width="40%" nowrap="nowrap" class="lbl_right_padding">统计起始日期</td>
                        <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE"
                                                                                  name="MORTEXPIREDATE" onClick="WdatePicker()"
                                                                                  fieldType="date" size="20%"></td>
                    </tr>
                    <tr>
                        <td width="40%" nowrap="nowrap" class="lbl_right_padding">统计截止日期</td>
                        <td width="60%" nowrap="nowrap" class="data_input"><input type="text" id="MORTEXPIREDATE2"
                                                                                  name="MORTEXPIREDATE2" onClick="WdatePicker()"
                                                                                  fieldType="date" size="20%"></td>
                    </tr>
                </table>
            </div>
            <div class="queryButtonDiv">
                <table>
                    <tr>
                        <td colspan="8" nowrap="nowrap" align="right"><input name="expExcel"
                                                                             class="buttonGrooveDisableExcel"
                                                                             type="button" id="button"
                                                                             onClick="loanTab_expExcelOver_click()"
                                                                             value="导出超批复excel">
                        <td colspan="8" nowrap="nowrap" align="right"><input name="expExcel"
                                                                             class="buttonGrooveDisableExcel"
                                                                             type="button" id="button1"
                                                                             onClick="loanTab_expExcelAll_click()"
                                                                             value="导出综合完成率excel">
                            <input class="buttonGrooveDisableExcel" name="Input" type="reset" value="重填">
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </fieldset>
</div>
<%--

<fieldset style="padding-top:30px;padding-bottom:5px;margin-top:0px">
    <legend>查询条件</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">开户日期起</td>
                <td width="14%" nowrap="nowrap" class="data_input"><input type="text" id="CUST_OPEN_DT"
                                                                          name="CUST_OPEN_DT" onClick="WdatePicker()"
                                                                          fieldType="date" size="15"></td>
                <td width="2%" nowrap="nowrap" class="lbl_right_padding">至</td>
                <td width="14%" nowrap="nowrap" class="data_input" colspan="5"><input type="text" id="CUST_OPEN_DT2"
                                                                                      name="CUST_OPEN_DT2"
                                                                                      onClick="WdatePicker()"
                                                                                      fieldType="date" size="15"></td>
            </tr>
            <tr>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">个人住房贷款执行利率水平</td>
                <td width="30%" nowrap="nowrap" class="data_input" colspan="3"><input type="text" id="INTERATE"
                                                                                      name="INTERATE" isNull="false"
                                                                                      value="0.75"/><span
                        class="red_star">*</span></td>
                <td width="20%" nowrap="nowrap" class="lbl_right_padding">个人类其他贷款执行利率水平</td>
                <td width="30%" nowrap="nowrap" class="data_input" colspan="3"><input type="text" id="INTERATE2"
                                                                                      name="INTERATE2" isNull="false"
                                                                                      value="1.1"/><span
                        class="red_star">*</span></td>
            </tr>
            <tr>
                <td colspan="8" nowrap="nowrap" align="right"><input name="expExcel" class="buttonGrooveDisableExcel"
                                                                     type="button" id="button"
                                                                     onClick="loanTab_expExcel_click()" value="导出excel">
                    <input class="buttonGrooveDisable" name="Input" type="reset" value="重填">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
--%>
</body>
</html>
