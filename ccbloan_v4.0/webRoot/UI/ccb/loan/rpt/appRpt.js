var dw_form;

/**
 * ��ʼ��
 *
 * @return
 */
function payBillInit() {
    body_init(queryForm, "expExcel");
    // ��ʼ�����ݴ��ڣ�У���ʱ����
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}
/**
 * report
 *
 */
function loanTab_expExcelOver_click() {

    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    if (dw_form.validate() != null)
        return;

    if (trimStr(document.getElementById("MORTEXPIREDATE").value) == "") {
        alert("��ѡ��ʼ���ڣ�");
        return;
    }
    if (trimStr(document.getElementById("MORTEXPIREDATE2").value) == "") {
        alert("��ѡ�������ڣ�");
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

    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    if (dw_form.validate() != null)
        return;

    if (trimStr(document.getElementById("MORTEXPIREDATE").value) == "") {
        alert("��ѡ��ʼ���ڣ�");
        return;
    }
    if (trimStr(document.getElementById("MORTEXPIREDATE2").value) == "") {
        alert("��ѡ�������ڣ�");
        return;
    }

    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "appRptAll.jsp";
    document.getElementById("queryForm").submit();
}