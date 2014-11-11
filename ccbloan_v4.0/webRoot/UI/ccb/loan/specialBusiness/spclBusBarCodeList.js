var SQLStr;
var gWhereStr = "";
function body_resize() {
    divfd_creditraTable.style.height = document.body.clientHeight - 255 + "px";
    creditraTable.fdwidth = "2228px";
    initDBGrid("creditraTable");
    body_init(queryForm, "queryClick");
    document.getElementById("custno").focus();

}

// //////查询函数  查询条件的append
function queryClick() {
    var whereStr = "";
    if (trimStr(document.all["custno"].value) != "")
        whereStr += " and ( custno like '" + document.all.custno.value + "%')";
    /*
    if (trimStr(document.all["custname"].value) != "") {
        var idnoStr = document.all.custname.value;
        if(idnoStr.length == 18){
            var id1 = idnoStr.substr(0,6);
            var id2 = idnoStr.substr(8, 9);
            var idnoStr2 = id1 + id2;
            whereStr += " and ( custname like '%" + document.all.custname.value + "%') or ( custname like '%" + idnoStr2 + "%')";
        } else{
            whereStr += " and ( custname like '%" + document.all.custname.value + "%')";
        }
    }*/
    if (trimStr(document.all["custname"].value) != "")
        whereStr += " and ( custname like '%" + document.all.custname.value + "%')";
    if (trimStr(document.all["applyid"].value) != "")
        whereStr += " and ( applyid like '%" + document.all.applyid.value + "%')";
    if (trimStr(document.all["bankid"].value) != "")
        whereStr += " and ( bankid like '%" + document.all.bankid.value + "%')";
    if (trimStr(document.all["opername"].value) != "")
        whereStr += " and ( p.opername like '%" + document.all.opername.value + "%')";

    if (whereStr != document.all["creditraTable"].whereStr) {
        document.all["creditraTable"].whereStr = whereStr + " order by createdate desc ";
        document.all["creditraTable"].RecordCount = "0";
        document.all["creditraTable"].AbsolutePage = "1";
        Table_Refresh("creditraTable"); //刷新表格的内容
    }
}

/**
 * ■检索函数，检索完成后焦点自动定位到检索区域第一个条件中， 并且全选中;
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
    if (trimStr(document.getElementById("custname").value) != "") {
        whereStr += " and ((a.custname like'" + trimStr(document.getElementById("custname").value) + "%')";

    }
    whereStr += " order by a.cust_py asc";
    document.all["creditraTable"].whereStr = whereStr;
    document.all["creditraTable"].RecordCount = "0";
    document.all["creditraTable"].AbsolutePage = "1";
    Table_Refresh("creditraTable", false, body_resize);
}

//条码管理
function creditraTable_barCodeManage_click() {
    // 增加系统锁检查
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
    arg.doType = "edit";  // 操作类型：edit
    arg.proj_no = custno;
    var ret = dialog("/UI/ccb/loan/specialBusiness/spclBusBarCodeEdit.jsp?custno=" + custno + "&doType=edit", arg, sfeature);
    if (ret == "1") {
        document.getElementById("creditraTable").RecordCount = "0";
        Table_Refresh("creditraTable", false, body_resize);
    }
}


