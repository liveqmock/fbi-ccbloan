var SQLStr;
var gWhereStr = "";
var dw_form;

/**
 * 初始化form函数
 */
function body_resize() {
    divfd_mainTab.style.height = document.body.clientHeight - 210;
    mainTab.fdwidth = "100%";
//    mainTab.fdwidth = "1280px";
    mainTab.actionname = "com.ccb.mortgage.MortLimitAction";
    mainTab.delmethodname = "batchEdit";
    initDBGrid("mainTab");
    //初始化页面焦点
    body_init(queryForm, "cbRetrieve");
    //生成数据窗口校验使用
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}


function cbRetrieve_Click(formname) {
    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false")
        return;

    var whereStr = "";
    if (trimStr(document.getElementById("cust_name").value) != "") {
        whereStr += " and ((a.cust_name like'" + trimStr(document.getElementById("cust_name").value) + "%')";
        whereStr += " or (a.cust_py  like'" + trimStr(document.getElementById("cust_name").value) + "%'))";
    }

    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and a.bankid in(select deptid from ptdept start with deptid='" + document.getElementById("bankid").value + "' connect by prior deptid=parentdeptid) ";
    }
    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }else{
        if (trimStr(document.getElementById("ploanProxyDept").value) == "1") {
            whereStr +=  " and b.mortecentercd in (select mortecentercd from LN_MORTCENTER_APPT where deptid='" + document.getElementById("user_deptid").value +"' and typeflag='0') ";
        }
    }

    if (trimStr(document.getElementById("proj_name_abbr").value) != "") {
        whereStr += " and a.proj_name_abbr like '%" + document.getElementById("proj_name_abbr").value + "%' ";
    }

    /**
     * 只允许抵押流转状态为“已登记资料(10)”的选择“抵押登记(10)”选项，只允许抵押流转状态为“权证已入库(30)”或“已借证取证(40)”的可选择“预转现、变更借款人、变更地址、其他原因改证出库”选项
     * 20130701 仲景：只允许抵押流转状态为“已登记资料(10)”或“抵押材料签收（20A）”的选择“抵押登记(10)”选项，只允许抵押流转状态为“已借证取证(40)”的可选择“预转现、变更借款人、变更地址、其他原因改证出库”选项
     */
    if (trimStr(document.getElementById("APPTBIZCODE").value) != "") {
        var bizcode = document.getElementById("APPTBIZCODE").value;
        if (bizcode == "10") { //业务类型：抵押登记
            //whereStr += " and b.mortstatus = '10'";
            whereStr += " and (b.mortstatus = '10' or b.mortstatus = '20A')";  //抵押流程状态
        } else {
            //whereStr += " and (b.mortstatus = '30' or b.mortstatus = '40')";
            whereStr += " and  b.mortstatus = '40' ";
        }
    }

    whereStr += " order by b.mortecentercd, a.bankid, b.mortid ";
    document.all["mainTab"].whereStr = whereStr;
    document.all["mainTab"].RecordCount = "0";
    document.all["mainTab"].AbsolutePage = "1";

    document.getElementById("apptbizcode_tmp").value = document.getElementById("APPTBIZCODE").value;
    document.getElementById("APPTBIZCODE").disabled = false;

    // Table_Refresh in dbgrid.js pack
    //Table_Refresh("mainTab", false, body_resize);
    Table_Refresh_asy("mainTab");

    var tab = document.all.mainTab;
    if (tab.rows.length > 0){
        document.getElementById("APPTBIZCODE").disabled = true;
    }
}

/**
 * 察看抵押详细函数
 *
 * @param mortid：抵押编号
 * @param doType:select
 *            操作类型
 */
function mainTab_query_click() {
    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["mainTab"];
    var trobj = tab.rows[tab.activeIndex];
    // 抵押编号
    var mortID = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        mortID = tmp[7];
        //alert(mortID);
    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/mortReg/mortgageEdit.jsp?mortID=" + mortID + "&doType=select", arg, sfeature);
}

/**
 * 双击表格弹出详细信息查看画面 调用查看函数
 */
function mainTab_TRDbclick() {
    mainTab_query_click();
}

/**
 * 察看贷款详细函数
 */
function mainTab_loanQuery_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["mainTab"];
    var trobj = tab.rows[tab.activeIndex];
    var nbxh = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        nbxh = tmp[0];

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/loanMgr/loanEdit.jsp?nbxh=" + nbxh + "&doType=select", arg, sfeature);
}

/**
 * 批量更新,后台对应action与方法名在该页面初始化的时候指定  zhanrui 20130607
 */
function mainTab_batchEdit_click() {
    // 选取数据标志
    var checked = false;
    var tab = document.all.mainTab;
    var clientNames = "";
    var count = 0;
    var mortCenterCD = "";
    for (i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            checked = true;
            count++;
            clientNames += "" + count + "." + tab.rows[i].ValueStr.split(";")[4] + " ";
            mortCenterCD = tab.rows[i].ValueStr.split(";")[1];
        }
    }
    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }
    // ---预约信息输入---
    var sfeature = "dialogwidth:800px; dialogheight:400px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var arg = {};
    arg.doType = "edit";
    arg.clientNames = clientNames;
    arg.mortCenterCD = mortCenterCD;
    arg.currAppNum = count;
    var rtn = dialog("apptApplyParamEdit.jsp?doType=edit", arg, sfeature);

    function appendOneTdIntoRow(fieldname, oldvalue) {
        _cell = document.createElement("td");
        _cell.setAttribute("fieldname", fieldname);
        _cell.style.display = "none";
        _cell.setAttribute("fieldtype", "text");
        _cell.setAttribute("oldvalue", oldvalue);
        tab.rows[i].appendChild(_cell);
    }

    if (rtn != undefined) {
        for (var i = 0; i < tab.rows.length; i++) {
            if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
                tab.rows[i].operate = "delete";
                checked = true;
                var _cell;
                appendOneTdIntoRow("limitDate", rtn.limitDate);
                appendOneTdIntoRow("mortecentercd", tab.rows[i].ValueStr.split(";")[1]);
            } else {
                tab.rows[i].operate = "";
            }
        }

        // 提交后台进行批量修改
        var retxml = postGridRecord(tab);
        if (retxml + "" == "true") {
            window.returnValue = "1";
        }
    }
    Table_Refresh("mainTab", false, body_resize);

}
