var SQLStr;
var gWhereStr = "";
function body_resize() {
    divfd_creditraTable.style.height = document.body.clientHeight - 255 + "px";
    creditraTable.fdwidth = "100%";
    initDBGrid("creditraTable");
    body_init(queryForm, "queryClick");
    document.getElementById("creditratingno").focus();

}

// //////��ѯ����  ��ѯ������append
function queryClick() {
    var whereStr = "";
    if (trimStr(document.all["creditratingno"].value) != "")
        whereStr += " and ( creditratingno like '" + document.all.creditratingno.value + "%')";
    if (trimStr(document.all["opername"].value) != "")
        whereStr += " and ( opername like '%" + document.all.opername.value + "%')";
    if (trimStr(document.all["creattype"].value) != "")
        whereStr += " and ( creattype = '" + document.all.creattype.value + "')";
    if (whereStr != document.all["creditraTable"].whereStr) {
        document.all["creditraTable"].whereStr = whereStr + " order by opertime desc ";
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
    if (trimStr(document.getElementById("opername").value) != "") {
        whereStr += " and ((a.opername like'" + trimStr(document.getElementById("opername").value) + "%')";
        whereStr += " or (a.cust_py  like'" + trimStr(document.getElementById("opername").value) + "%'))";
    }
    whereStr += " order by a.cust_py asc";
    document.all["creditraTable"].whereStr = whereStr;
    document.all["creditraTable"].RecordCount = "0";
    document.all["creditraTable"].AbsolutePage = "1";
    Table_Refresh("creditraTable", false, body_resize);
}


