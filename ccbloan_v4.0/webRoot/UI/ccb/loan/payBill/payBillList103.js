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
 */
function loanTab_expExcel_click() {

    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    if (dw_form.validate() != null)
        return;


    var beginDate = new Date(document.getElementById("CUST_OPEN_DT").value.replace(/-/g, "/"));
    var endDate = new Date(document.getElementById("CUST_OPEN_DT2").value.replace(/-/g, "/"));
    if (beginDate > endDate) {
        alert("����ʱ�������ڿ�ʼʱ�䣡");
        return false;
    }
    if (trimStr(document.getElementById("ods_src_dt").value) != "") {
        var ods_src_dt = new Date(document.getElementById("ods_src_dt").value.replace(/-/g, "/"));
        if (endDate > ods_src_dt) {
            alert("����Ľ�ֹ���ڲ��ɳ�����ǰ�����ѷ����Ĵ������ݽ�ֹʱ��:" + document.getElementById("ods_src_dt").value);
            return false;
        }
    }

    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "payBillReport103.jsp";
    document.getElementById("queryForm").submit();
}