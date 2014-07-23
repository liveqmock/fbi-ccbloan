var dw_form;

/**
 * 初始化
 *
 * @return
 */
function payBillInit() {
    body_init(queryForm, "expExcel");
    // 初始化数据窗口，校验的时候用
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}
/**
 * report
 *
 */
function loanTab_expExcelOver_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    if (dw_form.validate() != null)
        return;

    if (trimStr(document.getElementById("MORTEXPIREDATE").value) == "") {
        alert("请选择开始日期！");
        return;
    }
    if (trimStr(document.getElementById("MORTEXPIREDATE2").value) == "") {
        alert("请选结束日期！");
        return;
    }

    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "appRptOver.jsp";
    document.getElementById("queryForm").submit();
}

/**
 * report
 *
 */
function loanTab_expExcelAll_click() {

    // 增加系统锁检查
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    if (dw_form.validate() != null)
        return;

    if (trimStr(document.getElementById("MORTEXPIREDATE").value) == "") {
        alert("请选择开始日期！");
        return;
    }
    if (trimStr(document.getElementById("MORTEXPIREDATE2").value) == "") {
        alert("请选结束日期！");
        return;
    }

    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "appRptAll.jsp";
    document.getElementById("queryForm").submit();
}