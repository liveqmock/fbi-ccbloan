var dw_column;
/**
 * 初始化form表单内容，根据主键取出详细信息，包括查询、删除、修改
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // 设置默认焦点
    document.getElementById("boxid").focus();
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
    if ( undefined == window.dialogArguments.strBoxid){
        document.getElementById("strBoxid").value = "";
    } else{
        document.getElementById("strBoxid").value = window.dialogArguments.strBoxid;
    }
}

function saveClick() {

    /*    var doType = document.all.doType.value;
     if (dw_column.validate() != null)
     return;
     var arg = new Object();

     var retxml = "";

     if (doType == "add") {
     retxml = createExecuteform(editForm, "insert", "acct01", "add");
     } else if (doType == "edit") {
     retxml = createExecuteform(editForm, "update", "acct01", "getAcctNo");
     }

     if (analyzeReturnXML(retxml) + "" == "true") {
     window.returnValue = "1";
     window.close();
     }*/
    /*    if (operation = "edit") {
     arg.ACCT_AMT = document.getElementById("ACCT_AMT").value;
     window.returnValue = arg;
     window.close();
     }*/


    var doType = document.all.doType.value;

    if (dw_column.validate() != null){
        return;
    }
    var retxml = "";
    // 贷款管理
//    document.getElementById("busiNode").value = BUSINODE_130;
    if (doType == "add") {
        retxml = createExecuteform(editForm, "update", "mort01", "boxEdit");
    } else if (doType == "edit") {
        retxml = createExecuteform(editForm, "update", "mort01", "boxEdit");
    } else if (doType == "batchadd") {
        retxml = createExecuteform(editForm, "update", "mort01", "boxBatchEdit");
    } else if (doType == "batchedit") {
        retxml = createExecuteform(editForm, "update", "mort01", "boxBatchEdit");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
