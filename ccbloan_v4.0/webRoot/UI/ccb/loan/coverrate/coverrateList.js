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
    divfd_deptTab.style.height = document.body.clientHeight - 180;

    deptTab.fdwidth = "100%";
    initDBGrid("deptTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
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
    if (trimStr(document.getElementById("deptid").value) != "") {
        whereStr += " and deptid = '" + trimStr(document.getElementById("deptid").value) + "'";
    }

    document.all["deptTab"].whereStr = whereStr + " order by deptid ";
    document.all["deptTab"].RecordCount = "0";
    document.all["deptTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("deptTab", false);
}

function deptTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["deptTab"];
    var trobj = tab.rows[tab.activeIndex];
    var deptid = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        deptid = tmp[0];
    }
    var arg = new Object();
    arg.doType = "edit";
    var rtn = dialog("coverrateEdit.jsp?deptid=" + deptid + "&doType=edit", arg, sfeature);
    if (rtn == "1") {
        document.getElementById("deptTab").RecordCount = "0";
        Table_Refresh("deptTab", false, body_resize);
    }
}

