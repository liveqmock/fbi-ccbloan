var SQLStr;
var gWhereStr = "";
var dw_form;

document.onkeydown = function (evt) {
    var key = event.keyCode;
    var srcobj = event.srcElement;
    if (key == 13 && srcobj.type != 'button' && srcobj.type != 'submit' && srcobj.type != 'reset'
        && srcobj.type != 'textarea' && srcobj.type != '') {
        if (srcobj.id == "FLOWSN") {
            var searchResult = onSearchLoanInfo();
            if (searchResult != -1) {
                editLoanInfo();
            } else {
                searchResult = onSearchArchiveInfo();
                if(searchResult !=-1){
                    addMortInfoByArchiveInfo();
                }
            }
        }
    }
}

function onSearchLoanInfo() {
    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    if (flowsn == "") {
        alert('请输入流水号.');
        return -1;
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\￥]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    //检查是否已做过抵押处理 TODO
    var retxml = createselect(queryForm, "com.ccb.flowmng.SelectLoanIDFlowsnAction");
    if (retxml == "false") {
        alert("此资料不存在。");
        return -1;
    }

    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return(rootNode.firstChild.xml);
    } else {
        return -1;
    }
}

function onSearchArchiveInfo() {
    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    if (flowsn == "") {
        alert('请输入流水号.');
        return -1;
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\￥]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    //获取loanid
    var retxml = createselect(queryForm, "com.ccb.flowmng.SelectLoanIDAction");
    if (retxml == "false") {
        alert("此贷款资料不存在。");
        return -1;
    }
    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return(rootNode.firstChild.xml);
    } else {
        alert("无此流水号明细记录...");
        return -1;
    }
}

/**
 * 初始化form函数,
 * <p>
 * ■初始化焦点定位在查询条件第一个控件上;
 * <p>
 * ■每次查询完毕后焦点自动定位到第一个控件，且全选；
 * 
 */
function body_resize() {
    divfd_loanRegistedTab.style.height = document.body.clientHeight - 180;
    loanRegistedTab.fdwidth = "100%";
    loanRegistedTab.actionname = "mort01";
    loanRegistedTab.delmethodname = "batchEdit";
    initDBGrid("loanRegistedTab");
    // 初始化页面焦点
    body_init(queryForm, "cbRetrieve");
    document.getElementById("cust_name").focus();
    document.getElementById("cust_name").select();
    // 生成数据窗口校验使用
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}

/**
 * <p>
 * ■检索函数，检索完成后焦点自动定位到检索区域第一个条件中， 并且全选中;
 * <p>
 * ■系统根据姓名处输入的汉字或者拼音查询 汉字与拼音查询是“or”的关系;
 * <p>
 * ■汉字与拼音都支持前端一致、后端模糊查询；
 * <p>
 * ■按下回车键自动支持查询；
 * </p>
 * ■系统锁为1的时候，系统锁定，0的时候未锁定
 * 
 * @param ：form名字或者ID
 */

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

    //项目简称
    if (trimStr(document.getElementById("proj_name").value) != "") {
        whereStr += " and a.proj_no in ( select proj_no from ln_coopproj where proj_name like '%" + trimStr(document.getElementById("proj_name").value) + "%')";
    }
    //放款方式
    if (trimStr(document.getElementById("releasecondcd").value) != "") {
        whereStr += " and b.RELEASECONDCD ='" + trimStr(document.getElementById("releasecondcd").value) + "' ";
    }
    //抵押柜号
    if (trimStr(document.getElementById("boxid").value) != "") {
        whereStr += " and b.boxid ='"+  trimStr(document.getElementById("boxid").value)+ "' ";
    }
    //业务流水号
    if (trimStr(document.getElementById("FLOWSN").value) != "") {
        whereStr += " and a.loanId = (select loanid from ln_archive_info where flowsn ='" + trimStr(document.getElementById("FLOWSN").value) + "') ";
    }

    //抵押编号
    if (trimStr(document.getElementById("mortid").value) != "") {
        whereStr += " and b.mortid ='" + trimStr(document.getElementById("mortid").value) + "' ";
    }

    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }
    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and a.bankid in(select deptid from ptdept start with deptid='"+document.getElementById("bankid").value+"' connect by prior deptid=parentdeptid)";
    }

    whereStr += " order by b.mortecentercd, a.bankid, b.mortid ";
    document.all["loanRegistedTab"].whereStr = whereStr;

    document.all["loanRegistedTab"].RecordCount = "0";
    document.all["loanRegistedTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanRegistedTab", false, body_resize);
}

/**
 * 察看抵押详细函数
 * 
 * @param mortid：抵押编号
 * @param doType:select
 *            操作类型
 */
function loanRegistedTab_query_click() {
    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["loanRegistedTab"];
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

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/mortReg/mortgageEdit.jsp?mortID=" + mortID + "&doType=select", arg, sfeature);
}

/**
 * 双击表格弹出详细信息查看画面 调用查看函数
 * 
 */
function loanRegistedTab_TRDbclick() {
    loanRegistedTab_query_click();
}

/**
 * 编辑抵押办妥前快递登记信息
 * 
 * @param doType:操作类型
 *            修改 edit
 * @param mortid:抵押编号
 */
function loanRegistedTab_editRecord_click() {
    // 选取数据标志
    var checked = false;
    var sfeature = "dialogwidth:600px; dialogheight:320px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanRegistedTab"];
    var trobj = tab.rows[tab.activeIndex];

//    var mortID = "";

    var clientNames = "";
    var strMortid = "";
    var count = 0;
    var recVersion = "";
    var strBoxid = "";
    for (var i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            tab.rows[i].operate = "edit";
            checked = true;
            count++;
            clientNames += "" + count + "." + tab.rows[i].ValueStr.split(";")[4] + " ";
            strBoxid += "" + count + "." + tab.rows[i].ValueStr.split(";")[8] + " ";
            recVersion = tab.rows[i].ValueStr.split(";")[10];
            if (strMortid==""){
                strMortid ="'"+tab.rows[i].ValueStr.split(";")[7] + "'";
            }else{
                strMortid +=",'"+tab.rows[i].ValueStr.split(";")[7] + "'";
            }
        } else {
            tab.rows[i].operate = "";
        }
    }

    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }

    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

//    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
//        var tmp = trobj.ValueStr.split(";");
//        mortID = tmp[7];
//    }
    var arg = new Object();
    // 操作类型：edit
    arg.doType = "edit";
    // 抵押编号
    arg.strMortid = strMortid;
    arg.clientNames = clientNames;
    arg.strBoxid = strBoxid;

    var ret = dialog("mortBoxEdit.jsp?clientNames=" + clientNames + "&strMortid="+ strMortid +"&recVersion="+recVersion+"&strBoxid="+strBoxid+"&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanRegistedTab").RecordCount = "0";
        Table_Refresh("loanRegistedTab", false, body_resize);
    }
}

/**
 * 察看贷款详细函数
 * 
 * @param loanID：贷款申请序号
 * @param doType:select
 *            操作类型
 */
function loanRegistedTab_loanQuery_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["loanRegistedTab"];
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
 * 批量更新,后台对应action与方法名在该页面初始化的时候指定
 * 
 */
function loanRegistedTab_batchEdit_click() {

    // 选取数据标志
    var checked = false;
    var sfeature = "dialogwidth:600px; dialogheight:320px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanRegistedTab"];
    var trobj = tab.rows[tab.activeIndex];

//    var mortID = "";

    var clientNames = "";
    var strMortid = "";
    var count = 0;
    var recVersion = "";
    var strBoxid = "";

    for (var i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            tab.rows[i].operate = "batchedit";
            checked = true;
            count++;
            clientNames += "" + count + "." + tab.rows[i].ValueStr.split(";")[4] + " ";
            strBoxid += "" + count + "." + tab.rows[i].ValueStr.split(";")[8] + " ";
            recVersion = tab.rows[i].ValueStr.split(";")[10];
            if (strMortid==""){
                strMortid ="'"+tab.rows[i].ValueStr.split(";")[7] + "'";
            }else{
                strMortid +=",'"+tab.rows[i].ValueStr.split(";")[7] + "'";
            }
        } else {
            tab.rows[i].operate = "";
        }
    }

    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }

    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

//    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
//        var tmp = trobj.ValueStr.split(";");
//        mortID = tmp[7];
//    }
    var arg = new Object();
    // 操作类型：edit
    arg.doType = "batchedit";
    // 抵押编号
    arg.strMortid = strMortid;
    arg.clientNames = clientNames;
    arg.strBoxid = strBoxid;

    var ret = dialog("mortBoxEdit.jsp?clientNames=" + clientNames + "&strMortid="+ strMortid +"&recVersion="+recVersion+"&strBoxid="+strBoxid+"&doType=batchedit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanRegistedTab").RecordCount = "0";
        Table_Refresh("loanRegistedTab", false, body_resize);
    }
}

/**
 * report
 * 
 */
function loanRegistedTab_expExcel_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "basicReport.jsp";
    document.getElementById("queryForm").submit();
}