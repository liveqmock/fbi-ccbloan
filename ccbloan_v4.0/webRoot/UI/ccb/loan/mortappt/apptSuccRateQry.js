var SQLStr;
var gWhereStr = "";
var dw_form;

/**
 * ��ʼ��form����
 */
function body_resize() {
    divfd_mainTab.style.height = document.body.clientHeight - 300;
    divfd_bankTab.style.height = document.body.clientHeight - 220;
    mainTab.fdwidth = '100%';
    bankTab.fdwidth = '100%';
    initDBGrid("mainTab");
    //initDBGrid("sumTab");
    //��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    //�������ݴ���У��ʹ��
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}


function cbRetrieve_Click(formname) {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false")
        return;

    var sql1 = document.getElementById("tab1Sql").value;
    sql1 = sql1.replace("{startDate}", document.getElementById("STARTDATE").value);
    sql1 = sql1.replace("{endDate}", document.getElementById("ENDDATE").value);
    document.getElementById("mainTab").SQLStr = sql1;
    document.all["mainTab"].RecordCount = "0";
    document.all["mainTab"].AbsolutePage = "1";
    Table_Refresh_asy("mainTab");

    var sql2 = document.getElementById("tab2Sql").value;
    sql2 = sql2.replace("{startDate}", document.getElementById("STARTDATE").value);
    sql2 = sql2.replace("{endDate}", document.getElementById("ENDDATE").value);
    document.getElementById("bankTab").SQLStr = sql2;
    document.all["bankTab"].RecordCount = "0";
    document.all["bankTab"].AbsolutePage = "1";
    Table_Refresh_asy("bankTab");
}

function getWhereString_oper_str(tableName, dbFieldName, operator, uiFieldName) {
    if (trimStr(document.getElementById(uiFieldName).value) != "") {
        return  " and " + tableName + "." + dbFieldName + operator + "'" + trimStr(document.getElementById(uiFieldName).value) + "'";
    } else {
        return "";
    }
}

/**
 * �쿴��Ѻ��ϸ����
 *
 * @param mortid����Ѻ���
 * @param doType:select
 *            ��������
 */
function mainTab_query_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["mainTab"];
    var trobj = tab.rows[tab.activeIndex];
    // ��Ѻ���
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
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 */
function mainTab_TRDbclick() {
    mainTab_query_click();
}

/**
 * �쿴������ϸ����
 */
function mainTab_loanQuery_click() {

    // ����ϵͳ�����
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

