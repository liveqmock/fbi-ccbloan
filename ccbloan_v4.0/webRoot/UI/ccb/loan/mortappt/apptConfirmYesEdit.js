var dw_column;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ���
    document.getElementById("appt_sendback_remark").focus();
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
}

function saveClick() {

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    var arg = new Object();
    if (operation = "edit") {
        //arg.appt_remark = document.getElementById("appt_remark").value;
        arg.appt_sendback_remark = document.getElementById("appt_sendback_remark").value;
        window.returnValue = arg;
        window.close();
    }
}
