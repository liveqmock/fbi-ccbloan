var SQLStr;
var gWhereStr = "";
function body_resize() {
    divfd_creditraTable.style.height = document.body.clientHeight - 255 + "px";
    creditraTable.fdwidth = "1700px";
    initDBGrid("creditraTable");
    body_init(queryForm, "queryClick");
    document.getElementById("creditratingno").focus();

}

// //////��ѯ����  ��ѯ������append
function queryClick() {
    var whereStr = "";
    if (trimStr(document.all["creditratingno"].value) != "")
        whereStr += " and ( creditratingno like '" + document.all.creditratingno.value + "%')";
    if (trimStr(document.all["idno"].value) != "") {
        var idnoStr = document.all.idno.value;
        if (idnoStr.length == 18) {
            var id1 = idnoStr.substr(0, 6);
            var id2 = idnoStr.substr(8, 9);
            var idnoStr2 = id1 + id2;
            whereStr += " and ( idno like '%" + document.all.idno.value + "%') or ( idno like '%" + idnoStr2 + "%')";
        } else {
            whereStr += " and ( idno like '%" + document.all.idno.value + "%')";
        }
    }
    if (trimStr(document.all["custname"].value) != "")
        whereStr += " and ( custname like '%" + document.all.custname.value + "%')";
    if (trimStr(document.all["judgedeptid"].value) != "")
        whereStr += " and ( judgedeptid like '%" + document.all.judgedeptid.value + "%')";
    if (trimStr(document.all["judgeoperid"].value) != "")
        whereStr += " and ( judgeoperid like '%" + document.all.judgeoperid.value + "%')";
    if (trimStr(document.all["judgetype"].value) != "")
        whereStr += " and ( judgetype like '%" + document.all.judgetype.value + "%')";
    if (trimStr(document.all["queryDateBeg"].value) != "")
        whereStr += " and ( to_char(begdate,'yyyy-mm-dd') >= '" + document.all.queryDateBeg.value + "')";
    if (trimStr(document.all["queryDateEnd"].value) != "")
        whereStr += " and ( to_char(begdate,'yyyy-mm-dd') <= '" + document.all.queryDateEnd.value + "') ";
    if (whereStr != document.all["creditraTable"].whereStr) {
        document.all["creditraTable"].whereStr = whereStr + " order by judgedate desc ";
        document.all["creditraTable"].RecordCount = "0";
        document.all["creditraTable"].AbsolutePage = "1";
        Table_Refresh("creditraTable"); //ˢ�±�������
    }
}

/**
 * ������������������ɺ󽹵��Զ���λ�����������һ�������У� ����ȫѡ��;
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
    if (trimStr(document.getElementById("custname").value) != "") {
        whereStr += " and ((a.custname like'" + trimStr(document.getElementById("custname").value) + "%')";
        whereStr += " or (a.cust_py  like'" + trimStr(document.getElementById("custname").value) + "%'))";
    }
    whereStr += " order by a.cust_py asc";
    document.all["creditraTable"].whereStr = whereStr;
    document.all["creditraTable"].RecordCount = "0";
    document.all["creditraTable"].AbsolutePage = "1";
    Table_Refresh("creditraTable", false, body_resize);
}

/**
 * �鿴�ͻ��б���ϸ��Ϣ
 */
function creditraTable_query_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var pkid = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        pkid = tmp[0];
    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/creditrating/uncomcreditEdit.jsp?pkid=" + pkid + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function creditraTable_TRDbclick() {
    creditraTable_query_click();
}

/**
 * �����Ϣ
 */
function creditraTable_insertRecord_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var pkid = "";
    var arg = new Object();
    arg.doType = "add";  // �������ͣ�add
    arg.pkid = "";
    var ret = dialog("/UI/ccb/loan/creditrating/uncomcreditEdit.jsp?pkid=" + pkid + "&doType=add", arg, sfeature);
    if (ret == "1") {
        document.getElementById("creditraTable").RecordCount = "0";
        Table_Refresh("creditraTable", false, body_resize);
    }
}


/**
 * ׷����Ϣ
 */
function creditraTable_appendRecord_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var appendNo = "";
    var creatingType = "";
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        appendNo = tmp[1];
        creatingType = tmp[5];
    }

    if (creatingType != "��������") {
        alert("��֧�֣�");
        return;
    }
    var arg = new Object();
    arg.doType = "append";  // �������ͣ�add
    arg.creditratingno = "";
    var ret = dialog("/UI/ccb/loan/creditrating/uncomcreditEdit.jsp?appendNo=" + appendNo + "&doType=append", arg, sfeature);
    if (ret == "1") {
        document.getElementById("creditraTable").RecordCount = "0";
        Table_Refresh("creditraTable", false, body_resize);
    }
}

/**
 * �༭��Ϣ
 */
function creditraTable_editRecord_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var pkid = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        pkid = tmp[0];
    }
    var arg = new Object();
    arg.doType = "edit";  // �������ͣ�edit
    arg.proj_no = pkid;
    var ret = dialog("/UI/ccb/loan/creditrating/uncomcreditEdit.jsp?pkid=" + pkid + "&doType=edit", arg, sfeature);
    if (ret == "1") {
        document.getElementById("creditraTable").RecordCount = "0";
        Table_Refresh("creditraTable", false, body_resize);
    }
}


/**
 * ���
 */
function creditraTable_uncCheck_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var pkid = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        pkid = tmp[0];
    }
    var arg = new Object();
    arg.doType = "check";  // �������ͣ�edit
    arg.proj_no = pkid;
    var ret = dialog("/UI/ccb/loan/creditrating/uncomcreditEdit.jsp?pkid=" + pkid + "&doType=edit", arg, sfeature);
    if (ret == "1") {
        document.getElementById("creditraTable").RecordCount = "0";
        Table_Refresh("creditraTable", false, body_resize);
    }
}

/**
 * ɾ������
 */
function creditraTable_deleteRecord_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var idno = "";
    var pkid = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        pkid = tmp[0];
        idno = tmp[3];
    }

    if (confirm("ȷ��ɾ��������Ϣ��\r\n֤�����룺" + idno)) {
        document.getElementById("busiNode").value = BUSINODE_190;
        document.all.pkid.value = pkid;
        var retxml = createExecuteform(queryForm, "delete", "crdt01", "deleteUncomcredit");
        if (analyzeReturnXML(retxml) != "false") {
            alert(MSG_DEL_SUCCESS);
            document.getElementById("creditraTable").RecordCount = "0";
            Table_Refresh("creditraTable", false, body_resize);
        }
    }
}

//�������
function creditraTable_barCodeManage_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];
    var pkid = "";
    var opername = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        pkid = tmp[0];
        opername = tmp[18];
    }
    window.open('/servlet/UnCommonTiaoXMServlet?pkid=' + pkid + '&opername=' + opername, null, null);

}

