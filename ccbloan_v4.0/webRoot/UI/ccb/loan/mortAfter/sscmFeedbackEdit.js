var dw_column;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ���
    document.getElementById("SSCM_STATUS").focus();
    var date = new Date();
    document.getElementById("SSCM_DATE").value = getDateString(date);
    //document.getElementById("SSCM_DATE").readOnly = "readOnly";
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
}

function saveClick() {

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";

    if (document.getElementById("SSCM_STATUS").value == '20') {  //δ��Ѻ
        if (document.getElementById("SSCM_NOCANCEL_REASON").value == "") {
            alert("������δ��Ѻԭ��˵��...");
            return;
        }
    }

    var arg = new Object();
    if (operation = "edit") {
        arg.sscm_status = document.getElementById("SSCM_STATUS").value;
        arg.sscm_date = document.getElementById("SSCM_DATE").value;
        arg.sscm_nocancel_reason = document.getElementById("SSCM_NOCANCEL_REASON").value;
        window.returnValue = arg;
        window.close();
    }
}
