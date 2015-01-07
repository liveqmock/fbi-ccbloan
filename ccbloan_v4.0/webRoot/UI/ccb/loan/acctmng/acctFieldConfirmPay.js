var dw_column;
/**
 * 初始化form表单内容，根据主键取出详细信息，包括查询、删除、修改
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // 设置默认焦点
    document.getElementById("remark").focus();

    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
}

function saveClick() {

    var doType = document.all.doType.value;

    if (dw_column.validate() != null){
        return;
    }
    var retxml = "";
    // 贷款管理
//    document.getElementById("busiNode").value = BUSINODE_130;
    if (doType == "add") {
        retxml = createExecuteform(editForm, "insert", "acct01", "addAcctField");
    } else if (doType == "edit") {
        retxml = createExecuteform(editForm, "update", "acct01", "getAcctNo");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
