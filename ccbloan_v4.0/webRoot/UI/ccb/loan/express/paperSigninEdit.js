var dw_column;
var operation;
/**
 * 初始化form表单内容，根据主键取出详细信息，包括查询、删除、修改
 */
function formInit() {
    // 初始化事件
    var arg = window.dialogArguments;

    if (arg) {
        operation = arg.doType;
        if (operation != "add") {
            load_form();
        }

        //入库日期默认为系统时间
        if (document.getElementById("EXP_PAPER_SIGNIN_DATE").value == "") {
            var date = new Date();
            document.getElementById("EXP_PAPER_SIGNIN_DATE").value = getDateString(date);
            document.getElementById("EXP_PAPER_SIGNIN_DATE").readOnly = "readOnly";
        }

        // 只读情况下，页面所有空间禁止修改
        if (operation == "select" || operation == "delete") {
            readFun(document.getElementById("editForm"));
        }

    }
    // 初始化数据窗口，校验的时候用
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // 设置默认焦点；入库日期
    if (operation != "select") {
        document.getElementById("EXP_PAPER_SIGNIN_DATE").focus();
    }
}


/**
 * 保存函数，包括增加、修改都调用该函数
 */
function saveClick() {

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "mort01", "add");
    } else if (operation = "edit") {
        //权证签收 21A
        document.getElementById("MORTSTATUS").value = "21A";
        document.getElementById("busiNode").value = BUSINODE_070;
        retxml = createExecuteform(editForm, "update", "mort01", "edit");
    }
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
