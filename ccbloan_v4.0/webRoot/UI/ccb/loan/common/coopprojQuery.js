var SQLStr;
var gWhereStr = "";

/**
 * ��ʼ��form����,
 * <p>
 * ����ʼ�����㶨λ�ڲ�ѯ������һ���ؼ���;
 * <p>
 * ��ÿ�β�ѯ��Ϻ󽹵��Զ���λ����һ���ؼ�����ȫѡ��
 *
 */
function body_resize() {
    // var wheight = document.body.clientHeight - 300;
    divfd_coopprojTable.style.height = document.body.clientHeight - 265 + "px";
    coopprojTable.fdwidth = "100%";
    initDBGrid("coopprojTable");
    // ��ʼ��ҳ�潹��
    //body_init(queryForm, "cbRetrieve");
    body_init(queryForm);
    document.getElementById("proj_name_abbr").focus();
}

// ��ѯ����
function queryClick() {
    var whereStr = "";

    if (trimStr(document.all["proj_name_abbr"].value) != "")
        whereStr += " and ( proj_name_abbr like '%" + document.getElementById("proj_name_abbr").value + "%')";

    if (trimStr(document.all["bankid"].value) != ""){
        whereStr += " and bankid='"+document.getElementById("bankid").value+"'";
    }
    if (trimStr(document.all["cust_bankid"].value) != ""){
        whereStr += " and cust_bankid in(select deptid from ptdept start with deptid='"+document.getElementById("cust_bankid").value+"' connect by prior deptid=parentdeptid)";
    }

    if (trimStr(document.all["corpname"].value) != "")
        whereStr += " and ( corpname like '%" + document.all.corpname.value + "%')";

    var maturityflag = trimStr(document.all["maturityflag"].value);
    if (maturityflag != "") {
        var date = new Date();
        if (maturityflag == "1") { // �ѵ���
            whereStr += " and ( assuenddate < '" + getDateString(date) + "') ";
        } else {
            whereStr += " and ( assuenddate >= '" + getDateString(date) + "') ";
        }
    }

    if (trimStr(document.all["proj_name"].value) != "")
        whereStr += " and ( proj_name like '%" + document.all.proj_name.value + "%')";

    if (whereStr != document.all["coopprojTable"].whereStr) {
        document.all["coopprojTable"].whereStr = whereStr + " order by proj_no ";
        document.all["coopprojTable"].RecordCount = "0";
        document.all["coopprojTable"].AbsolutePage = "1";
        Table_Refresh("coopprojTable");
    }
}

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
    whereStr += " order by a.cust_py asc";

    document.all["coopprojTable"].whereStr = whereStr;
    document.all["coopprojTable"].RecordCount = "0";
    document.all["coopprojTable"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("coopprojTable", false, body_resize);
}

/**
 * �鿴������Ŀ��ϸ��Ϣ
 */
function coopprojTable_query_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:620px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["coopprojTable"];
    var trobj = tab.rows[tab.activeIndex];
    var proj_nbxh = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        proj_nbxh = tmp[0];
        // alert(proj_no);

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/coopprojMgr/coopprojEdit.jsp?proj_nbxh=" + proj_nbxh + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function coopprojTable_TRDbclick() {
    //coopprojTable_query_click();
    var tab = document.all["coopprojTable"];
    var trobj = tab.rows[tab.activeIndex];
    var proj_no = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        proj_no = tmp[1];
    }

    window.returnValue = proj_no;
    window.close();
}

