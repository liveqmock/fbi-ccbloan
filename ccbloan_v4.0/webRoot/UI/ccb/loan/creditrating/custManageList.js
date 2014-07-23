var SQLStr;
var gWhereStr = "";
function body_resize() {
    divfd_creditraTable.style.height = document.body.clientHeight - 255 + "px";
    creditraTable.fdwidth = "2280px";
    initDBGrid("creditraTable");
    body_init(queryForm, "queryClick");
    document.getElementById("custno").focus();
}

// //////��ѯ����  ��ѯ������append
function queryClick() {
    var whereStr = "";
    if (trimStr(document.all["custno"].value) != "")
        whereStr += " and ( custno like '" + document.all.custno.value + "%')";
    if (trimStr(document.all["idno"].value) != "") {
        var idnoStr = document.all.idno.value;
        if(idnoStr.length == 18){
            var id1 = idnoStr.substr(0,6);
            var id2 = idnoStr.substr(8, 9);
            var idnoStr2 = id1 + id2;
            whereStr += " and ( idno like '%" + document.all.idno.value + "%') or ( idno like '%" + idnoStr2 + "%')";
        } else{
            whereStr += " and ( idno like '%" + document.all.idno.value + "%')";
        }
    }
    if (trimStr(document.all["custname"].value) != "")
        whereStr += " and ( custname like '%" + document.all.custname.value + "%')";
    if (trimStr(document.all["deptid"].value) != "")
        whereStr += " and ( deptid like '%" + document.all.deptid.value + "%')";
    if (trimStr(document.all["operid"].value) != "")
        whereStr += " and ( operid like '%" + document.all.operid.value + "%')";
    if (trimStr(document.all["updoperid"].value) != "")
        whereStr += " and ( updoperid like '%" + document.all.updoperid.value + "%')";
    if (whereStr != document.all["creditraTable"].whereStr) {
        document.all["creditraTable"].whereStr = whereStr + " order by custno ";
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
    var custno = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        custno = tmp[0];
    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/creditrating/custManageEdit.jsp?custno=" + custno + "&doType=select", arg, sfeature);
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
function creditraTable_appendRecod_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["creditraTable"];
    var trobj = tab.rows[tab.activeIndex];

    var custno = "";
    var arg = new Object();
    arg.doType = "add";  // �������ͣ�add
    arg.custno = "";
    var ret = dialog("/UI/ccb/loan/creditrating/custManageEdit.jsp?custno=" + custno + "&doType=add", arg, sfeature);
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
    var custno = "";
    var validitytime = "";
    var validitytimetwo = "";
    var currentDate = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        custno = tmp[0];
        validitytime = tmp[27];
        validitytimetwo = tmp[29];
        currentDate = tmp[28];
    }

    if (validitytime != "") {
        if(currentDate <= validitytimetwo){
            alert("�ͻ�������(��Ч�ڽ�ֹ��" + validitytime + ")��\r\n�������ѻ��壬����ϵ���У�");
            return;
        }else if(currentDate > validitytimetwo && currentDate <= validitytime){
            alert("�ͻ�������(��Ч�ڽ�ֹ��" + validitytime + ")��\r\n��������ǰ�޸Ŀͻ����ϣ�");
        }
    }
    var arg = new Object();
    arg.doType = "edit";  // �������ͣ�edit
    arg.proj_no = custno;
    var ret = dialog("/UI/ccb/loan/creditrating/custManageEdit.jsp?custno=" + custno + "&doType=edit", arg, sfeature);
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
    var custno = "";
    var validitytime = "";
    var currentDate = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        custno = tmp[0];
        validitytime = tmp[27];
        currentDate = tmp[28];
    }

    if (validitytime != "") {
        if (currentDate <= validitytime) {
            alert("�ͻ�������(��Ч�ڽ�ֹ��" + validitytime + ")��");
            return;
        }
    }

    if (confirm("ȷ��ɾ��������Ϣ��\r\n�ͻ��ţ�" + custno)) {
        document.getElementById("busiNode").value = BUSINODE_190;
        document.all.custno.value = custno;
        var retxml = createExecuteform(queryForm, "delete", "crdt01", "delete");
        if (analyzeReturnXML(retxml) != "false") {
            alert(MSG_DEL_SUCCESS);
            document.getElementById("creditraTable").RecordCount = "0";
            Table_Refresh("creditraTable", false, body_resize);
        }
    }
}

