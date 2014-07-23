var SQLStr;
var gWhereStr = "";

document.onkeydown = function (evt) {
    var key = event.keyCode;
    var srcobj = event.srcElement;
    if (key == 13 && srcobj.type != 'button' && srcobj.type != 'submit' && srcobj.type != 'reset'
        && srcobj.type != 'textarea' && srcobj.type != '') {
        if (srcobj.id == "FLOWSN") {
            var searchResult = onSearchArchiveInfo();
            if (searchResult != -1) {
                addMortInfoByArchiveInfo(searchResult);
            }
        }
    }
}

function onSearchArchiveInfo() {
    // ����ϵͳ�����
    /*if (getSysLockStatus() == "1") {
     alert(MSG_SYSLOCK);
     return;
     }*/

    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    if (flowsn == "") {
        alert('��������ˮ��.');
        return -1;
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\��]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    //����Ƿ���������Ѻ���� TODO
    var retxml = createselect(queryForm, "com.ccb.flowmng.SelectMortIDAction");
    if (retxml == "false") {
        alert("�˴������ϲ����ڡ�");
        return -1;
    }
    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null) {
        if (rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
            return (rootNode.firstChild.xml);
        } else {
            alert("�˴������ϻ�û������Ѻ�Ǽǡ�");
            return -1;
        }
    } else {
        alert("�˴������ϲ����ڡ�");
        return -1;
    }

    //��ȡmortId
//    retxml = createselect(queryForm, "com.ccb.flowmng.SelectMortIDAction");
//    if (retxml == "false") {
//        alert("�˴������ϲ����ڡ�");
//        return -1;
//    }
//    xmlDoc = createDomDocument();
//    xmlDoc.loadXML(retxml);
//    rootNode = xmlDoc.documentElement.firstChild;
//    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
//        return(rootNode.firstChild.xml);
//    } else {
//        alert("�˴������ϲ����ڻ�δ�����������˳���...");
//        return -1;
//    }
}

function addMortInfoByArchiveInfo(mortID) {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:600px; dialogheight:360px;center:yes;help:no;resizable:yes;scroll:no;status:no";

    var arg = new Object();
    // �������ͣ�add
    arg.doType = "edit";
    // ��Ѻ���
    arg.mortID = mortID;
    arg.flowSn = trimStr(document.getElementById("FLOWSN").value);
    var ret = dialog("otherBankNoMortEdit.jsp?mortID=" + mortID + "&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanRegistedTab").RecordCount = "0";
        Table_Refresh("loanRegistedTab", false, body_resize);
    }

}
/**
 * ��ʼ��form����,
 * <p>
 * ����ʼ�����㶨λ�ڲ�ѯ������һ���ؼ���;
 * <p>
 * ��ÿ�β�ѯ��Ϻ󽹵��Զ���λ����һ���ؼ�����ȫѡ��
 *
 */
function body_resize() {
    divfd_loanRegistedTab.style.height = document.body.clientHeight - 180;
    loanRegistedTab.fdwidth="1200px";
    
    initDBGrid("loanRegistedTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    document.getElementById("FLOWSN").focus();
    document.getElementById("FLOWSN").select();
//    document.getElementById("cust_name").focus();
//    document.getElementById("cust_name").select();
}

/**
 * <p>
 * ������������������ɺ󽹵��Զ���λ�����������һ�������У� ����ȫѡ��;
 * <p>
 * ��ϵͳ��������������ĺ��ֻ���ƴ����ѯ ������ƴ����ѯ�ǡ�or���Ĺ�ϵ;
 * <p>
 * ��������ƴ����֧��ǰ��һ�¡����ģ����ѯ��
 * <p>
 * �����»س����Զ�֧�ֲ�ѯ��
 * </p>
 * ��ϵͳ��Ϊ1��ʱ��ϵͳ������0��ʱ��δ����
 * @param ��form���ֻ���ID
 */

function cbRetrieve_Click(formname) {
    // ����ϵͳ�����
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

    if (trimStr(document.getElementById("FLOWSN").value) != "") {
        whereStr += " and a.loanId = (select loanid from ln_archive_info where flowsn ='" + trimStr(document.getElementById("FLOWSN").value) + "') ";
    }

    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }
    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and a.bankid in(select deptid from ptdept start with deptid='"+document.getElementById("bankid").value+"' connect by prior deptid=parentdeptid)";
    }

    whereStr += " order by b.mortecentercd, a.bankid, b.mortid ";
    document.all["loanRegistedTab"].whereStr = whereStr;

/*
    whereStr += " order by a.cust_py asc";
    document.all["loanRegistedTab"].whereStr = whereStr;
    */
    document.all["loanRegistedTab"].RecordCount = "0";
    document.all["loanRegistedTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanRegistedTab", false, body_resize);
}

/**
 * �쿴��Ѻ��ϸ����
 *
 * @param mortid����Ѻ���
 * @param doType:select
 *          ��������
 */
function loanRegistedTab_query_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["loanRegistedTab"];
    var trobj = tab.rows[tab.activeIndex];
    // ��Ѻ���
    var mortID = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        mortID = tmp[5];

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/mortReg/mortgageEdit.jsp?mortID=" + mortID + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 * @return ��
 */
function loanRegistedTab_TRDbclick() {
    loanRegistedTab_query_click();
}


/**
 * �༭��Ѻ����ǰ ���п�����δ����Ѻ���Ͻ��ӱ�־
 *
 * @param doType:��������
 *          �޸� edit
 * @param mortid:��Ѻ���
 */
function loanRegistedTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:600px; dialogheight:320px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanRegistedTab"];
    var trobj = tab.rows[tab.activeIndex];

    var mortID = "";
    var bankflag = ""; //���������� 1���� 2����
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        mortID = tmp[5];
        bankflag = tmp[10];
    }
    var arg = new Object();
    // �������ͣ�edit
    arg.doType = "edit";
    // ��Ѻ���
    arg.mortID = mortID;
    //����������
    arg.bankflag = bankflag;
    var ret = dialog("otherBankNoMortEdit.jsp?mortID=" + mortID + "&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanRegistedTab").RecordCount = "0";
        Table_Refresh("loanRegistedTab", false, body_resize);
    }
}
/**
 * �쿴������ϸ����
 *
 * @param loanID�������������
 * @param doType:select
 *          ��������
 */
function loanRegistedTab_loanQuery_click() {

    //����ϵͳ�����
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
        nbxh = tmp[9];

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/loanMgr/loanEdit.jsp?nbxh=" + nbxh + "&doType=select", arg, sfeature);
}